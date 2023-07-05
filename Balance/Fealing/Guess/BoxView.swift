//
//  BoxView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 15/05/2023.
//

import SwiftUI

struct BoxView: View {
    @Binding var selectedBtn: Int
    @Binding var questionIndex: Int
    @Binding var questions: [Question]
    @Binding var stopUserInteraction: Bool
    @Binding var showingAlert: Bool
    @Binding var correctAnswers: Int
    @Binding var firstTry: Bool
    var box: Box

    var body: some View {
        Button(action: {
            self.selectedBtn = self.box.id
            stopUserInteraction = true
            if self.questionIndex < (questions.count - 1) {
                if !self.box.correct {
                    stopUserInteraction = false
                    firstTry = false
                    return
                }
                if firstTry == true {
                    correctAnswers += 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.questionIndex += 1
                    self.selectedBtn = -1
                    stopUserInteraction = false
                    firstTry = true
                }
            } else {
                if !self.box.correct {
                    stopUserInteraction = false
                    firstTry = false
                    return
                }
                if firstTry == true {
                    correctAnswers += 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    showingAlert = true
                }
            }
        }) {
            Text(box.title)
                .foregroundColor(self.selectedBtn == self.box.id ? Color.white : primaryColor)
        }
        .frame(width: 110, height: 50)
        .background(self.selectedBtn == self.box.id ? (self.box.correct ? correctOption : wrongOption) : Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(self.selectedBtn == self.box.id ? (self.box.correct ? correctOption : wrongOption) : primaryColor, lineWidth: 2)
        )
    }
}
