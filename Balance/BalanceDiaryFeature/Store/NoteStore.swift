//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

class NoteStore: ObservableObject {
    @Published var notes: [Note] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("diary.data")
    }

    func deleteNote(_ id: String) {
        let indexOfNote = notes.firstIndex { note in
            return note.id == id
        }

        if let indexOfNote {
            notes.remove(at: indexOfNote)
        }
    }

    func saveNote(_ note: Note) {
        let indexOfNote = notes.firstIndex { n in
            return n.id == note.id
        }

        if let indexOfNote {
            notes[indexOfNote] = note
        } else {
            notes.append(note)
        }
    }

    static func load(completion: @escaping (Result<[Note], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let notes = try JSONDecoder().decode([Note].self, from: file.availableData)

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

    static func save(notes: [Note], completion: @escaping(Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(notes)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(notes.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
