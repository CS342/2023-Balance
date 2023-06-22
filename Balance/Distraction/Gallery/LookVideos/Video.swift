//
//  Photo.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/06/2023.
//

import Foundation

struct Video: Codable, Equatable, Hashable, Identifiable {
    var id = UUID().uuidString
    var category: [Category]
    var videoId = ""
    var name = ""
    var highlight = false
    var favorite = false
    var removed = false
}
