//
//  Photo.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/06/2023.
//

import Foundation

struct Photo: Codable, Equatable, Hashable, Identifiable {
    var id = UUID().uuidString
    var category: [Category]
    let name: String
    var review = ""
    var highlight = false
    var favorite = false
    var removed = false
}
