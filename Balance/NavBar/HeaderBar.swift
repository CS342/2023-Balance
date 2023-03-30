//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

// swiftlint:disable todo
struct HeaderBar: View {
    @State private var showingSOSSheet = false
    let title: String
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: Constant.navigationBarHeight)
            .foregroundColor(Constant.primaryColor)
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            .edgesIgnoringSafeArea(.top)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                sosButtom
            }
    }
    
    var sosButtom: some View {
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
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        let navigationColor = UIColor(.clear)
        let uiTitleColor = UIColor(.white)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = navigationColor
        appearance.largeTitleTextAttributes = [.foregroundColor: uiTitleColor]
        appearance.titleTextAttributes = [.foregroundColor: uiTitleColor, .font: UIFont(name: "Nunito-Bold", size: 25)]
        navigationBar.prefersLargeTitles = false
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

struct HeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        HeaderBar(title: "Diary")
    }
}
