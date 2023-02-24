//
//  NoteItem.swift
//  Balance
//
//  Created by Vishnu Ravi on 2/23/23.
//

import Foundation

struct NoteItem: Codable, Hashable, Identifiable {
    let id: Int
    let text: String
    var date = Date()
    var dateText: String {
        dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
        return dateFormatter.string(from: date)
    }
}
