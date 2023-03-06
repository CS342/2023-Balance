//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

enum Feature: String, Identifiable, CaseIterable {
    case diary = "diary"
    case meditation = "meditation"
    case distraction = "distraction"
    
    static var allFeatures: [(Feature, RawValue)] {
        var allFeatures: [(Feature, RawValue)] = []
        
        for feature in Feature.allCases {
            allFeatures.append((feature, feature.rawValue))
        }
        
        return allFeatures
    }
    
    var id: RawValue {
        rawValue
    }
}
