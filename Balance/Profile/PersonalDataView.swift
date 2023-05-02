//
//  PersonalDataView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import Account
import BalanceContacts
import BalanceMockDataStorageProvider
import BalanceSchedule
import BalanceSharedContext
import SwiftUI
import class FHIR.FHIR
import FirebaseAccount

struct PersonalDataView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @EnvironmentObject var authModel: AuthViewModel
    @State private var displayName = ""
    @State private var parentEmail = ""
    @State private var birthday = ""
    @State private var country = ""
    @State private var phone = ""
    
    var body: some View {
        ZStack {
            backgroudColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Personal Data")
                Spacer().frame(height: 20)
                dataView
                Spacer()
                saveButton
            }
        }.onAppear {
            self.displayName = authModel.profile?.displayName ?? ""
            self.parentEmail = authModel.profile?.parentEmail ?? ""
            self.birthday = authModel.profile?.birthday ?? ""
            self.country = authModel.profile?.country ?? ""
            self.phone = authModel.profile?.phone ?? ""
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
//    var dataFields: some View {
//        Group {
//            TextField("Display Name", text: self.dis)
//                            .font(.custom("Montserrat-Thin", size: 16))
//                            .textFieldStyle(.roundedBorder)
//                            .padding(.top, 5)
//                            .padding(.horizontal, 30.0)
//            TextField("Parent Email", text:$parentEmail)
//                            .font(.custom("Montserrat-Thin", size: 16))
//                            .textFieldStyle(.roundedBorder)
//                            .padding(.top, 5)
//                            .padding(.horizontal, 30.0)
//                        TextField("Birthday", text: $birthday)
//                            .font(.custom("Montserrat-Thin", size: 16))
//                            .textFieldStyle(.roundedBorder)
//                            .padding(.top, 5)
//                            .padding(.horizontal, 30.0)
//                        TextField("Country", text: $country)
//                            .font(.custom("Montserrat-Thin", size: 16))
//                            .textFieldStyle(.roundedBorder)
//                            .padding(.top, 5)
//                            .padding(.horizontal, 30.0)
//                        TextField("Phone", text: authModel.profile.phone)
//                            .font(.custom("Montserrat-Thin", size: 16))
//                            .textFieldStyle(.roundedBorder)
//                            .padding(.top, 5)
//                            .padding(.horizontal, 30.0)
//        }
//    }
    
    var saveButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Close")
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
struct PersonalDataView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDataView()
    }
}
