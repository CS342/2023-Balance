//
//  PresentBannerManager.swift
//  Balance
//
//  Created by Gonzalo Perisset on 08/08/2023.
//

import SwiftUI

struct DemoBanner {
    let title: String
    let message: String
}

final class PresentBannerManager: ObservableObject {
    @Published var isPresented = false
    
    var banner: DemoBanner? {
        didSet {
            isPresented = banner != nil
        }
    }
    
    func dismiss() {
        if isPresented {
            isPresented = false
        }
    }
}
