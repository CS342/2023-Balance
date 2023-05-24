//
//  Song.swift
//  Balance
//
//  Created by Gonzalo Perisset on 24/05/2023.
//

import SwiftUI

struct Song: Identifiable {
    var id: String { title }
    let title: String
    let artist: String
    let coverString: String
    let spotifyURL: String
}
