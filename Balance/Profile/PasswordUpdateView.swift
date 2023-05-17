//
//  PasswordUpdateView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 25/04/2023.
//

import SwiftUI

struct PasswordUpdateView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var authModel: AuthViewModel
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State var loading = false
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Password")
                    Spacer().frame(height: 40)
                    titleView
                    passwordFields
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
            .onChange(of: authModel.authError) { response in
                updateData(value: response)
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    authModel.authError = ""
                }
            }
        }
    }
    
    var passwordFields: some View {
        Group {
            ShowHideSecureField("New password", text: $password)
                .padding()
                .font(.custom("Montserrat-Regular", size: 17))
                .foregroundColor(darkGrayColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(lightGrayColor, lineWidth: 1)
                )
                .padding(5)
                .padding(.horizontal, 25)
            ShowHideSecureField("Confirm password", text: $confirmPassword)
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
        Text("Password update: ")
            .font(.custom("Nunito-Bold", size: 18))
            .foregroundColor(darkBlueColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
    }
    
    var saveButton: some View {
        Button(action: {
            if $password.wrappedValue.isEmpty ||
                $confirmPassword.wrappedValue.isEmpty {
                self.alertMessage = "All the information is required"
                showingAlert = true
                return
            }
            
            if $password.wrappedValue !=
                $confirmPassword.wrappedValue {
                self.alertMessage = "Confirmation password mismatch"
                showingAlert = true
                return
            }
            
            if !isValidPassword() {
                self.alertMessage = "Password Error: \n" + getMissingValidation(str: $password.wrappedValue).rawValue
                showingAlert = true
                return
            }
            loading = true
            authModel.updatePassword(password: password)
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
    
    func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = $password.wrappedValue.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@", passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
    
    func getMissingValidation(str: String) -> [String] {
        var errors: [String] = []
        if !NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: str) {
            errors.append("At least one uppercase")
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: str) {
            errors.append("At least one digit")
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: str) {
            errors.append("At least one symbol")
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: str) {
            errors.append("At least one lowercase")
        }
        
        if str.count < 8 {
            errors.append("Min 8 characters total")
        }
        return errors
    }
    
    func updateData(value: String) {
        loading = false
        if !value.isEmpty {
            if value == "OK" {
                self.alertMessage = "Password saved successfully"
                password = ""
                confirmPassword = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            } else {
                self.alertMessage = value
            }
            self.showingAlert = true
        }
    }
}

struct PasswordUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordUpdateView()
    }
}
