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

struct Question: Identifiable {
    var id = UUID()
    var image: String
    var options: [Box]
}

struct GuessView: View {
    @State var selected = 10
    @State var questionIndex = 0
    @State var stopUserInteraction = false
    @State var questions: [Question] = [
        Question(image: "happyEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: true),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "sadEmotion", options: [
            Box(id: 0, title: "Sad", correct: true),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "angryEmotion", options: [
            Box(id: 0, title: "Angry", correct: true),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "excitedEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Excited", correct: true),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "afraidEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Afraid", correct: true),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "shyEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Shy", correct: true),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "guiltyEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Guilty", correct: true),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "tiredEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: true)
        ].shuffled()),
        Question(image: "jealousEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Jealous", correct: true),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "lovedEmotion", options: [
            Box(id: 0, title: "Sad", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Loved", correct: true),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "hopefulEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Hopeful", correct: true),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "boredEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Excited", correct: false),
            Box(id: 5, title: "Bored", correct: true)
        ].shuffled()),
        Question(image: "proudEmotion", options: [
            Box(id: 0, title: "Proud", correct: true),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Afraid", correct: true),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "sorryEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Sorry", correct: true),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "embarrassedEmotion", options: [
            Box(id: 0, title: "Embarrassed", correct: true),
            Box(id: 1, title: "Guilty", correct: false),
            Box(id: 2, title: "Happy", correct: false),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ].shuffled()),
        Question(image: "surprisedEmotion", options: [
            Box(id: 0, title: "Angry", correct: false),
            Box(id: 1, title: "Nervous", correct: false),
            Box(id: 2, title: "Surprised", correct: true),
            Box(id: 3, title: "Calm", correct: false),
            Box(id: 4, title: "Scared", correct: false),
            Box(id: 5, title: "Tired", correct: false)
        ])
    ].shuffled()
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

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
            .disabled(stopUserInteraction)
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
            Text(String(questionIndex + 1) + "/" + String(questions.count))
                .foregroundColor(Color.white)
                .font(.custom("Nunito-Medium", size: 16))
                .zIndex(5)
                .animation(.easeInOut(duration: 0.5), value: UUID())
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
            Image(questions[questionIndex].image)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220, alignment: .center)
                .accessibilityLabel(questions[questionIndex].image)
                .frame(alignment: .center)
                .zIndex(1)
                .animation(.easeInOut(duration: 0.5), value: UUID())
        }
    }
    
    var optionsButtons: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 20) {
            ForEach(questions[questionIndex].options, id: \.id) { box in
                BoxView(
                    selectedBtn: self.$selected,
                    questionIndex: self.$questionIndex,
                    questions: $questions,
                    stopUserInteraction: $stopUserInteraction,
                    box: box
                ).animation(.easeInOut(duration: 0.5), value: UUID())
            }
        }.padding()
    }
}

struct GuessView_Previews: PreviewProvider {
    static var previews: some View {
        GuessView()
    }
}
