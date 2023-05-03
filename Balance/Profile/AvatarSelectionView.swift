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

struct AvatarSelectionView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAvatarPreviewSheet = false
    @ObservedObject var avatarManager = AvatarManager()
    @State private var avatarSelection: Avatar.ID?
    @State private var avatarSelected: Avatar?
    @ObservedObject var accesoryManager = AccesoryManager()
    @State private var accesorySelection: Accesory.ID?
    @State private var accesorySelected: Accesory?
    var firstLoad: Bool

    private var gridItemLayout = [GridItem(.fixed(150)), GridItem(.fixed(150))]
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroudColor.edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView {
                        Spacer().frame(height: 50)
                        avatarListView
//                        if !firstLoad {
//                            Spacer().frame(height: 50)
//                            accesoryListView
//                        }
                    }
                    selectButton.background(.clear)
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
        Button(action: {
            showingAvatarPreviewSheet.toggle()
        }) {
            Text("Select")
                .font(.custom("Montserrat-SemiBold", size: 17))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
        }.sheet(isPresented: $showingAvatarPreviewSheet) {
            AvatarPreviewView(
                avatarSelection: $avatarSelected,
                accesorySelection: $accesorySelected,
                firstLoad: firstLoad
            )
            .environmentObject(AuthViewModel())
        }
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(primaryColor)
        .cornerRadius(10)
        .padding(.horizontal, 20.0)
    }
    
    init(firstLoad: Bool) {
        self.firstLoad = firstLoad
    }
}
