//
//  GuessView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 15/05/2023.
//

import SwiftUI

struct Box: Identifiable {
    var id: Int
    var title: String
    var correct: Bool
}

struct GuessView: View {
    @State var selected = 10
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    let boxes: [Box] = [
        Box(id: 0, title: "Angry", correct: false),
        Box(id: 1, title: "Nervous", correct: false),
        Box(id: 2, title: "Happy", correct: false),
        Box(id: 3, title: "Calm", correct: false),
        Box(id: 4, title: "Scared", correct: true),
        Box(id: 5, title: "Tired", correct: false)
    ]
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Feeling learning")
                    Spacer()
                    ZStack(alignment: .topLeading) {
                        questionNumber
                        imageView
                    }
                    Spacer()
                    titleText
                    Spacer()
                    optionsButtons
                }
            }
        }
    }
    
    var questionNumber: some View {
        ZStack {
            Circle()
                .fill(wrongOption)
                .frame(width: 80, height: 80)
                .zIndex(2)
                .padding()
                .shadow(color: Color.gray, radius: 5)
                .zIndex(4)
            Text("1/20")
                .foregroundColor(Color.white)
                .font(.custom("Nunito-Medium", size: 16))
                .zIndex(5)
        }.zIndex(3)
    }
    
    var titleText: some View {
        Text("Which emotion do you see?")
            .font(.custom("Nunito-Bold", size: 25))
            .foregroundColor(darkBlueColor)
            .multilineTextAlignment(.center)
            .lineLimit(4)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 30.0)
            .background(.clear)
    }
    
    var imageView: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(emotionColor)
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(20, corners: .topLeft)
                .cornerRadius(20, corners: .bottomRight)
                .cornerRadius(100, corners: .topRight)
                .cornerRadius(100, corners: .bottomLeft)
                .padding(40)
                .zIndex(0)
            Image("emotion1")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250, alignment: .center)
                .accessibilityLabel("emotion1")
                .frame(alignment: .center)
                .zIndex(1)
        }
    }
    
    var optionsButtons: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 20) {
            ForEach(boxes, id: \.id) { box in
                BoxView(box: box, selectedBtn: self.$selected)  // 2
            }
        }.padding()
    }
}

struct GuessView_Previews: PreviewProvider {
    static var previews: some View {
        GuessView()
    }
}
