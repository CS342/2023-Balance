//
//  AvatarPreviewView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import Account
import BalanceSharedContext
import FirebaseAccount
import class FHIR.FHIR
import SwiftUI

struct AvatarPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @EnvironmentObject var authModel: AuthViewModel
    @Binding var avatarSelection: Avatar?
    @Binding var accesorySelection: Accesory?
    @State var profile = ProfileUser()
    var firstLoad: Bool
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroudColor.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: 50)
                    titlePreview
                    Spacer()
                    Image("stars2")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .clipped()
                        .accessibilityLabel("star2")
                        .offset(x: -100, y: -50)
                    avatarSelected
                    Image("stars1")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                        .clipped()
                        .accessibilityLabel("star1")
                        .offset(x: 100, y: 50)
                    Spacer()
                    saveButton
                    cancelButton
                }
            }
            .onAppear {
                authModel.listenAuthentificationState()
                self.profile = authModel.profile ?? ProfileUser()
            }
            .onChange(of: authModel.profile ?? ProfileUser()) { profile in
                withAnimation(.easeInOut(duration: 1.0)) {
                    self.profile = profile
                }
            }
        }
    }
    
    var titlePreview: some View {
        Text("Well done, this is how your personal avatar looks like now")
            .foregroundColor(violetColor)
            .font(.custom("Nunito-Bold", size: 24))
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .padding(.horizontal, 30.0)
    }
    
    var avatarSelected: some View {
        ZStack {
            Image(avatarSelection?.name ?? "avatar_1")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipped()
                .accessibilityLabel("avatarPreview")
//            if !firstLoad {
//                Image(accesorySelection?.name ?? "acc_1")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 130, height: 130)
//                    .clipped()
//                    .accessibilityLabel("accesoryPreview")
//                    .offset(x: 80, y: 80)
//            }
        }
    }
    
    var saveButton: some View {
        Button(
            action: {
                if firstLoad {
                    var user = retrive()
                    user.avatar = avatarSelection?.name ?? ""
                    authModel.signUp(userData: user)
                } else {
                    UserProfileRepository.shared.fetchCurrentProfile { profileUser, error in
                        if let error = error {
                            print("Error while fetching the user profile: \(error)")
                            return
                        } else {
                            print("User: " + (profileUser?.description() ?? "-"))
                            var loadExistenceProfile = profileUser ?? ProfileUser()
                            loadExistenceProfile.avatar = avatarSelection?.name ?? ""
                            UserProfileRepository.shared.createProfile(profile: loadExistenceProfile) { profile, error in
                                if let error = error {
                                    print("Error while fetching the user profile: \(error)")
                                    return
                                } else {
                                    self.profile = profile ?? ProfileUser()
                                    authModel.profile = profile
                                    print("User: " + (profile?.description() ?? "-"))
                                    NavigationUtil.popToRootView()
                                }
                            }
                        }
                    }
                }
            },
            label: {
                Text("Select")
                    .font(.custom("Montserrat-SemiBold", size: 17))
                    .padding(.horizontal, 10.0)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44.0)
                    .font(.custom("Nunito-Bold", size: 16))
            }
        )
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(primaryColor)
        .cornerRadius(10)
        .padding(.horizontal, 20.0)
        //
        //        Button(action: {
        //            authModel.saveProfileImage(profilePic: avatarSelection?.name)
        ////            if let rootViewController = UIApplication.shared.currentUIWindow()?.rootViewController {
        ////                rootViewController.dismiss(animated: true)
        ////            }
        //        }) {
        //            Text("Select")
        //                font(.custom("Montserrat-SemiBold", size: 17))
        //                .padding(.horizontal, 10.0)
        //                .foregroundColor(.white)
        //                .frame(maxWidth: .infinity)
        //                .frame(height: 44.0)
        //                .font(.custom("Nunito-Bold", size: 16))
        //        }
        //        .buttonBorderShape(.roundedRectangle(radius: 10))
        //        .background(primaryColor)
        //        .cornerRadius(10)
        //        .padding(.horizontal, 20.0)
    }
    
    var cancelButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Change")
                .font(.custom("Montserrat-SemiBold", size: 17))
                .padding(.horizontal, 10.0)
                .foregroundColor(primaryColor)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
                .font(.custom("Nunito-Bold", size: 16))
        }
        .overlay( RoundedRectangle(cornerRadius: 10)
            .stroke(primaryColor, lineWidth: 2))
        .background(.white)
        .padding(.horizontal, 20.0)
    }
    
    func retrive() -> ProfileUser {
        do {
            if let data = UserDefaults.standard.data(forKey: "user") {
                let user = try JSONDecoder().decode(ProfileUser.self, from: data)
                print(user)
                return user
            }
        } catch {
            print("Error decoding: \(error)")
        }
        return ProfileUser()
    }
}
