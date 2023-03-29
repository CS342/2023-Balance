//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
// swiftlint:disable closure_body_length
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

public struct HeaderMenu: View {
    @State private var showingSOSSheet = false
    private let title: String
    
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(title)
                    .font(.custom("Nunito-Black", size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: 150)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 60)
                Spacer()
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
                    .padding(.trailing, 10)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .background(Color(#colorLiteral(red: 0.30, green: 0.79, blue: 0.94, alpha: 1.00)))
        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        .ignoresSafeArea(edges: .all)
        .frame(height: 150.0)
    }
    
    public init(title: String) {
        self.title = title
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct HeaderMenu_Previews: PreviewProvider {
    static var previews: some View {
        HeaderMenu(
            title: String("Guided Meditation")
        )
    }
}
