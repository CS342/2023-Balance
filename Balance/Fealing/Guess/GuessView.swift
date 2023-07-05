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
    @Environment(\.dismiss) var dismiss
    @State var selected = 10
    @State var questionIndex = 0
    @State var stopUserInteraction = false
    @State var questions = [Question]()
    @State var showingAlert = false
    @State var firstTry = true
    @State var correctAnswer = 0
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
            .onAppear(perform: {
                questions = questionArray.prefix(cantAnswer).shuffled()
            })
            .disabled(stopUserInteraction)
            .alert("You got \(correctAnswer)/\(cantAnswer) right on the first try!", isPresented: $showingAlert) {
                Button("Close", role: .cancel) {
                    correctAnswer = 0
                    firstTry = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        dismiss()
                    }
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
            if !questions.isEmpty {
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
    }
    
    var optionsButtons: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 20) {
            if !questions.isEmpty {
                ForEach(questions[questionIndex].options, id: \.id) { box in
                    BoxView(
                        selectedBtn: self.$selected,
                        questionIndex: self.$questionIndex,
                        questions: $questions,
                        stopUserInteraction: $stopUserInteraction,
                        showingAlert: $showingAlert,
                        correctAnswers: $correctAnswer,
                        firstTry: $firstTry,
                        box: box
                    ).animation(.easeInOut(duration: 0.5), value: UUID())
                }
            }
        }.padding()
    }
}

struct GuessView_Previews: PreviewProvider {
    static var previews: some View {
        GuessView()
    }
}
