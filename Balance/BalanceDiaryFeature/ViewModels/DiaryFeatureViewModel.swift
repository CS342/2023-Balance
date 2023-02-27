//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import FHIR
import LocalStorage

class DiaryFeatureViewModel: ObservableObject {
    var localStorage = LocalStorage<FHIR>()
    let storageKey = "BALANCE_NOTES"
    
    @Published var notes: [Note] = []

    func saveToStorage() async {
        do {
            try await localStorage.store(
                self.notes,
                storageKey: storageKey,
                settings: .encryptedUsingKeyChain()
            )
        } catch {
            print(error.localizedDescription)
        }
    }

    func readFromStorage() async {
        do {
            let notes = try await localStorage.read(
                [Note].self,
                storageKey: storageKey
            )
            self.notes = notes
        } catch {
            print(error.localizedDescription)
        }
    }
}
