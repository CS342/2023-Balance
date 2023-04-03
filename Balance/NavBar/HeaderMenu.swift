//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct HeaderMenu: View {
    @State private var showingSOSSheet = false
    @Environment(\.presentationMode) var presentationMode
    var title: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                backButton
                Spacer()
                titleHeader
                Spacer()
                sosButton
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .background(primaryColor)
        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        .ignoresSafeArea(edges: .all)
        .frame(height: 70.0)
        .navigationBarHidden(true)
        .navigationTitle("")
    }
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
                .padding()
                .background(Color.clear)
        }
    }
    
    var sosButton: some View {
        VStack {
            Button(action: {
                print("SOS!")
                showingSOSSheet.toggle()
            }) {
                Text("SOS")
                    .font(.custom("Nunito-Bold", size: 14))
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color.pink)
                    .clipShape(Circle())
            }
            
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showingSOSSheet) {
                SOSView()
            }
        }
        .frame(width: 40, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 4)
                .allowsHitTesting(false)
        )
        .shadow(color: .gray, radius: 2, x: 0, y: 1)
        .padding()
    }
    
    var titleHeader: some View {
        Text(title)
            .font(.custom("Nunito-Black", size: 25))
            .foregroundColor(.white)
            .frame(maxWidth: 150)
            .multilineTextAlignment(.center)
    }
    
    init(title: String) {
        self.title = title
    }
}

#if DEBUG
struct HeaderMenu_Previews: PreviewProvider {
    static var previews: some View {
        HeaderMenu(
            title: String("Guided Meditation")
        )
    }
}
#endif
