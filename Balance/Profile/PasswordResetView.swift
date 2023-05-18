//
//  PasswordUpdateView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 25/04/2023.
//

import SwiftUI

struct PasswordResetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authModel: AuthViewModel
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    @State private var email: String = ""
    @State var loading = false
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Forgot Password")
                    Spacer().frame(height: 40)
                    titleView
                    emailField
                    Spacer()
                    saveButton
                }
                if loading {
                    ProgressView("Loading...")
                        .tint(.white)
                        .accentColor(.white)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 200)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(20, corners: .allCorners)
                        .ignoresSafeArea()
                }
            }
            .disabled(loading)
            .onAppear(perform: listen)
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    authModel.authError = ""
                }
            }
        }
    }
    
    var emailField: some View {
        Group {
            TextField("email...", text: $email)
                .padding()
                .font(.custom("Montserrat-Regular", size: 17))
                .foregroundColor(darkGrayColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(lightGrayColor, lineWidth: 1)
                )
                .padding(5)
                .padding(.horizontal, 25)
        }
    }
    
    var titleView: some View {
        Text("Please enter your email: ")
            .font(.custom("Nunito-Bold", size: 18))
            .foregroundColor(darkBlueColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
    }
    
    var saveButton: some View {
        Button(action: {
            loading = true
            authModel.passwordReset(
                email: email,
                onSuccess: {
                    alertMessage = "We send you and email to reset the password."
                    self.showingAlert = true
                    loading = false
                }, onError: { errorMessage in
                    alertMessage = errorMessage
                    self.showingAlert = true
                    loading = false
                }
            )
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
    
    func listen() {
        authModel.listenAuthentificationState()
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
