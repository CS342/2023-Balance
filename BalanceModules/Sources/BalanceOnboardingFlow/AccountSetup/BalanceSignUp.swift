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
    var body: some View {
        SignUp {
            Image(uiImage: Bundle.module.image(withName: "Balloon", fileExtension: "png"))
                .padding(.top, 32)
                .accessibility(hidden: true)
            Text("Sign up below to begin using Balance")
                .multilineTextAlignment(.center)
                .padding()
            Spacer(minLength: 0)
        }
        .navigationBarTitleDisplayMode(.large)
        .background(Color(UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
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
