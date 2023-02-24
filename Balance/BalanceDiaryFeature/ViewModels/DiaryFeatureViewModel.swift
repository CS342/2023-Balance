//
//  DiaryFeatureViewModel.swift
//  Balance
//
//  Created by Vishnu Ravi on 2/23/23.
//

import Foundation
import FHIR
import LocalStorage

class DiaryFeatureViewModel: ObservableObject {
    var localStorage = LocalStorage<FHIR>()
    let storageKey = "BALANCE_NOTES"
    
    @Published var notes: [Note] = [
        Note(id: UUID().uuidString, title: "Note 1", text: "Sample note 1", date: Date().previousDate()),
    ]

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
