//
//  AccesoryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 17/04/2023.
//

import SwiftUI

struct AccesoryView: View {
    @Binding var item: Accesory
    @Binding var selectedItem: Accesory.ID?
    @Binding var selectedNameItem: String?
    @State var userCoins = 0
    @State var userId = ""
    @State var profile = ProfileUser()

    var body: some View {
        ZStack(alignment: .center) {
            Image(item.name)
                .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                .scaledToFit()
                .accessibility(hidden: true)
            if userCoins >= item.value {
                checkView
            } else {
                if profile.accesory != item.name {
                    lockView
                }
            }
        }
        .padding(15.0)
        .frame(maxWidth: 100, maxHeight: 100)
        .foregroundColor(darkBlueColor)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .shadow(color: Color.black.opacity(0.10), radius: 7, x: 2, y: 2)
        .onAppear(perform: {
            loadUser()
        })
    }
    
    var checkView: some View {
        Group {
            Image((item.name == selectedNameItem) ? "checkFill" : "check")
                .resizable()
                .frame(width: 40, height: 40)
                .clipped()
                .offset(x: -50, y: -50)
                .accessibility(hidden: true)
            Label("\(item.value)", image: "pointsStarIcon")
                .padding(5)
                .font(.custom("Montserrat-SemiBold", size: 17))
                .foregroundColor(.gray)
                .background(Color.white.opacity(0.6))
                .clipShape(Capsule())
                .shadow(color: .gray, radius: 5)
                .offset(x: 50, y: -50)
        }
    }
    var lockView: some View {
        Group {
            Image("lock")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipped()
                .offset(x: -50, y: -50)
                .accessibility(hidden: true)
            Label("\(item.value)", image: "pointsStarIcon")
                .padding(5)
                .font(.custom("Montserrat-SemiBold", size: 17))
                .foregroundColor(.gray)
                .background(Color.white.opacity(0.6))
                .clipShape(Capsule())
                .shadow(color: .gray, radius: 5)
        }
    }
    func loadUser() {
        userId = UserDefaults.standard.string(forKey: "lastPatient") ?? "0"
        userCoins = UserDefaults.standard.integer(forKey: "\(userId)_coins")
#if !DEMO
        UserProfileRepository.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                self.profile = profileUser
            }
        }
#else
        UserProfileRepositoryToLocal.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                self.profile = profileUser ?? ProfileUser()
            }
        }
#endif
    }
}
