//
// This source file is part of the Stanford CardinalKit Balance Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import BalanceSharedContext
import class FHIR.FHIR
import FirebaseAccount
import Onboarding
import SwiftUI


struct AccountSetup: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @EnvironmentObject var account: Account
    
    
    var body: some View {
        account
        OnboardingView(
            contentView: {
                VStack {
                    Image(uiImage: Bundle.module.image(withName: "BalanceLogo", fileExtension: "png"))
                        .accessibilityLabel(Text("Balance Logo"))
                    Text("Welcome!")
                        .bold()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                        .padding(.top, 30)
                    Text("Sign up or login to continue.")
                        .multilineTextAlignment(.center)
                }
            }, actionView: {
                actionView
            }
        )
            .onReceive(account.objectWillChange) {
                if account.signedIn {
                    completedOnboardingFlow = true
                }
            }
            .background(Color(#colorLiteral(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
    }
    
    
    @ViewBuilder private var actionView: some View {
//        if account.signedIn {
//            OnboardingActionsView(
//                "ACCOUNT_NEXT".moduleLocalized,
//                action: {
//                    onboardingSteps.append(.locationQuestion)
//                }
//            )
//        }
//        else {
            OnboardingActionsView(
                primaryText: "ACCOUNT_SIGN_UP".moduleLocalized,
                primaryAction: {
                    onboardingSteps.append(.signUp)
                },
                secondaryText: "ACCOUNT_LOGIN".moduleLocalized,
                secondaryAction: {
                    onboardingSteps.append(.login)
                }
            )
//        }
    }
    
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}


#if DEBUG
struct AccountSetup_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    
    static var previews: some View {
        AccountSetup(onboardingSteps: $path)
            .environmentObject(Account(accountServices: []))
            .environmentObject(FirebaseAccountConfiguration<FHIR>(emulatorSettings: (host: "localhost", port: 9099)))
    }
}
#endif
