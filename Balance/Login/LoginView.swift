//
//  SignUpView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import Account
import BalanceSharedContext
import class FHIR.FHIR
import FirebaseAccount
import Onboarding
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject var account: Account
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Group {
            if !authModel.isLoggedIn {
                signInView
            } else {
                Button {
                    completedOnboardingFlow = true
                } label: {
                    Text("login...")
                        .bold()
                }
            }
        }
        .onAppear(perform: listen)
        .onChange(of: account.signedIn) { value in
            print(value)
            if account.signedIn {
                completedOnboardingFlow = true
            }
        }
        .background(backgroudColor)
    }
    
    var signInView: some View {
        VStack {
            Spacer().frame(height: 100)
            Image("Balance")
                .resizable()
                .scaledToFit()
                .frame(width: 150.0)
                .accessibility(hidden: true)
            Image("Logo")
                .resizable()
                .frame(width: 300.0)
                .scaledToFit()
                .clipped()
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
            Spacer()
            loginButton
        }
    }
    
    var fieldsView: some View {
        Group {
            TextField("Email", text: $emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .font(.custom("Montserrat", size: 17))
                .foregroundColor(darkGrayColor)
            Divider()
            Spacer().frame(height: 20)
            SecureField("Password", text: $password)
                .textContentType(.password)
                .keyboardType(.default)
                .font(.custom("Montserrat", size: 17))
                .foregroundColor(darkGrayColor)
            Divider()
        }
    }
    
    var loginButton: some View {
        Button(
            action: {
                authModel.signIn(
                    emailAddress: emailAddress,
                    password: password
                )
            }
        ) {
            Text("Sign In")
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
    
    func listen() {
        authModel.listenAuthentificationState()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
