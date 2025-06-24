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
            return "No se pudo obtener la URL del directorio de documentos."
        case .decodingError(let error):
            return "Error al decodificar los datos: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Error al codificar los datos: \(error.localizedDescription)"
        case .fileAccessError(let error):
            return "Error al acceder al archivo: \(error.localizedDescription)"
        }
    }
}

class ActivityLogStore: ObservableObject {
    static let shared = ActivityLogStore()
    @Published var logs: [ActivityLogEntry] = []
    
    private let fileQueue = DispatchQueue(label: "com.balance.activitylog.filequeue")
    
    private static func fileURL() throws -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ActivityLogError.fileURLNotFound
        }
        let patientId = UserDefaults.standard.string(forKey: "lastPatient") ?? "0"
        return documentDirectory.appendingPathComponent("\(patientId)_activityLog.data")
    }
    
    static func load(completion: @escaping (Result<[ActivityLogEntry], Error>) -> Void) {
        // Ejecuta la carga en la cola serial para evitar conflictos de acceso al archivo
        ActivityLogStore.shared.fileQueue.async {
            do {
                let fileURL = try fileURL()
                
                // Verifica si el archivo existe antes de intentar leerlo
                guard FileManager.default.fileExists(atPath: fileURL.path) else {
                    DispatchQueue.main.async {
                        completion(.success([])) // Si no existe, no es un error, simplemente no hay logs
                    }
                    return
                }
                
                let data = try Data(contentsOf: fileURL) // Leer directamente la data del archivo
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
    
    static func save(logs: [ActivityLogEntry], completion: @escaping(Result<Int, Error>) -> Void) {
        // Ejecuta el guardado en la cola serial para evitar conflictos
        ActivityLogStore.shared.fileQueue.async {
            do {
                let data = try JSONEncoder().encode(logs)
                let outfile = try fileURL()
                try data.write(to: outfile, options: [.atomicWrite]) // .atomicWrite para mayor seguridad
                
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
    
    func removeStore() {
        // Asegura que la operación de borrado también sea serializada
        fileQueue.async {
            do {
                // Primero, vaciar los logs en memoria (esto NO los guarda inmediatamente)
                // Se hará al reescribir con el array vacío.
                let data = try JSONEncoder().encode([ActivityLogEntry]()) // Codificar un array vacío
                let outfile = try ActivityLogStore.fileURL()
                try data.write(to: outfile, options: [.atomicWrite]) // Sobrescribir con datos vacíos
                
                // Actualizar el estado publicado en el hilo principal
                DispatchQueue.main.async {
                    self.logs.removeAll() // Limpiar el array en memoria después de guardar el vacío
                    print("ActivityLogStore removeStore OK: Archivo vaciado.")
                }
            } catch {
                DispatchQueue.main.async {
                    print("ActivityLogStore removeStore ERROR: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteLog(_ id: String) {
        // Modifica logs en el hilo principal ya que es una @Published var
        DispatchQueue.main.async {
            self.logs.removeAll { $0.id == id } // Remover el log directamente
            // Luego, guardar los logs actualizados
            ActivityLogStore.save(logs: self.logs) { result in
                if case .failure(let error) = result {
                    print("Error al guardar logs después de eliminar: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // saveLog mejorada: carga, modifica, guarda, todo serializado
    func saveLog(_ log: ActivityLogEntry) {
        // Todas las operaciones de archivo deben ir a través de la cola serial
        fileQueue.async {
            do {
                let fileURL = try ActivityLogStore.fileURL()
                var currentLogs: [ActivityLogEntry] = []
                
                // Intentar cargar los logs existentes de forma sincrónica en la cola serial
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let data = try Data(contentsOf: fileURL)
                    currentLogs = try JSONDecoder().decode([ActivityLogEntry].self, from: data)
                }
                
                // Modificar el array en memoria de forma segura
                currentLogs.removeAll { $0.id == log.id } // Eliminar si ya existe
                currentLogs.append(log) // Añadir el nuevo o actualizado log
                
                // Guardar los logs modificados
                let encodedData = try JSONEncoder().encode(currentLogs)
                try encodedData.write(to: fileURL, options: [.atomicWrite])
                
                // Actualizar el estado publicado en el hilo principal
                DispatchQueue.main.async {
                    self.logs = currentLogs
                    print("Log guardado y store actualizado en memoria.")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error en saveLog: \(error.localizedDescription)")
                }
            }
        }
    }
}
