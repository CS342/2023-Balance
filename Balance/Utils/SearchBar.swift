//
//  SearchBar.swift
//  Balance
//
//  Created by Gonzalo Perisset on 17/05/2023.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            searchField
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                }) {
                    Text("Cancel")
                        .font(.custom("Nunito-Bold", size: 17))
                        .foregroundColor(primaryColor)
                        .offset(x: -10)
                }
                .padding(.trailing, 20)
                .transition(.move(edge: .trailing))
                .animation(.default, value: UUID())
            }
        }
    }
    
    var searchField: some View {
        TextField("Search ...", text: $text)
            .padding(7)
            .font(.custom("Montserrat", size: 15))
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 20)
            .onTapGesture {
                self.isEditing = true
            }
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .offset(x: 10)
             
                    if isEditing {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 20)
                                .offset(x: -10)
                        }
                    }
                }
            )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
