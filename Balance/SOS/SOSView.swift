//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct SOSView: View {
    @Environment(\.dismiss) var dismiss
    var clipsToBounds = false
    
    var body: some View {
        ActivityLogContainer {
            VStack(spacing: 20) {
                Spacer()
                Image("Diary")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100.0, height: 100.0)
                    .accessibilityLabel("Diary")
                Text("Have you ever needed and extra help?")
                    .foregroundColor(.purple)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20.0)
                Text("Let's create your own sos button")
                    .foregroundColor(.gray)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20.0)
                Text("Choose the five ways in wich you would like to get help when you need it")
                    .foregroundColor(.gray)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20.0)
                ScrollView {
                    SOSCellView(title: "Body sensations", subtitle: "lrem ipsum dolor sit amet consecte tuer adipiscing...")
                    SOSCellView(title: "Guided meditation", subtitle: "lrem ipsum dolor sit amet consecte tuer adipiscing...")
                    SOSCellView(title: "Distraction", subtitle: "lrem ipsum dolor sit amet consecte tuer adipiscing...")
                    SOSCellView(title: "Deep breating", subtitle: "lrem ipsum dolor sit amet consecte tuer adipiscing...")
                    SOSCellView(title: "Sensorial activity", subtitle: "lrem ipsum dolor sit amet consecte tuer adipiscing...")
                }
                saveButton
            }
        }.background(backgroundColor)
    }
    
    var saveButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Save")
                .font(.custom("Montserrat-SemiBold", size: 17))
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
struct SOSView_Previews: PreviewProvider {
    static var previews: some View {
        SOSView()
    }
}
#endif
