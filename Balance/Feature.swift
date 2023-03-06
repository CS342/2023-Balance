//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

public enum Feature: String, Identifiable, Hashable, CaseIterable {
    
//    let id = UUID()
    case diary = "Diary"
    case meditation = "Meditation"
    case spotify = "Distraction"
    
//    let name: String
//    let icon: String
    
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

//extension Feature {
//    func featureView(with navigationPath: Binding<NavigationPath>) -> some View {
//        @ViewBuilder
//        var featureView: some View {
//            switch self{
//            case .diary:
//                //DiaryHomeView(navigationPath: navigationPath)
//                DiaryHomeView
//            case .meditation:
//                MeditationView(navigationPath: navigationPath)
//            case .spotify:
//                Music(navigationPath: navigationPath)
//            }
//        }
//        return featureView
//    }
//}
