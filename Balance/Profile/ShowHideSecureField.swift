//
//  ShowSecureTextField.swift
//  Balance
//
//  Created by Gonzalo Perisset on 25/04/2023.
//

import SwiftUI

struct ShowHideSecureField: View {
    @Binding private var text: String
    @State private var isSecured = true
    private var title: String
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }.padding(.trailing, 32)
            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
                    .accessibility(hidden: true)
            }
        }
    }
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
}
