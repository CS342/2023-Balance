//
//  Draw.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import SwiftUI

public struct Draw: Codable, Equatable, Hashable, Identifiable {
    public let id: String
    let title: String
    let image: Data
    let date: Date
    var backImage: String
}