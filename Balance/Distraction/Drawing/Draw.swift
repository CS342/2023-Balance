//
//  Draw.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/04/2023.
//

import SwiftUI

public struct Draw: Codable, Equatable, Hashable, Identifiable {
    public var id: String = UUID().uuidString
    var title: String = ""
    var image = Data()
    var date = Date()
    var backImage: String = ""
    var zoom: CGFloat = 1.0
    var offsetX: Double = 0.0
    var offsetY: Double = 0.0
}
