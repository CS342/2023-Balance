//
//  NoteItem.swift
//  Balance
//
//  Created by Vishnu Ravi on 2/23/23.
//

import Foundation

public struct Note: Codable, Equatable, Hashable, Identifiable {
    public let id: String
    let title: String
    let text: String
    let date: Date
}
