//
//  Face.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/05/2023.
//

import Foundation
import SwiftUI

public struct Face: Equatable, Hashable, Identifiable {
    public let id: String
    let title: String
    let image: String
    let backColor: Color
}
