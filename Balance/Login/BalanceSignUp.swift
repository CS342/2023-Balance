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
            Spacer().frame(height: 80)
            Image("BalanceLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300.0, height: 300.0)
                .accessibility(hidden: true)
            Text("Sign up below to begin using Balance")
                .multilineTextAlignment(.center)
                .padding()
            Spacer(minLength: 0)
        }
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
