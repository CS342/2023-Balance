//
//  DrawStore.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import SwiftUI

class DrawStore: ObservableObject {
    static let shared = DrawStore()
    @Published var draws: [Draw] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("draw.data")
    }
    
    static func load(completion: @escaping (Result<[Draw], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let draws = try JSONDecoder().decode([Draw].self, from: file.availableData)
                
                DispatchQueue.main.async {
                    completion(.success(draws))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(draws: [Draw], completion: @escaping(Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(draws)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(draws.count))
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
            self.draws.removeAll()
            let data = try JSONEncoder().encode(draws)
            let outfile = try DrawStore.fileURL()
            try data.write(to: outfile)
            print("DrawStore removeStore OK")
        } catch {
            print("DrawStore removeStore ERROR")
        }
    }
    
    func deleteDraw(_ id: String) {
        let indexOfNote = draws.firstIndex { draw in
            draw.id == id
        }
        
        if let indexOfNote {
            draws.remove(at: indexOfNote)
        }
    }
    
    func saveDraw(_ draw: Draw) {
        let indexOfNote = draws.firstIndex { currentNote in
            currentNote.id == draw.id
        }
        
        if let indexOfNote {
            draws[indexOfNote] = draw
        } else {
            draws.append(draw)
        }
    }
}
