//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import BalanceSharedContext
import FHIR
import HealthKitDataSource
import Onboarding
import SwiftUI


struct LocationQuestion: View {
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack (alignment: .center){
                    Text("Where are you at?")
                        .bold()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        .padding(.top, 30)
                                        
                    Image(uiImage: Bundle.module.image(withName: "CloudRight", fileExtension: "png"))
                        .offset(x:100)
                
                    LocationOption(option: "Hospital", illustration: "Hospital")
                    
                    LocationOption(option: "Home", illustration: "Home")
                    
                    Image(uiImage: Bundle.module.image(withName: "CloudLeft", fileExtension: "png"))
                        .offset(x:-100)
                }
            }, actionView: {
                OnboardingActionsView(
                    "Let's get started",
                    action: {
                        completedOnboardingFlow = true
                    }
                )
            }
        )
        .background(Color(UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
    }
}


struct Location_Previews: PreviewProvider {
    static var previews: some View {
        LocationQuestion()
    }
}
