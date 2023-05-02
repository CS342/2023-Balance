//
//  PasswordUpdateView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 25/04/2023.
//

import SwiftUI

struct PasswordUpdateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        ZStack {
            backgroudColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Password")
                Spacer().frame(height: 40)
                Text("Password update: ")
                    .font(.custom("Nunito-Bold", size: 18))
                    .foregroundColor(darkBlueColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                ShowHideSecureField("new password", text: $password)
                    .padding()
                    .font(.custom("Montserrat-Regular", size: 17))
                    .foregroundColor(darkGrayColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(lightGrayColor, lineWidth: 1)
                    )
                    .padding(5)
                    .padding(.horizontal, 25)
                ShowHideSecureField("confirme password", text: $confirmPassword)
                    .padding()
                    .font(.custom("Montserrat-Regular", size: 17))
                    .foregroundColor(darkGrayColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(lightGrayColor, lineWidth: 1)
                    )
                    .padding(5)
                    .padding(.horizontal, 25)
                Spacer()
                saveButton
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Save")
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

struct PasswordUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordUpdateView()
    }
}
