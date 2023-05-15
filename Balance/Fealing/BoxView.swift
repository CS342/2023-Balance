//
//  BoxView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 15/05/2023.
//

import SwiftUI

struct BoxView: View {
    var box: Box
    @Binding var selectedBtn: Int
    var body: some View {
        Button(action: {
            self.selectedBtn = self.box.id
        }) {
            Text(box.title)
                .foregroundColor(self.selectedBtn == self.box.id ? Color.white : primaryColor)
        }
        .frame(width: 100, height: 50)
        .background(self.selectedBtn == self.box.id ? (self.box.correct ? correctOption : wrongOption) : Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(self.selectedBtn == self.box.id ? (self.box.correct ? correctOption : wrongOption) : primaryColor, lineWidth: 2)
        )
    }
}
