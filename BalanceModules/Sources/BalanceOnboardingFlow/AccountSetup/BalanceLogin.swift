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
            Image(uiImage: Bundle.module.image(withName: "Balloon", fileExtension: "png"))
                .resizable()
                .scaledToFit()
                .padding(.top, 32)
                .accessibility(hidden: true)
            Text("Login below to begin using Balance")
                .multilineTextAlignment(.center)
                .padding()
                .padding()
            Spacer(minLength: 0)
        }
        .navigationBarTitleDisplayMode(.large)
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
