//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public enum Feature: String, Identifiable, Hashable, CaseIterable {
    case diary = "Diary"
    case meditation = "Meditation"
    case spotify = "Distraction"
    
    static var allFeatures: [String] {
        var allFeaturesArray: [String] = []
        
        for feature in Feature.allCases {
            allFeaturesArray.append(feature.rawValue)
        }
        
        return allFeaturesArray
    }
    
    public var id: RawValue {
        rawValue
    }
    
    
}
