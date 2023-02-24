//
//  NoteItem.swift
//  Balance
//
//  Created by Vishnu Ravi on 2/23/23.
//

import Foundation

struct Note: Codable, Equatable {
    let title: String
    let text: String
    let date: Date
}
