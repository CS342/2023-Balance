//
//  SignUpView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 27/04/2023.
//

import Account
import class FHIR.FHIR
import FirebaseAccount
import Foundation
import Onboarding
import SwiftUI

// swiftlint: disable type_body_length
struct SignUpView: View {
    @EnvironmentObject var account: Account
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @Environment(\.dismiss) private var dismiss
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @State private var displayName: String = ""
    @State private var email: String = ""
    @State private var parentEmail: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMsg: String = ""
    @State private var country = Country(id: UUID().uuidString, name: "")
    @State private var birthDate = Date.now
    @State var alertMessage: String = ""
    @State private var signUpAlert = false
    let promptText: String = "Select"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center) {
                Spacer().frame(height: 30)
                headerView
                formView
                Spacer().frame(height: 20)
                signUpButton
                signInButton
                Spacer().frame(height: 50)
            }
        }.adaptsToKeyboard()
            .padding(.horizontal, 20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .background(backgroundColor)
            .ignoresSafeArea()
            .onChange(of: authModel.authError) { value in
                if !value.isEmpty {
                    self.alertMessage = value
                    self.signUpAlert = true
                }
            }
            .alert(alertMessage, isPresented: $signUpAlert) {
                Button("OK", role: .cancel) {
                    authModel.authError = ""
                }
            }
    }
    
    var signInButton: some View {
        HStack(alignment: .center) {
            Text("Do you already have an account?")
                .foregroundColor(Color.gray)
                .font(.custom("Montserrat-Regular", size: 15))
            Button {
                dismiss()
            } label: {
                Text("Sign In")
                    .foregroundColor(primaryColor)
                    .font(.custom("Montserrat-SemiBold", size: 17))
            }
        }
    }
    
    var signUpButton: some View {
        Button(
            action: {
                save(
                    value:
                        ProfileUser(
                            id: UUID().uuidString,
                            displayName: displayName,
                            email: email,
                            parentEmail: parentEmail,
                            birthday: birthDate.formatted(date: .numeric, time: .omitted),
                            country: country.name,
                            phone: phone,
                            avatar: "",
                            password: password
                        )
                )
                if !showingAlert {
                    onboardingSteps.append(.avatar)
                }
            }
        ) {
            Text("Sign Up")
                .font(.custom("Montserrat-SemiBold", size: 17))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
        }
        .alert(alertMsg, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(primaryColor)
        .cornerRadius(10)
    }
    
    var formView: some View {
        Group {
            displayNameField
            emailField
            passwordField
            parentMailField
            birthdayField
            countryField
            phoneField
        }
    }
    
    var displayNameField: some View {
        TextField("Display Name", text: $displayName)
            .padding()
            .font(.custom("Montserrat-Regular", size: 17))
            .foregroundColor(darkGrayColor)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lightGrayColor, lineWidth: 1)
            )
            .padding(5)
            .keyboardType(.alphabet)
    }
    
    var emailField: some View {
        TextField("Email", text: $email)
            .padding()
            .font(.custom("Montserrat-Regular", size: 17))
            .foregroundColor(darkGrayColor)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lightGrayColor, lineWidth: 1)
            )
            .padding(5)
            .keyboardType(.emailAddress)
    }
    
    var passwordField: some View {
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
            ShowHideSecureField("Confirm password", text: $confirmPassword)
                .padding()
                .font(.custom("Montserrat-Regular", size: 17))
                .foregroundColor(darkGrayColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(lightGrayColor, lineWidth: 1)
                )
                .padding(5)
        }
    }
    
    var parentMailField: some View {
        TextField("Parent Email", text: $parentEmail)
            .padding()
            .font(.custom("Montserrat-Regular", size: 17))
            .foregroundColor(darkGrayColor)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lightGrayColor, lineWidth: 1)
            )
            .padding(5)
            .keyboardType(.emailAddress)
    }
    
    var birthdayField: some View {
        DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) {
            Text("Birthday")
                .font(.custom("Montserrat-Regular", size: 17))
                    .foregroundColor(darkGrayColor)
                .padding(.leading, 5)
        }.padding(5)
    }
    
    var countryField: some View {
        VStack {
            HStack {
                Text("Country:")
                    .font(.custom("Montserrat-Regular", size: 17))
                    .foregroundColor(darkGrayColor)
                Spacer()
                Picker("Country", selection: $country) {
                    if country.name.isEmpty {
                        Text(promptText).tag(country.id)
                    }
                    ForEach(getLocales(), id: \.self) {
                        Text($0.name).tag($0.id)
                    }
                }.font(.custom("Montserrat-Regular", size: 17))
                    .foregroundColor(primaryColor)
            }
        }
        .padding(5)
        .padding(.leading, 5)
    }
    
    var phoneField: some View {
        TextField("Phone", text: $phone)
            .padding()
            .font(.custom("Montserrat-Regular", size: 17))
            .foregroundColor(darkGrayColor)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lightGrayColor, lineWidth: 1)
            )
            .padding(5)
            .keyboardType(.phonePad)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var headerView: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 50)
            Image("Balloon")
                .resizable()
                .scaledToFit()
                .clipped()
                .frame(width: 300.0)
                .accessibility(hidden: true)
            Text("Create account")
                .multilineTextAlignment(.center)
                .font(.custom("Nunito-Bold", size: 30))
                .foregroundColor(violetColor)
            Spacer().frame(height: 20)
            Text("Hi, how you doin")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Thin", size: 17))
                .foregroundColor(darkGrayColor)
            Text("tell us a bit more about yourself")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Thin", size: 17))
                .foregroundColor(darkGrayColor)
        }
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
    
    func save(value: ProfileUser) {
        do {
            if $displayName.wrappedValue.isEmpty ||
                $email.wrappedValue.isEmpty ||
                $parentEmail.wrappedValue.isEmpty ||
                $birthDate.wrappedValue.toString().isEmpty ||
                $country.name.wrappedValue.isEmpty ||
                $phone.wrappedValue.isEmpty ||
                $password.wrappedValue.isEmpty ||
                $confirmPassword.wrappedValue.isEmpty {
                self.alertMsg = "All the information is required"
                showingAlert = true
                return
            }
            
            if $password.wrappedValue !=
                $confirmPassword.wrappedValue {
                self.alertMsg = "The confirmation password mismatch"
                showingAlert = true
                return
            }
            
            if !isValidPassword() {
                self.alertMsg = "Password Error: \n" + getMissingValidation(str: $password.wrappedValue).rawValue
                showingAlert = true
                return
            }
            
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: "user")
        } catch {
            print("Unable to Encode User (\(error))")
        }
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
        
    fileprivate func getLocales() -> [Country] {
        let locales = Locale.isoRegionCodes
            .filter {
                $0 != "United States"
            }
            .compactMap {
                Country(id: $0, name: Locale.current.localizedString(forRegionCode: $0) ?? $0)
            }
        return [Country(id: "US", name: Locale.current.localizedString(forRegionCode: "US") ?? "United States")] + locales
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        SignUpView(onboardingSteps: $path)
    }
}
