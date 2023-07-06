//
//  PersonalDataView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import Account
import SwiftUI
import class FHIR.FHIR
import FirebaseAccount

// swiftlint:disable attributes
struct PersonalDataView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @EnvironmentObject var authModel: AuthViewModel
    @EnvironmentObject var account: Account
    @State private var showingAvatarSheet = false
    @State private var displayName = ""
    @State private var parentEmail = ""
    @State private var birthday = ""
    @State private var country = ""
    @State private var phone = ""
    @State private var alertMessage: String = ""
    @State private var email: String = ""
    @State private var loading = false
    @State private var deleteButton = false
    @State private var showingAlert = false

    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Personal Data")
                    Spacer().frame(height: 20)
                    dataView
                    Spacer()
                    if deleteButton {
                        removeButton
                    }
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
            .onAppear {
                cleanDataView()
            }
            .onShake {
                print("Device shaken!")
                self.deleteButton = true
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    authModel.authError = ""
                }
            }
        }
    }
    
    var dataView: some View {
        Group {
            displayNameView
            parentEmailView
            birthdayView
            countryView
            phoneView
        }
    }
    
    var displayNameView: some View {
        Group {
            Text("Display Name")
                .font(.custom("Nunito-Bold", size: 18))
                .foregroundColor(darkBlueColor)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
            Text(self.displayName)
                .font(.custom("Montserrat-Thin", size: 16))
                .textFieldStyle(.roundedBorder)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
        }
    }
    
    var parentEmailView: some View {
        Group {
            Text("Parent Email")
                .font(.custom("Nunito-Bold", size: 18))
                .foregroundColor(darkBlueColor)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
            Text(self.parentEmail)
                .font(.custom("Montserrat-Thin", size: 16))
                .textFieldStyle(.roundedBorder)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
        }
    }
    
    var birthdayView: some View {
        Group {
            Text("Birthday")
                .font(.custom("Nunito-Bold", size: 18))
                .foregroundColor(darkBlueColor)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
            Text(self.birthday)
                .font(.custom("Montserrat-Thin", size: 16))
                .textFieldStyle(.roundedBorder)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
        }
    }
    
    var countryView: some View {
        Group {
            Text("Country")
                .font(.custom("Nunito-Bold", size: 18))
                .foregroundColor(darkBlueColor)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
            Text(self.country)
                .font(.custom("Montserrat-Thin", size: 16))
                .textFieldStyle(.roundedBorder)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
        }
    }
    
    var phoneView: some View {
        Group {
            Text("Phone")
                .font(.custom("Nunito-Bold", size: 18))
                .foregroundColor(darkBlueColor)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
            Text(self.phone)
                .font(.custom("Montserrat-Thin", size: 16))
                .textFieldStyle(.roundedBorder)
                .padding(.top, 5)
                .padding(.horizontal, 30.0)
        }
    }
    
    var removeButton: some View {
        Button(action: {
            authModel.deleteUser {
                loading = false
                alertMessage = "The user has been deleted."
                self.showingAlert = true
                authModel.signOut(onSuccess: {
                    dismiss()
                    account.signedIn = false
                }) { error in
                    print(error)
                }
            } onError: { errorMessage in
                alertMessage = errorMessage
                self.showingAlert = true
                loading = false
            }
        }) {
            Text("Delete User")
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
    
    func cleanDataView() {
        self.displayName = authModel.profile?.displayName ?? ""
        self.parentEmail = authModel.profile?.parentEmail ?? ""
        self.birthday = authModel.profile?.birthday ?? ""
        self.country = authModel.profile?.country ?? ""
        self.phone = authModel.profile?.phone ?? ""
        self.deleteButton = false
    }
}
struct PersonalDataView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDataView()
    }
}
