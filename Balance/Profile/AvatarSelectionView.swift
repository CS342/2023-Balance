//
//  AvatarView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 14/04/2023.
//

import SwiftUI

class AvatarManager: ObservableObject {
    @Published var avatars = (1...6).map { Avatar(name: "avatar_\($0)") }
}

struct AvatarSelectionView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @Environment(\.dismiss)
    private var dismiss
    @State private var showingAvatarPreviewSheet = false
    @ObservedObject var avatarManager = AvatarManager()
    @State private var avatarSelection: Avatar.ID?
    @State private var avatarSelected = Avatar(name: "")
    @ObservedObject var accesoryManager = AccesoryManager()
    @State private var accesorySelection: Accesory.ID?
    @State private var accesorySelected = Accesory(name: "")
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @State private var profile = ProfileUser()
    @State private var userCoins = 0
    var firstLoad: Bool
    var accesoryLoad: Bool
    
    private var gridItemLayout = [GridItem(.fixed(150)), GridItem(.fixed(150))]
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    if !accesoryLoad {
                        Spacer().frame(height: 50)
                        avatarListView
                    }
                    if !firstLoad {
                        Spacer().frame(height: 50)
                        accesoryListView
                    }
                }
                saveButton
            }.sheet(isPresented: $showingAvatarPreviewSheet) {
                AvatarPreviewView(
                    onboardingSteps: $onboardingSteps,
                    avatarSelection: $avatarSelected,
                    accesorySelection: $accesorySelected,
                    firstLoad: firstLoad,
                    accesoryBuy: accesoryLoad
                )
            }
            .onAppear {
                self.profile = authModel.profile ?? ProfileUser()
                userCoins = UserDefaults.standard.integer(forKey: "\(self.profile.id)_coins")
            }
        }
    }
    
    var saveButton: some View {
        Group {
            if accesoryLoad {
                let minElement = accesoryManager.accesories.min(by: { lhs, rhs in
                    if lhs.value < rhs.value {
                        return true
                    } else {
                        return false
                    }
                })
                
                if userCoins >= minElement?.value ?? 25 {
                    selectButton.background(.clear)
                }
            } else {
                selectButton.background(.clear)
            }
        }
    }
    
    var avatarListView: some View {
        Group {
            Text("Choose your avatar")
                .foregroundColor(violetColor)
                .font(.custom("Nunito-Bold", size: 34))
            Spacer().frame(height: 50)
            LazyVGrid(columns: gridItemLayout, spacing: 40) {
                ForEach($avatarManager.avatars) { $item in
                    AvatarView(item: $item, selectedItem: $avatarSelection)
                        .onTapGesture {
                            if let ndx = avatarManager.avatars.firstIndex(where: { $0.id == avatarSelection }) {
                                avatarManager.avatars[ndx].state = false
                            }
                            avatarSelection = item.id
                            item.state = true
                            avatarSelected = item
                        }
                }
            }
            .padding(10.0)
        }
    }
    
    var accesoryListView: some View {
        Group {
            Text("Choose your accessory")
                .foregroundColor(violetColor)
                .font(.custom("Nunito-Bold", size: 24))
            Spacer().frame(height: 50)
            LazyVGrid(columns: gridItemLayout, spacing: 40) {
                ForEach($accesoryManager.accesories) { $item in
                    AccesoryView(item: $item, selectedItem: $accesorySelection)
                        .onTapGesture {
                            if userCoins >= item.value {
                                if let ndx = accesoryManager.accesories.firstIndex(where: { $0.id == accesorySelection }) {
                                    accesoryManager.accesories[ndx].state = false
                                }
                                accesorySelection = item.id
                                item.state = true
                                accesorySelected = item
                            } else {
                                accesorySelection = nil
                                accesorySelected = Accesory(name: "")
                            }
                        }
                }
            }
        }
    }
    
    var selectButton: some View {
        Group {
            if firstLoad {
                NavigationLink {
                    AvatarPreviewView(
                        onboardingSteps: $onboardingSteps,
                        avatarSelection: $avatarSelected,
                        accesorySelection: $accesorySelected,
                        firstLoad: firstLoad,
                        accesoryBuy: false
                    )
                } label: {
                    Text("Select")
                        .font(.custom("Montserrat-SemiBold", size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44.0)
                        .background(primaryColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 20.0)
                }
            } else {
                Button(action: {
                    showingAvatarPreviewSheet.toggle()
                }) {
                    Text("Select")
                        .font(.custom("Montserrat-SemiBold", size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44.0)
                        .background(primaryColor)
                        .cornerRadius(10)
                        .padding(.horizontal, 20.0)
                }
            }
        }
    }
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>, firstLoad: Bool, accesoryLoad: Bool) {
        self._onboardingSteps = onboardingSteps
        self.firstLoad = firstLoad
        self.accesoryLoad = accesoryLoad
    }
}
