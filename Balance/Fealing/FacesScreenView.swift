//
//  ChillView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

struct FacesScreenView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let faces = [
        Face(
            id: UUID().uuidString,
            title: "Happy",
            image: "happyFace",
            backColor: Color(red: 255.0 / 255.0, green: 208.0 / 255.0, blue: 248.0 / 255.0)
        ),
        Face(
            id: UUID().uuidString,
            title: "Excited",
            image: "excitedFace",
            backColor: Color(red: 217 / 255.0, green: 223 / 255.0, blue: 254 / 255.0)
        ),
        Face(
            id: UUID().uuidString,
            title: "Neutral",
            image: "neutralFace",
            backColor: Color(red: 249 / 255.0, green: 232 / 255.0, blue: 208 / 255.0)
        ),
        Face(
            id: UUID().uuidString,
            title: "Bleh",
            image: "blehFace",
            backColor: Color(red: 238 / 255.0, green: 238 / 255.0, blue: 238 / 255.0)
        ),
        Face(
            id: UUID().uuidString,
            title: "Sad",
            image: "sadFace",
            backColor: Color(red: 202 / 255.0, green: 242 / 255.0, blue: 255 / 255.0)
        ),
        Face(
            id: UUID().uuidString,
            title: "Confused",
            image: "confusedFace",
            backColor: Color(red: 255 / 255.0, green: 253 / 255.0, blue: 200 / 255.0)
        ),
        Face(
            id: UUID().uuidString,
            title: "Angry",
            image: "angryFace",
            backColor: Color(red: 253 / 255.0, green: 146 / 255.0, blue: 146 / 255.0)
        ),
        Face(
            id: UUID().uuidString,
            title: "Frustrated",
            image: "frustratedFace",
            backColor: Color(red: 255 / 255.0, green: 198 / 255.0, blue: 118 / 255.0)
        ),
        Face(
            id: UUID().uuidString,
            title: "Anxious",
            image: "anxiousFace",
            backColor: Color(red: 212 / 255.0, green: 255 / 255.0, blue: 232 / 255.0)
        )
    ]
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroudColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Feeling learning")
                    Spacer().frame(height: 50)
                    titleText
                    Spacer().frame(height: 50)
                    LazyVGrid(columns: columns) {
                        ForEach(faces) { face in
                            NavigationLink(
                                destination: ActivityLogBaseView(
                                    viewName: "Mood Face: " + face.title,
                                    isDirectChildToContainer: true,
                                    content: {
                                        // define content
                                    }
                                )
                            ) {
                                FaceView(faceImage: face.image, faceTitle: face.title, backColor: face.backColor)
                                    .frame(width: 80, height: 120)
                            }
                        }
                    }
                    .padding(.horizontal, 40.0)
                    Spacer()
                }
            }
        }
    }
    
    var titleText: some View {
        Text("Select your mood")
            .font(.custom("Nunito-Bold", size: 25))
            .foregroundColor(violetColor)
            .multilineTextAlignment(.center)
            .lineLimit(4)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 30.0)
            .background(.clear)
    }
}

#if DEBUG
struct FacesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FacesScreenView()
    }
}
#endif
