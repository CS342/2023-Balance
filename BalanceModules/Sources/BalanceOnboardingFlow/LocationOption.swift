//
// This source file is part of the Stanford CardinalKit Balance Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct LocationOption: View {
    public var option: String
    public var illustration: String

    public var body: some View {
        HStack(spacing: 72) {
            Text(option)
                .font(.title.bold())

            Image(uiImage: Bundle.module.image(withName: illustration, fileExtension: "png"))
                .accessibility(hidden: true)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(20)
        .frame(width: 320)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 5)
    }

    public init(option: String, illustration: String) {
        self.option = option
        self.illustration = illustration
    }
}

struct LocationOption_Previews: PreviewProvider {
    static var previews: some View {
        LocationOption(
            option: "Location",
            illustration: "Hospital"
        )
    }
}
