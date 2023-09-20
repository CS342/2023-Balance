//
// This source file is part of the CS342 2023 Balance project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct HeaderMenu: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                    Text("Back")
                        .foregroundColor(.white)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Back")
                Text("Diary")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .offset(x: -32)
                Image(systemName: "")
                    .foregroundColor(.white)
                    .accessibilityHidden(true)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 20)
        .padding(.top, 60)
        .background(.blue)
        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct HeaderMenu_Previews: PreviewProvider {
    static var previews: some View {
        HeaderMenu()
    }
}
