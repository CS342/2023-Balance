//
// This source file is part of the Stanford CardinalKit Balance Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import BalanceSharedContext
import CardinalKit
import class FHIR.FHIR
import Firebase
import FirebaseAccount
import FirebaseAuth
import FirebaseConfiguration
import FirebaseCore
import Onboarding
import SwiftUI

// swiftlint: disable closure_body_length
struct AccountSetup: View {
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    @EnvironmentObject var account: Account
    @EnvironmentObject var usernamePasswordAccountService: UsernamePasswordAccountService
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    Spacer().frame(height: 100)
                    Image(uiImage: Bundle.module.image(withName: "BalanceLogo", fileExtension: "png"))
                        .accessibilityLabel(Text("Balance Logo"))
                    Text("Login")
                        .multilineTextAlignment(.center)
                        .font(.custom("Nunito-Bold", size: 34))
                    Text("Welcome back,")
                        .font(.custom("Nunito-Light", size: 18))
                        .multilineTextAlignment(.center)
                    Text("Sign in to continue.")
                        .font(.custom("Nunito-Light", size: 18))
                    Spacer()
                        .multilineTextAlignment(.center)
//                    TextField("Email", text: $email)
//                        .font(.custom("Nunito-Light", size: 18))
//                    Divider()
//                    HStack {
//                        SecureField("Password", text: $password)
//                            .font(.custom("Nunito-Light", size: 18))
//                        Spacer()
//                        Text("Forgot password?")
//                            .font(.custom("Nunito-Light", size: 18))
//                            .foregroundColor(primaryColor)
//                    }
//
//                    Divider()
                    
                    //                    AccountServicesView(button: account.accountServices.first)
                    //                    usernamePasswordAccountService.resetPasswordButton
                    
                    //                    UsernamePasswordLoginView().environmentObject(usernamePasswordAccountService)
                    
                    //                    Spacer()
                    
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
        .background(.background)
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var actionView: some View {
        //        if account.signedIn {
        //            OnboardingActionsView(
        //                "ACCOUNT_NEXT".moduleLocalized,
        //                action: {
        //                    onboardingSteps.append(.locationQuestion)
        //                }
        //            )
        //        }
        //        else {
        
//        OnboardingActionsView(
//            primaryText: "ACCOUNT_SIGN_UP".moduleLocalized,
//            primaryAction: {
//                onboardingSteps.append(.signUp)
//            },
//            secondaryText: "ACCOUNT_LOGIN".moduleLocalized,
//            secondaryAction: {
//                onboardingSteps.append(.login)
//            }
//        )
        VStack {
            Login()
            HStack(alignment: .center) {
                Text("Don't hace an account?")
                    .font(.custom("Nunito-Light", size: 18))
                Button {
                    onboardingSteps.append(.signUp)
                } label: {
                    Text("Create account")
                        .font(.custom("Nunito-Light", size: 18))
                        .foregroundColor(primaryColor)
                }
            }
        }
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}

struct RedCapsuleBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                Capsule()
                    .foregroundColor(.red)
            )
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
