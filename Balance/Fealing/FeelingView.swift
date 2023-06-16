//
//  ChillView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

struct FeelingView: View {
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderMenu(title: "Feeling learning")
                    ScrollView(.vertical) {
                        VStack(spacing: 20) {
                            guessOption
                            moodOption
                        }
                        .padding(10)
                        .ignoresSafeArea(.all)
                    }
                }
            }
        }
    }
    
    var guessOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Guess the Emotion Feature",
                isDirectChildToContainer: true,
                content: {
                    GuessView()
                }
            )
        ) {
            CellView(image: "guessIcon", text: "Guess the emotion")
        }
    }
        
    var moodOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "How is your mood Feature",
                isDirectChildToContainer: true,
                content: {
                    FacesScreenView()
                }
            )
        ) {
            CellView(image: "moodIcon", text: "How is your mood")
        }
    }
}

#if DEBUG
struct FeelingView_Previews: PreviewProvider {
    static var previews: some View {
        FeelingView()
    }
}
#endif
