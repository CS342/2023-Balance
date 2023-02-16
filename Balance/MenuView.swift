//
//  Menu.swift
//  Balance
//
//  Created by Alexis Lowber on 2/16/23.
//

import Diary
import Meditation
import SwiftUI


enum Feature: String, CaseIterable {
    case meditation = "Meditation"
    case diary = "Diary"
    
    func featureView(with navigationPath: Binding<NavigationPath>) -> some View {
        @ViewBuilder
        var featureView: some View {
            switch self {
            case .meditation:
                MeditationView(navigationPath: navigationPath)
            case .diary:
                DiaryView(navigationPath: navigationPath)
            }
        }
        return featureView
    }
}


struct MenuView: View {
    
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        NavigationStack {
            List(Feature.allCases, id: \.self) { feature in
                Section(feature.rawValue) {
                    NavigationLink(feature.rawValue, value: feature)
                }
            }
            .navigationDestination(for: Feature.self) { feature in
                feature.featureView(with: $navigationPath)
            }
            .navigationTitle("Features")
        }
    }
    
    public init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MenuView(navigationPath: .constant(NavigationPath()))
        }
    }
}
