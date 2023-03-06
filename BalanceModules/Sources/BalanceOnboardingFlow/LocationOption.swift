//
//  SwiftUIView.swift
//  
//
//  Created by Griffin Somaratne on 3/4/23.
//

import SwiftUI

struct LocationOption: View {
    public var option: String
    public var illustration: String

    var body: some View {
        HStack (spacing: 72) {
            
            Text(option)
                .font(.title.bold())
        
            Image(uiImage: Bundle.module.image(withName: illustration, fileExtension: "png"))

        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(20)
        .frame(width: 320)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 5)
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
