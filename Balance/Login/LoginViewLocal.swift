//
//  SignUpView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import Account
import Combine
import class FHIR.FHIR
import FirebaseAccount
import Onboarding
import SwiftUI

struct LoginViewLocal: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @EnvironmentObject var account: Account
    @AppStorage(StorageKeys.onboardingFlowComplete)
    var completedOnboardingFlow = false
    @Binding var onboardingSteps: [OnboardingFlow.Step]
    @State private var patientID: String = ""
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        Group {
            if !authModel.isLoggedIn {
                ZStack {
                    signInView
                        .adaptsToKeyboard()
                }
            } else {
                Button {
                    NavigationUtil.popToRootView()
                    completedOnboardingFlow = true
                } label: {
                    Text("")
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
            Spacer()
            fieldsView
            Spacer()
            Group {
                loginButton
                Spacer().frame(height: 50)
            }
        }
    }
    
    var fieldsView: some View {
        Group {
            TextField("Name", text: $name)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.default)
                .font(.custom("Montserrat", size: 17))
                .foregroundColor(darkGrayColor)
                .padding(.horizontal, 20)
            Divider()
                .padding(.horizontal, 20)
            Spacer().frame(height: 20)
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.default)
                .font(.custom("Montserrat", size: 17))
                .foregroundColor(darkGrayColor)
                .padding(.horizontal, 20)
            Divider()
                .padding(.horizontal, 20)
            Spacer().frame(height: 20)
            TextField("PatientID", text: $patientID)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
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
                Task {
                    await authModel.signInLocal(patientID: patientID, name: name, email: email) {
                        account.signedIn = true
                        NavigationUtil.popToRootView()
                        authModel.isLoggedIn = true
                        completedOnboardingFlow = true
                    } onError: { errorMessage in
                        print("Login error " + errorMessage)
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
        .padding(.horizontal, 20)
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
    
    func listen() {
#if !DEMO
        authModel.listenAuthentificationState()
#endif
    }
}

struct LoginViewLocal_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    static var previews: some View {
        LoginViewLocal(onboardingSteps: $path)
    }
}
