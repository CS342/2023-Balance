//
//  StorageManager.swift
//  Balance
//
//  Created by Alexis Lowber on 3/5/23.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

// swiftlint:disable all

struct LogAction: Codable {
    let sessionID: String
    let sessionStartTime: Date
    let sessionEndTime: Date
    let sessionDuration: Int
    let description: String
    let startTime: Date
    let endTime: Date
    let duration: Int
}

struct Action: Codable {
    var id = UUID().uuidString
    let description: String
    let startTime: Date
    var endTime = Date.now
    var duration: Int = 0
}

private let coinsEligibleViews: Set<String> = [
    "Image Highlight", "Image Selected", "Video Highlight", "Video Selected",
    "Sudoku Game", "Crossover Game", "Tetris Game", "Simon Says Game",
    "Bouncing Ball Game", "2048 Game", "Solitaire Game", "Guess the Emotion",
    "How is your mood", "New Draw", "Mandala Selected", "Coloring Saved",
    "Draw Saved", "Playing Spotify", "Body sensations Part",
    "Breathing Feature", "Guided meditation Feature"
]

class ActivityLogEntry: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case startTime
        case endTime
        case duration
        case entries = "actions"
        case pendingEntry
    }

    var id = UUID().uuidString
    var startTime = Date()
    var endTime = Date.now
    var duration: Int = 0
    var entries: [Action] = []
    var pendingEntry: Action?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc private func handleWillEnterForeground() {
        let spotifyWasActive = UserDefaults.standard.bool(forKey: StorageKeys.spotifyConnect)
        if !spotifyWasActive {
#if DEBUG
            print("[ActivityLogEntry][handleWillEnterForeground] - Resetting entry")
#endif
            reset()
        }
    }

    // Push new view. Finalizes previous pending entry first.
    func push(viewName: String) {
#if DEBUG
        print("[ActivityLogEntry][push] - viewName: \(viewName), entries: \(entries.count + 1)")
#endif
        let now = Date.now
        finalizePending(at: now)
        pendingEntry = Action(description: viewName, startTime: now)
        if entries.isEmpty {
            startTime = now
        }
    }

    // Finalize current pending entry (onDisappear or app background).
    func finalizePending() {
        finalizePending(at: Date.now)
    }

    private func finalizePending(at endDate: Date) {
        guard var pending = pendingEntry else { return }
        let interval = endDate - pending.startTime
        pending.endTime = endDate
        pending.duration = interval.second ?? 0
        entries.append(pending)
        pendingEntry = nil

        if coinsEligibleViews.contains(pending.description) && (pending.duration > coinsTime) {
            NotificationCenter.default.post(name: Notification.Name.coinsUpdate, object: nil)
        }

        if let first = entries.first {
            startTime = first.startTime
        }
        endTime = endDate
        duration = (endTime - startTime).second ?? 0
#if DEBUG
        print("[ActivityLogEntry][finalizePending] - Finalized: \(pending.description), duration: \(pending.duration)s")
#endif
    }

    // Instantaneous button-press event (no duration).
    func addButtonEvent(description: String) {
        let now = Date.now
        entries.append(Action(description: description, startTime: now, endTime: now, duration: 0))
#if DEBUG
        print("[ActivityLogEntry][addButtonEvent] - \(description)")
#endif
    }

    func reset() {
        id = UUID().uuidString
        startTime = Date()
        endTime = startTime
        duration = 0
        entries = []
        pendingEntry = nil
    }

    func isEmpty() -> Bool {
        return entries.isEmpty
    }

    func getDuration() -> TimeInterval {
        return endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
    }

    func toString() -> (String, String) {
        let idStr = dateToString(date: startTime)
        let startStr = "start: " + idStr
        let endStr = endTime != Date(timeIntervalSinceReferenceDate: 0) ? "end: " + dateToString(date: endTime) : ""
        let durationStr = "duration: \(duration)"
        var actionsStr = ""
        for entry in entries {
            actionsStr.append("\(dateToString(date: entry.startTime) + " " + entry.description)\n")
        }
        return (idStr, [startStr, actionsStr, durationStr, endStr].joined(separator: "\n"))
    }

    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
}


class ActivityStorageManager {
    static let shared = ActivityStorageManager()

    func uploadActivity(activityLogEntry: ActivityLogEntry) {
        guard !activityLogEntry.isEmpty() else {
            print("Cannot send activity data without both start and end time fields")
            return
        }

        guard let user = Auth.auth().currentUser else {
#if DEBUG
            print("Error finding current user (FIRUser)")
#endif
            return
        }
        let userID = user.uid

        let database = Firestore.firestore()
        let startID = "\(activityLogEntry.dateToString(date: activityLogEntry.startTime))"

        do {
            try database.collection("users").document("\(userID)/activity/\(startID).txt").setData(from: activityLogEntry)
        } catch let error {
            print("Error writing activity to Firestore: \(error)")
        }
    }
}
