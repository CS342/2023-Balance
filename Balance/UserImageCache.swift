//
//  UserImageCache.swift
//  Balance
//
//  Created by Gonzalo Perisset on 21/06/2023.
//

import SwiftUI

// swiftlint:disable convenience_type
// swiftlint:disable force_try
struct UserImageCache {
    static func save(_ photos: [Photo], key: String) {
        let data = photos.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func load(key: String) -> [Photo] {
        guard let encodedData = UserDefaults.standard.array(forKey: key) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(Photo.self, from: $0) }
    }
    
    static func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
