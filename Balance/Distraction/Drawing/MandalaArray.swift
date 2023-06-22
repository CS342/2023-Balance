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
    Category(id: 2, name: "Famous Paintings"),
    Category(id: 3, name: "Plants")
]

var mandalaArray: [Mandala] = [
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-1", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-2", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-3", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-4", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-5", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-6", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-7", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-8", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-9", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-10", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-11", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[1]], name: "animals-12", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-1", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-2", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-3", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-4", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-5", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-6", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-7", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-8", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-9", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-10", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-11", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-12", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-13", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-14", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-15", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-16", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-17", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-18", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-19", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[2]], name: "funnyImages-20", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-1", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-2", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-3", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-4", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-5", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-6", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-7", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-8", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-9", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-10", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-11", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-12", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-13", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-14", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-15", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-16", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-17", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-18", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-19", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-20", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-21", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-22", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-23", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-24", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-25", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-26", highlight: true),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-27", highlight: false),
    Mandala(category: [mandalaCategoryArray[0], mandalaCategoryArray[3]], name: "landscape-28", highlight: false)
]
