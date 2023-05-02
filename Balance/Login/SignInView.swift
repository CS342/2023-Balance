//
//  SignInView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 27/04/2023.
//

import Account
import BalanceSharedContext
import class FHIR.FHIR
import FirebaseAccount
import Onboarding
import SwiftUI

struct SignInView: View {
    @EnvironmentObject var account: Account
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @Environment(\.dismiss) private var dismiss
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @State private var displayName: String = ""
    @State private var email: String = ""
    @State private var parentEmail: String = ""
    @State private var birthday: String = ""
    @State private var country: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        OnboardingView(
            contentView: {
                headerView
                formView
            }, actionView: {
                actionView
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .background(backgroudColor)
        .ignoresSafeArea()
    }
    
    @ViewBuilder private var actionView: some View {
        VStack(alignment: .center) {
            signUpButton
            HStack(alignment: .center) {
                Text("Do you already have an account?")
                    .foregroundColor(Color.gray)
                    .font(.custom("Montserrat-Regular", size: 15))
                Button {
                    dismiss()
                } label: {
                    Text("Sign In")
                        .foregroundColor(primaryColor)
                        .font(.custom("Montserrat-SemiBold", size: 15))
                }
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
                            birthday: birthday,
                            country: country,
                            phone: phone,
                            avatar: "",
                            password: password
                        )
                )
                onboardingSteps.append(.avatar)
            }
        ) {
            Text("Sign Up")
                .font(.custom("Montserrat-SemiBold", size: 17))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
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
    }
    
    var passwordField: some View {
        Group {
            ShowHideSecureField("new password", text: $password)
                .padding()
                .font(.custom("Montserrat-Regular", size: 17))
                .foregroundColor(darkGrayColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(lightGrayColor, lineWidth: 1)
                )
                .padding(5)
            ShowHideSecureField("confirme password", text: $confirmPassword)
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
    }
    
    var birthdayField: some View {
        TextField("Birthday", text: $birthday)
            .padding()
            .font(.custom("Montserrat-Regular", size: 17))
            .foregroundColor(darkGrayColor)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lightGrayColor, lineWidth: 1)
            )
            .padding(5)
    }
    
    var countryField: some View {
        TextField("Country", text: $country)
            .padding()
            .font(.custom("Montserrat-Regular", size: 17))
            .foregroundColor(darkGrayColor)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lightGrayColor, lineWidth: 1)
            )
            .padding(5)
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
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: "user")
        } catch {
            print("Unable to Encode User (\(error))")
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        SignInView(onboardingSteps: $path)
    }
}
