//
// This source file is part of the Stanford CardinalKit Balance Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import Onboarding
import SwiftUI


struct BalanceSignUp: View {
    static let parentEmail = SignUpOptions(rawValue: 1 << 4)
    @EnvironmentObject var account: Account
    @EnvironmentObject var usernamePasswordAccountService: UsernamePasswordAccountService

    var body: some View {
        SignUp {
            Image(uiImage: Bundle.module.image(withName: "Balloon", fileExtension: "png"))
                .resizable()
                .scaledToFit()
                .padding(.top, 32)
                .accessibility(hidden: true)
            Text("Sign up below to begin using Balance")
                .multilineTextAlignment(.center)
                .padding()
            Spacer(minLength: 0)
        }
        .navigationBarTitleDisplayMode(.large)
        .background(backgroundColor)
    }
}


#if DEBUG
struct BalanceSignUp_Previews: PreviewProvider {
    static var previews: some View {
        BalanceSignUp()
            .environmentObject(Account(accountServices: []))
    }
}
#endif
