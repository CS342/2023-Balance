//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

class ActivityLogStore: ObservableObject {
    static let shared = ActivityLogStore()
    @Published var logs: [ActivityLogEntry] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("activityLog.data")
    }
    
    static func load(completion: @escaping (Result<[ActivityLogEntry], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let logs = try JSONDecoder().decode([ActivityLogEntry].self, from: file.availableData)
                
                DispatchQueue.main.async {
                    completion(.success(logs))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(logs: [ActivityLogEntry], completion: @escaping(Result<Int, Error>) -> Void) {
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
    
    func removeStore() {
        do {
            self.logs.removeAll()
            let data = try JSONEncoder().encode(logs)
            let outfile = try ActivityLogStore.fileURL()
            try data.write(to: outfile)
            print("ActivityLogStore removeStore OK")
        } catch {
            print("ActivityLogStore removeStore ERROR")
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
    
    func saveLog(_ log: ActivityLogEntry) {
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
