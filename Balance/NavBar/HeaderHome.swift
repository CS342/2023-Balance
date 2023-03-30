//
// This source file is part of the CS342 2023 Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
// swiftlint:disable closure_body_length

public struct HeaderHome: View {
    @State private var showingSOSSheet = false
    @State private var showingHomeSheet = false
    @State private var showingPointsSheet = false
    
    let name: String
    let avatar: String
    let userID: String
    
    public var body: some View {
        VStack {
            HStack {
                Image(avatar)
                    .resizable()
                    .scaledToFit()
                    .background(Color.white)
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .shadow(color: .gray, radius: 2, x: 0, y: 1)
                    .padding(.leading, 20.0)
                    .accessibilityLabel("avatar")
                VStack {
                    Text("ID " + userID)
                        .font(.custom("Nunito-Light", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Hi, " + name)
                        .font(.custom("Nunito-Bold", size: 25))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                VStack {
                    Button(action: {
                        showingSOSSheet.toggle()
                        print("SOS!")
                    }) {
                        Text("SOS")
                            .font(.custom("Nunito-Bold", size: 14))
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color.pink)
                            .clipShape(Circle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showingSOSSheet) {
                        SOSView()
                    }
                }
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 4)
                )
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
                .padding(.trailing, 10)
                .padding(.bottom, 50)
            }
            HStack {
                Button(action: {
                    showingHomeSheet.toggle()
                    print("home")
                }) {
                    ZStack {
                        Text("Home")
                            .font(.custom("Nunito-Light", size: 12))
                            .frame(width: 100, height: 30)
                            .foregroundColor(Color.black)
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        Image(systemName: "house.fill")
                            .foregroundColor(Color.purple.opacity(0.8))
                            .padding(.trailing, 65.0)
                        VStack {
                            Button(action: {
                                showingHomeSheet.toggle()
                                print("edit")
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                            //                            .sheet(isPresented: $showingHomeSheet) {
                            //                                LocationView()
                            //                            }
                        }
                        .frame(width: 20, height: 20)
                        .shadow(color: .gray, radius: 2, x: 0, y: 1)
                        .padding(.leading, 90)
                        .padding(.top, 20.0)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingHomeSheet) {
                    LocationView()
                }
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
                .padding(.horizontal, 5.0)
                Button(action: {
                    showingPointsSheet.toggle()
                    print("stars!")
                }) {
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
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingPointsSheet) {
                    //                    PointsView()
                }
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
                .padding(.horizontal, 5.0)
            }
            .padding(.top, -20.0)
            
            Text("\"The things tht make me different are the things that make me who i am\"")
                .font(.custom("Nunito-Light", size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
                .padding(.horizontal, 20.0)
                .padding(.top, 0)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 40)
        .frame(height: 250.0)
        .background(Constant.primaryColor)
        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
        .ignoresSafeArea(edges: .all)
        .navigationTitle("")
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}


struct HeaderHome_Previews: PreviewProvider {
    static var previews: some View {
        HeaderHome(name: "Gonzalo", avatar: "BalanceLogo", userID: "00007")
    }
}
