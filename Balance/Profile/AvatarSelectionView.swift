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

class AccesoryManager: ObservableObject {
    @Published var accesories = (1...4).map { Accesory(name: "acc_\($0)") }
}

// swiftlint:disable attributes
struct AvatarSelectionView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAvatarPreviewSheet = false
    @ObservedObject var avatarManager = AvatarManager()
    @State private var avatarSelection: Avatar.ID?
    @State private var avatarSelected = Avatar(name: "")
    @ObservedObject var accesoryManager = AccesoryManager()
    @State private var accesorySelection: Accesory.ID?
    @State private var accesorySelected = Accesory(name: "")
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    var firstLoad: Bool
    
    private var gridItemLayout = [GridItem(.fixed(150)), GridItem(.fixed(150))]
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView {
                        Spacer().frame(height: 50)
                        avatarListView
                        // if !firstLoad {
                        // Spacer().frame(height: 50)
                        // accesoryListView
                        // }
                    }
                    selectButton.background(.clear)
                }.sheet(isPresented: $showingAvatarPreviewSheet) {
                    AvatarPreviewView(
                        onboardingSteps: $onboardingSteps,
                        avatarSelection: $avatarSelected,
                        accesorySelection: $accesorySelected,
                        firstLoad: firstLoad
                    )
                }
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
            Text("Choose your accesory")
                .foregroundColor(violetColor)
                .font(.custom("Nunito-Bold", size: 24))
            Spacer().frame(height: 50)
            LazyVGrid(columns: gridItemLayout, spacing: 40) {
                ForEach($accesoryManager.accesories) { $item in
                    AccesoryView(item: $item, selectedItem: $accesorySelection)
                        .onTapGesture {
                            if let ndx = accesoryManager.accesories.firstIndex(where: { $0.id == accesorySelection }) {
                                accesoryManager.accesories[ndx].state = false
                            }
                            accesorySelection = item.id
                            item.state = true
                            accesorySelected = item
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
                        firstLoad: firstLoad
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
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>, firstLoad: Bool) {
        self._onboardingSteps = onboardingSteps
        self.firstLoad = firstLoad
    }
}
