//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

// swiftlint:disable all
class ActivityLogLocal: ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case startTime
        case endTime
        case duration
        case actions
    }
    var id = UUID().uuidString
    var startTime = Date(timeIntervalSinceReferenceDate: 0)
    var endTime = Date(timeIntervalSinceReferenceDate: 0)
    var duration: TimeInterval = 0
    var actions: [Action] = []
    
    func reset() {
        id = UUID().uuidString
        startTime = Date(timeIntervalSinceReferenceDate: 0)
        endTime = startTime
        duration = 0
        actions = []
    }
    
    func isEmpty() -> Bool {
        return getDuration() == TimeInterval(0)
    }
    
    func addAction(actionDescription: String) {
        let currentDate = Date.now
        actions.append(Action(time: currentDate, description: actionDescription))
        
        // set start time if this is the first action
        startTime = startTime == Date(timeIntervalSinceReferenceDate: 0) ? currentDate : startTime
    }
    
    func endLog(actionDescription: String) {
        addAction(actionDescription: actionDescription)
        endTime = actions.last!.time
        duration = getDuration()
    }
    
    func getDuration() -> TimeInterval {
        return endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
    }
    
    func toString() -> (String, String, String) {
        let idStr = dateToString(date: startTime)
        let id = id

        let startStr = "start: " + idStr
        let endStr = endTime != Date(timeIntervalSinceReferenceDate: 0) ? "end: " + dateToString(date: endTime) : ""
        let durationStr = "duration: \(duration)"
        
        var actionsStr = ""
        
        for action in actions {
            actionsStr.append("\(dateToString(date: action.time) + " " + action.description)\n")
        }
        
        return (id, idStr, [startStr, actionsStr, durationStr, endStr].joined(separator: "\n"))
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = .current
        
        return formatter.string(from: date)
    }
}


class ActivityLogStore: ObservableObject {
    static let shared = ActivityLogStore()
    @Published var logs: [ActivityLogLocal] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("activityLog.data")
    }

    static func load(completion: @escaping (Result<[ActivityLogLocal], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let notes = try JSONDecoder().decode([ActivityLogLocal].self, from: file.availableData)

                DispatchQueue.main.async {
                    completion(.success(notes))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func save(logs: [ActivityLogLocal], completion: @escaping(Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(logs)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(logs.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func deleteLog(_ id: String) {
        let indexOfLog = logs.firstIndex { log in
            log.id == id
        }

        if let indexOfLog {
            logs.remove(at: indexOfLog)
        }
    }

    func saveLog(_ log: ActivityLogLocal) {
        let indexOfLog = logs.firstIndex { currentLog in
            currentLog.id == log.id
        }

        if let indexOfLog {
            logs[indexOfLog] = log
        } else {
            logs.append(log)
        }
    }
}
