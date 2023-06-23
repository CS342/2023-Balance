//
//  PhotoArray.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/06/2023.
//

import SwiftUI

var imageCategoryArray: [Category] = [
    Category(id: 0, name: "All"),
    Category(id: 1, name: "Favorites"),
    Category(id: 2, name: "Animals"),
    Category(id: 3, name: "Funny Images"),
    Category(id: 4, name: "Landscape"),
    Category(id: 5, name: "Inspirational Quotes"),
    Category(id: 6, name: "Uploaded"),
    Category(id: 7, name: "Removed")
]

var photoArray: [Photo] = [
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-1", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-2", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-3", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-4", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-5", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-6", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-7", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-8", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-9", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-10", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-11", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[2]], name: "animals-12", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-1", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-2", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-3", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-4", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-5", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-6", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-7", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-8", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-9", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-10", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-11", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-12", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-13", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-14", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-15", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-16", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-17", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-18", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-19", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[3]], name: "funnyImages-20", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-1", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-2", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-3", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-4", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-5", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-6", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-7", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-8", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-9", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-10", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-11", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-12", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-13", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-14", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-15", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-16", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-17", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-18", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-19", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-20", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-21", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-22", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-23", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-24", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-25", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-26", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-27", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[4]], name: "landscape-28", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-1", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-2", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-3", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-4", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-5", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-6", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-7", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-8", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-9", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-10", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-11", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-12", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-13", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-14", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-15", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-16", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-17", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-18", highlight: true),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-19", highlight: false),
    Photo(category: [imageCategoryArray[0], imageCategoryArray[5]], name: "inspirationalQuotes-20", highlight: false)
]
