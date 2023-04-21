//
//  Avatar.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import Foundation

public struct Avatar: Codable, Equatable, Hashable, Identifiable {
    public var id = UUID()
    var name: String
    var state = false
}
