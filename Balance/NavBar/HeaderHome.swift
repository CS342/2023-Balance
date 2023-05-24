//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import class FHIR.FHIR
import FirebaseAccount

public struct HeaderHome: View {
    @AppStorage("fromSOS") var fromSOS = false
    @EnvironmentObject var firebaseAccountConfiguration: FirebaseAccountConfiguration<FHIR>
    @EnvironmentObject var authModel: AuthViewModel
    @State private var showingHomeSheet = false
    @State private var showingPointsSheet = false
    @State private var showingAvatarSheet = false
    @State private var displayName = ""
    @State private var avatar = ""
    @State private var userId = ""

    public var body: some View {
        VStack(spacing: 0) {
            if UIDevice.current.hasNotch {
                Spacer().frame(height: notch)
            }
            headerView
            Spacer()
            buttonsView
            Spacer()
            quotasView
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(edges: .all)
        .frame(height: navigationBarHeightHome + (UIDevice.current.hasNotch ? notch : 0.0))
        .background(primaryColor)
        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        .navigationBarHidden(true)
        .navigationTitle("")
        .onAppear {
            authModel.listenAuthentificationState()
            loadUser()
        }
        .onChange(of: authModel.profile) { profile in
            withAnimation(.easeInOut(duration: 1.0)) {
                if profile != nil {
                    self.displayName = profile?.displayName ?? ""
                    self.avatar = profile?.avatar ?? ""
                }
            }
        }
    }
    
    var buttonsView: some View {
        HStack {
            Button(action: {
                showingHomeSheet.toggle()
                print("home")
            }) {
                homeButton
            }
            .buttonStyle(PlainButtonStyle())
            // .sheet(isPresented: $showingHomeSheet) {
            // LocationView()
            // }
            .shadow(color: .gray, radius: 2, x: 0, y: 1)
            .padding(.horizontal, 5.0)
            Button(action: {
                showingPointsSheet.toggle()
                print("stars!")
            }) {
                pointsButton
            }
            .buttonStyle(PlainButtonStyle())
            // .sheet(isPresented: $showingPointsSheet) {
            // PointsView()
            // }
            .shadow(color: .gray, radius: 2, x: 0, y: 1)
            .padding(.horizontal, 5.0)
        }
    }
    
    var pointsButton: some View {
        ZStack {
            Text("0")
                .font(.custom("Nunito-Light", size: 12))
                .frame(width: 100, height: 30)
                .foregroundColor(Color.black)
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            Image("pointsStarIcon").accessibilityLabel("pointsStarIcon")
                .padding(.trailing, 65.0)
        }
    }
    
    var homeButton: some View {
        ZStack {
            Text("Home")
                .font(.custom("Nunito-Light", size: 12))
                .frame(width: 100, height: 30)
                .foregroundColor(Color.black)
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            Image(systemName: "house.fill")
                .foregroundColor(Color.purple.opacity(0.8))
                .accessibilityLabel("house.fill")
                .padding(.trailing, 65.0)
        }
    }
    
    var quotasView: some View {
        Text("\"The things tht make me different are the things that make me who i am\"")
            .font(.custom("Nunito-Light", size: 14))
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
            .shadow(color: .gray, radius: 2, x: 0, y: 1)
            .padding(.horizontal, 20.0)
            .padding(.top, 0)
    }
    
    var headerView: some View {
        HStack {
            profileOption
            profileNameView
            Spacer()
            sosAction
        }
    }
    
    var profileOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Profile view",
                isDirectChildToContainer: true,
                content: {
                    ProfileView()
                }
            )
        ) {
            avatarView
        }
    }
    
    var sosAction: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "SOS ACTION",
                isDirectChildToContainer: true,
                content: {
                    switch DistractMeOption.randomSection() {
                    case .lookPictures:
                        GalleryView()
                    case .listenMusic:
                        MusicListView()
                    case .lookVideos:
                        VideoGalleryView()
                    case .games:
                        GamesView()
                    case .drawing:
                        DrawHomeView()
                    case .coloring:
                        ColoringHomeView()
                    }
                }
            )
        ) {
            Text("SOS")
                .font(.custom("Nunito-Bold", size: 14))
                .frame(width: 40, height: 40)
                .foregroundColor(Color.white)
                .background(Color.pink)
                .clipShape(Circle())
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 4)
                        .allowsHitTesting(false)
                )
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
                .padding()
        }.simultaneousGesture(TapGesture().onEnded {
            self.fromSOS = true
        })
    }
    
    var avatarView: some View {
        Image(self.avatar)
            .resizable()
            .scaledToFit()
            .tint(.gray)
            .frame(width: 100, height: 100)
            .padding(.leading, 20.0)
            .accessibilityLabel("avatar")
            .shadow(color: darkGrayColor, radius: 6)
    }
    
    var profileNameView: some View {
        VStack {
            Text("ID " + (firebaseAccountConfiguration.user?.email ?? "xxxxxx"))
                .font(.custom("Nunito-Light", size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Hi, " + self.displayName)
                .font(.custom("Nunito-Bold", size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func loadUser() {
        UserProfileRepository.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                authModel.profile = profileUser
                self.displayName = authModel.profile?.displayName ?? ""
                self.avatar = authModel.profile?.avatar ?? ""
            }
        }
    }
}

#if DEBUG
struct HeaderHome_Previews: PreviewProvider {
    static var previews: some View {
        HeaderHome()
    }
}
#endif
