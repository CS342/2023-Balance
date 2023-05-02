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

struct BalanceAccount: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @EnvironmentObject var account: Account
    
    var body: some View {
        OnboardingView(
            contentView: {
                LoginView().environmentObject(AuthViewModel())
            }, actionView: {
                actionView
            }
        )
        .onReceive(account.objectWillChange) {
            if account.signedIn {
                completedOnboardingFlow = true
            }
        }
        .ignoresSafeArea()
        .background(backgroudColor)
    }
    
    @ViewBuilder private var actionView: some View {
        HStack(alignment: .center) {
            Text("Don’t have an account?")
                .foregroundColor(Color.gray)
                .font(.custom("Montserrat-Regular", size: 15))
            Button {
                onboardingSteps.append(.signUp)
            } label: {
                Text("Create an account")
                    .foregroundColor(primaryColor)
                    .font(.custom("Montserrat-SemiBold", size: 15))
            }
        }
    }
    
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}


#if DEBUG
struct AccountSetup_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    
    static var previews: some View {
        BalanceAccount(onboardingSteps: $path)
            .environmentObject(Account(accountServices: []))
            .environmentObject(FirebaseAccountConfiguration<FHIR>(emulatorSettings: (host: "localhost", port: 9099)))
    }
}
#endif
