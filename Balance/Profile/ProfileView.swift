//
//  ProfileView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 25/04/2023.
//

import Account
import BalanceOnboardingFlow
import SwiftUI

struct ProfileView: View {
    @State private var showingAvatarSheet = false
    @EnvironmentObject var account: Account

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                HeaderMenu(title: "")
                    .background(primaryColor)
                Button(action: {
                    showingAvatarSheet.toggle()
                    print("avatarView")
                }) {
                    profileView
                }.sheet(isPresented: $showingAvatarSheet) {
                    AvatarSelectionView()
                }
                
                Spacer().frame(height: 50)
                Text("Gonzalo Perisset")
                    .font(.custom("Nunito-Bold", size: 36))
                    .foregroundColor(darkBlueColor)
                Spacer().frame(height: 20)
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        updateOption
                        logoutOption
                    }
                    .padding(10)
                    .ignoresSafeArea(.all)
                }
                Spacer()
            }
        }
    }
    
    var updateOption: some View {
        NavigationLink(
            destination: PasswordUpdateView()
        ) {
            ProfileCellView(image: "directcurrent", text: "Change password")
        }
    }
    
    var logoutOption: some View {
        NavigationLink(
            destination: OnboardingFlow()
        ) {
            ProfileCellView(image: "figure.walk.motion", text: "Logout")
        }.simultaneousGesture(TapGesture().onEnded {
            print("Logout")
           //account = nil
        })
    }
    
    var profileView: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(primaryColor)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 100)
                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            ZStack(alignment: .bottomTrailing) {
                Image("avatar_2")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .shadow(color: .gray, radius: 5)
                    .frame(width: 180, height: 180)
                    .accessibilityLabel("profileImage")
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .accessibilityLabel("profilePlus")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
