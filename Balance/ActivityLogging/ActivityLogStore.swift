//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI

enum ActivityLogError: Error, LocalizedError {
    case fileURLNotFound
    case decodingError(Error)
    case encodingError(Error)
    case fileAccessError(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileURLNotFound:
            return "Could not get the URL for the documents directory."
        case .decodingError(let error):
            return "Error decoding data: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Error encoding data: \(error.localizedDescription)"
        case .fileAccessError(let error):
            return "Error accessing file: \(error.localizedDescription)"
        }
    }
}

class ActivityLogStore: ObservableObject {
    static let shared = ActivityLogStore()
    @Published var logs: [ActivityLogEntry] = []
    
    // Serial queue for all file operations
    private let fileQueue = DispatchQueue(label: "com.balance.activitylog.filequeue")
    
    private static func fileURL() throws -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ActivityLogError.fileURLNotFound
        }
        let patientId = UserDefaults.standard.string(forKey: "lastPatient") ?? "0"
        return documentDirectory.appendingPathComponent("\(patientId)_activityLog.data")
    }
    
    // Improved load function with serial queue
    static func load(completion: @escaping (Result<[ActivityLogEntry], Error>) -> Void) {
        // Execute the load on the serial queue to prevent file access conflicts
        ActivityLogStore.shared.fileQueue.async {
            do {
                let fileURL = try fileURL()
                
                // Check if the file exists before attempting to read it
                guard FileManager.default.fileExists(atPath: fileURL.path) else {
                    DispatchQueue.main.async {
                        completion(.success([])) // If it doesn't exist, it's not an error, simply no logs
                    }
                    return
                }
                
                let data = try Data(contentsOf: fileURL) // Read data directly from the file
                let logs = try JSONDecoder().decode([ActivityLogEntry].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(logs))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(ActivityLogError.decodingError(error))) // Wrap the error
                }
            }
        }
    }
    
    // Improved save function with serial queue
    static func save(logs: [ActivityLogEntry], completion: @escaping(Result<Int, Error>) -> Void) {
        // Execute the save on the serial queue to prevent conflicts
        ActivityLogStore.shared.fileQueue.async {
            do {
                let data = try JSONEncoder().encode(logs)
                let outfile = try fileURL()
                try data.write(to: outfile, options: [.atomicWrite]) // .atomicWrite for increased safety
                
                DispatchQueue.main.async {
                    completion(.success(logs.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(ActivityLogError.encodingError(error))) // Wrap the error
                }
            }
        }
    }
    
    // removeStore improved with serial queue and better error handling
    func removeStore() {
        // Ensure the delete operation is also serialized
        fileQueue.async {
            do {
                // First, clear the logs in memory (this does NOT save them immediately)
                // It will be done by overwriting with the empty array.
                let data = try JSONEncoder().encode([ActivityLogEntry]()) // Encode an empty array
                let outfile = try ActivityLogStore.fileURL()
                try data.write(to: outfile, options: [.atomicWrite]) // Overwrite with empty data
                
                // Update the published state on the main thread
                DispatchQueue.main.async {
                    self.logs.removeAll() // Clear the array in memory after saving the empty one
                    print("ActivityLogStore removeStore OK: File emptied.")
                }
            } catch {
                DispatchQueue.main.async {
                    print("ActivityLogStore removeStore ERROR: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // deleteLog (the internal logic does not need the serial queue if it only modifies the array in memory,
    // but the call to saveLog will use the queue)
    func deleteLog(_ id: String) {
        // Modify logs on the main thread as it is an @Published var
        DispatchQueue.main.async {
            self.logs.removeAll { $0.id == id } // Remove the log directly
            // Then, save the updated logs
            ActivityLogStore.save(logs: self.logs) { result in
                if case .failure(let error) = result {
                    print("Error saving logs after deletion: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Improved saveLog: load, modify, save, all serialized
    func saveLog(_ log: ActivityLogEntry) {
        // All file operations must go through the serial queue
        fileQueue.async {
            do {
                let fileURL = try ActivityLogStore.fileURL()
                var currentLogs: [ActivityLogEntry] = []
                
                // Attempt to load existing logs synchronously in the serial queue
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let data = try Data(contentsOf: fileURL)
                    currentLogs = try JSONDecoder().decode([ActivityLogEntry].self, from: data)
                }
                
                // Modify the array in memory safely
                currentLogs.removeAll { $0.id == log.id } // Eliminar si ya existe
                currentLogs.append(log) // Añadir el nuevo o actualizado log
                
                // Save the modified logs
                let encodedData = try JSONEncoder().encode(currentLogs)
                try encodedData.write(to: fileURL, options: [.atomicWrite])
                
                // Update the published state on the main thread
                DispatchQueue.main.async {
                    self.logs = currentLogs
                    print("Log saved and store updated in memory.")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error in saveLog: \(error.localizedDescription)")
                }
            }
        }
    }
}
