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

struct BalanceLogin: View {
    var body: some View {
        Login {
            Spacer().frame(height: 80)
            Image("BalanceLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300.0, height: 300.0)
                .accessibility(hidden: true)
            Text("Login below to begin using Balance")
                .multilineTextAlignment(.center)
                .padding()
                .padding()
            Spacer(minLength: 0)
        }
        .background(backgroudColor)
    }
}


#if DEBUG
struct BalanceLogin_Previews: PreviewProvider {
    static var previews: some View {
        BalanceLogin()
            .environmentObject(Account(accountServices: []))
    }
}
#endif
