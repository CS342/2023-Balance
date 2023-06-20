//
//  DrawStore.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import SwiftUI

class ColoringStore: ObservableObject {
    static let shared = ColoringStore()
    @Published var coloringDraws: [Draw] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("coloring.data")
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
    
    static func save(coloringDraws: [Draw], completion: @escaping(Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(coloringDraws)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(coloringDraws.count))
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
            self.coloringDraws.removeAll()
            let data = try JSONEncoder().encode(coloringDraws)
            let outfile = try ColoringStore.fileURL()
            try data.write(to: outfile)
            print("ColoringStore removeStore OK")
        } catch {
            print("ColoringStore removeStore ERROR")
        }
    }
    
    func deleteDraw(_ id: String) {
        let indexOfNote = coloringDraws.firstIndex { draw in
            draw.id == id
        }
        
        if let indexOfNote {
            coloringDraws.remove(at: indexOfNote)
        }
    }
    
    func saveDraw(_ draw: Draw) {
        let indexOfNote = coloringDraws.firstIndex { currentNote in
            currentNote.id == draw.id
        }
        
        if let indexOfNote {
            coloringDraws[indexOfNote] = draw
        } else {
            coloringDraws.append(draw)
        }
    }
}
