//
//  BodySensationView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 05/05/2023.
//

import SwiftUI

struct BodySensationView: View {
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroudColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Body sensations")
                    Spacer()
                    titleText
                    Spacer()
                    imageView
                    Spacer()
                    subTitleText
                    bodyButtons
                }
                Spacer()
            }
        }
    }
    
    var bodyButtons: some View {
        VStack {
            HStack {
                headButton
                Spacer()
                feetButton
                Spacer()
                shouldersButton
            }.padding(10)
            HStack {
                handsButton
                Spacer()
                kneeButton
                Spacer()
                legsButton
            }.padding(10)
        }.padding(10)
    }
    
    var headButton: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Body sensations Head",
                isDirectChildToContainer: true,
                content: {
                    NewTimerView(
                        chillType: .head,
                        navTitleText: "Body sensations",
                        subTitleText: "Relax your self and focus on this part of your body"
                    )
                }
            )
        ) {
            Text("Head")
                .foregroundColor(primaryColor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(primaryColor, lineWidth: 2)
                )
        }
    }
    
    var feetButton: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Body sensations Feet",
                isDirectChildToContainer: true,
                content: {
                    NewTimerView(
                        chillType: .feet,
                        navTitleText: "Body sensations",
                        subTitleText: "Relax your self and focus on this part of your body"
                    )
                }
            )
        ) {
            Text("Feet")
                .foregroundColor(primaryColor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(primaryColor, lineWidth: 2)
                )
        }
    }
    
    var shouldersButton: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Body sensations Shoulders",
                isDirectChildToContainer: true,
                content: {
                    NewTimerView(
                        chillType: .shoulders,
                        navTitleText: "Body sensations",
                        subTitleText: "Relax your self and focus on this part of your body"
                    )
                }
            )
        ) {
            Text("Shoulders")
                .foregroundColor(primaryColor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(primaryColor, lineWidth: 2)
                )
        }
    }
    
    var handsButton: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Body sensations Hands",
                isDirectChildToContainer: true,
                content: {
                    NewTimerView(
                        chillType: .hands,
                        navTitleText: "Body sensations",
                        subTitleText: "Relax your self and focus on this part of your body"
                    )
                }
            )
        ) {
            Text("Hands")
                .foregroundColor(primaryColor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(primaryColor, lineWidth: 2)
                )
        }
    }
    
    var kneeButton: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Body sensations Knee",
                isDirectChildToContainer: true,
                content: {
                    NewTimerView(
                        chillType: .knee,
                        navTitleText: "Body sensations",
                        subTitleText: "Relax your self and focus on this part of your body"
                    )
                }
            )
        ) {
            Text("Knee")
                .foregroundColor(primaryColor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(primaryColor, lineWidth: 2)
                )
        }
    }
    
    var legsButton: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Body sensations Legs",
                isDirectChildToContainer: true,
                content: {
                    NewTimerView(
                        chillType: .legs,
                        navTitleText: "Body sensations",
                        subTitleText: "Relax your self and focus on this part of your body"
                    )
                }
            )
        ) {
            Text("Legs")
                .foregroundColor(primaryColor)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(primaryColor, lineWidth: 2)
                )
        }
    }

    var imageView: some View {
            Image("bodyAvatar")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250, alignment: .center)
                .accessibilityLabel("imageBS")
    }
    
    var titleText: some View {
        Text("Hi there, are you ready to listen and feel the sensations of your body?")
            .font(.custom("Nunito-Bold", size: 25))
            .foregroundColor(violetColor)
            .multilineTextAlignment(.center)
            .lineLimit(4)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 30.0)
            .background(.clear)
    }
    
    var subTitleText: some View {
        Text("Select which part of your body you would like to work on")
            .font(.custom("Nunito-Medium", size: 16))
            .foregroundColor(lightGrayColor)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 30.0)
            .background(.clear)
            .frame(height: 50)
    }
}

struct BodySensationView_Previews: PreviewProvider {
    static var previews: some View {
        BodySensationView()
    }
}
