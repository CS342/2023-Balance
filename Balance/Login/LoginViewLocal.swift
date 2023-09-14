//
//  SignUpView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import Combine
import Onboarding
import SwiftUI

// swiftlint:disable line_length
// swiftlint:disable closure_body_length
struct LoginViewLocal: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @State private var patientID: String = ""
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    @State private var isEmailValid = true
    @State private var isChecked = false
    
    var body: some View {
        Group {
            if !authModel.isLoggedIn {
                ZStack {
                    signInView
                        .adaptsToKeyboard()
                }
            }
        }
        .onChange(of: authModel.authError) { value in
            if !value.isEmpty {
                self.alertMessage = value
                self.showingAlert = true
            }
        }
        .background(backgroundColor)
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {
                authModel.authError = ""
            }
        }
        .ignoresSafeArea()
    }
    
    var signInView: some View {
        VStack {
            Spacer().frame(height: 100)
            Image("Balance")
                .resizable()
                .scaledToFit()
                .frame(width: 120.0)
                .accessibility(hidden: true)
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .accessibility(hidden: true)
            Text("Login")
                .multilineTextAlignment(.center)
                .font(.custom("Nunito-Bold", size: 30))
                .foregroundColor(violetColor)
            Text("Welcome back,")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Thin", size: 17))
                .foregroundColor(darkGrayColor)
            Text("Sign in to continue")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Thin", size: 17))
                .foregroundColor(darkGrayColor)
            Spacer().frame(height: 30)
            fieldsView
        }.safeAreaInset(edge: VerticalEdge.bottom) {
            loginButton
        }
    }
    
    var fieldsView: some View {
        Group {
            if isChecked == false {
                nameField
                Divider()
                emailField
                Divider()
            }
            Spacer().frame(height: 20)
            participantField
            Divider()
            Spacer().frame(height: 20)
            passwordField
            Divider()
            existingUser
        }.padding(.horizontal, 20)
    }
    
    var existingUser: some View {
        HStack {
            Spacer()
            Text("Existing user? ")
                .font(.custom("Montserrat", size: 17))
                .foregroundColor(lightGrayColor)
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .accessibility(hidden: true)
                .frame(width: 40, height: 40)
                .foregroundColor(isChecked ? primaryColor : Color.secondary)
                .onTapGesture {
                    self.isChecked.toggle()
                }
        }.padding(.horizontal, 20)
    }
    
    var passwordField: some View {
        SecureField("Password", text: $password)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .keyboardType(.default)
            .font(.custom("Montserrat", size: 17))
            .foregroundColor(darkGrayColor)
    }
    
    var participantField: some View {
        TextField("ParticipantID", text: $patientID)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .keyboardType(.default)
            .font(.custom("Montserrat", size: 17))
            .foregroundColor(darkGrayColor)
    }
    
    var nameField: some View {
        TextField("Name", text: $name)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .keyboardType(.default)
            .font(.custom("Montserrat", size: 17))
            .foregroundColor(darkGrayColor)
    }
    
    var emailField: some View {
        Group {
            Spacer().frame(height: 20)
            TextField("Email", text: $email, onEditingChanged: { isChanged in
                if !isChanged {
                    if self.textFieldValidatorEmail(self.email) {
                        self.isEmailValid = true
                    } else {
                        self.isEmailValid = false
                        self.email = ""
                    }
                }
            })
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .keyboardType(.default)
            .font(.custom("Montserrat", size: 17))
            .foregroundColor(darkGrayColor)
        }
    }
    
    var loginButton: some View {
        Button(
            action: {
                if $patientID.wrappedValue.isEmpty {
                    self.alertMessage = "All the information is required"
                    showingAlert = true
                    return
                }
                
                if $password.wrappedValue.isEmpty {
                    self.alertMessage = "The password is required"
                    showingAlert = true
                    return
                }
                
                if isChecked == true {
                    authModel.loginLocalUser(
                        uid: patientID,
                        password: password,
                        onSuccess: {
                            completedOnboardingFlow = true
                        }, onError: { errorMessage in
                            self.alertMessage = errorMessage
                            showingAlert = true
                            print("Login error " + errorMessage)
                        }
                    )
                } else {
                    if $name.wrappedValue.isEmpty || $email.wrappedValue.isEmpty {
                        self.alertMessage = "All the information is required"
                        showingAlert = true
                        return
                    }
                    
                    if !self.isEmailValid {
                        self.alertMessage = "Email is NOT Valid"
                        showingAlert = true
                        return
                    }
                    
                    if authModel.existLocalUser(uid: patientID) == false {
                        authModel.createLocalUser(
                            uid: patientID,
                            name: name,
                            email: email,
                            password: password,
                            onSuccess: {
                                completedOnboardingFlow = true
                                name = ""
                                patientID = ""
                                email = ""
                                password = ""
                            }, onError: { errorMessage in
                                print("Error while creating the new user \(errorMessage)")
                                self.alertMessage = "Error while creating the new user"
                                showingAlert = true
                                return
                            }
                        )
                    } else {
                        print("Login error there is already a user with that PatiendID ")
                        self.alertMessage = "There is already a user with that PatiendID"
                        showingAlert = true
                        return
                    }
                }
            }
        ) {
            Text("Get started")
                .font(.custom("Montserrat-SemiBold", size: 17))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
        }
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(primaryColor)
        .cornerRadius(10)
        .padding(.all, 20)
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        // let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}
