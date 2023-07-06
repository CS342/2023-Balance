//
//  Question.swift
//  Balance
//
//  Created by Gonzalo Perisset on 05/07/2023.
//

import SwiftUI

struct Question: Identifiable {
    var id = UUID()
    var image: String
    var options: [Box]
}
