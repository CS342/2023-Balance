//
//  PhotoArray.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/06/2023.
//

import SwiftUI

var mandalaCategoryArray: [Category] = [
    Category(id: 0, name: "All"),
    Category(id: 1, name: "Mandalas"),
    Category(id: 2, name: "Nature"),
    Category(id: 3, name: "Words")
]

var mandalaArray: [Mandala] = [
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "mandalas-001", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "mandalas-002", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "mandalas-003", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "mandalas-004", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "mandalas-005", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "nature-001", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "nature-002", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "nature-003", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "nature-004", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "nature-005", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "nature-006", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "words-001", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "words-002", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "words-003", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "words-004", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "words-005", highlight: false)
]
