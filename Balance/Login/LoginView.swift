//
//  SignUpView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import Account
import BalanceSharedContext
import Combine
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
    @Binding var onboardingSteps: [OnboardingFlow.Step]
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert = false

    var body: some View {
        Group {
            if !authModel.isLoggedIn {
                    signInView
                        .adaptsToKeyboard()
            } else {
                Button {
                    NavigationUtil.popToRootView()
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
                NavigationUtil.popToRootView()
                completedOnboardingFlow = true
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
            Spacer()
            Group {
                loginButton
                Spacer().frame(height: 20)
                signupView
                Spacer().frame(height: 20)
            }
        }
    }
    
    var signupView: some View {
        HStack(alignment: .center) {
            Text("Don’t have an account?")
                .foregroundColor(Color.gray)
                .font(.custom("Montserrat-Regular", size: 15))
            Button {
                onboardingSteps.append(.signUp)
            } label: {
                Text("Create an account")
                    .foregroundColor(primaryColor)
                    .font(.custom("Montserrat-SemiBold", size: 15))
            }
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
                .padding(.horizontal, 20)
            Divider()
                .padding(.horizontal, 20)
            Spacer().frame(height: 20)
            SecureField("Password", text: $password)
                .textContentType(.password)
                .keyboardType(.default)
                .font(.custom("Montserrat", size: 17))
                .foregroundColor(darkGrayColor)
                .padding(.horizontal, 20)
            Divider()
                .padding(.horizontal, 20)
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
        .padding(.horizontal, 20)
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
    
    func listen() {
        authModel.listenAuthentificationState()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        LoginView(onboardingSteps: $path)
    }
}
