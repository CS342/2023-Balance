//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct LocationView: View {
    var clipsToBounds = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            titleView
            Spacer()
            NavigationLink(
                destination: ActivityLogBaseView(
                    viewName: "Hospital Selection",
                    isDirectChildToContainer: true,
                    content: {
                        HomeView()
                    }
                )
            ) {
                NavView(image: "hospitalIcon", text: "Hospital")
            }
            NavigationLink(
                destination: ActivityLogBaseView(
                    viewName: "Home Selection",
                    isDirectChildToContainer: true,
                    content: {
                        HomeView()
                    }
                )
            ) {
                NavView(image: "homeIcon", text: "Home")
            }
            Spacer()
            nextButtonView
        }.background(backgroundColor)
    }
    
    var titleView: some View {
        Text("Where are you at?")
            .foregroundColor(.purple)
            .font(.largeTitle)
    }
    
    var nextButtonView: some View {
        Button(action: {
            // define action
        }) {
            Text("Next")
                .font(.system(.title2))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
        }
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(primaryColor)
        .cornerRadius(10)
        .padding(.horizontal, 20.0)
    }
}

#if DEBUG
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
#endif
