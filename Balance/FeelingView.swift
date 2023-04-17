//
//  ChillView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

// swiftlint:disable line_length
struct FeelingView: View {
    var body: some View {
        ActivityLogContainer {
            HeaderMenu(title: "Feeling learning")
                 .background(backgroudColor)
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    guessOption
                    mandalaOption
                    moodOption
                }
                .background(backgroudColor)
                .padding(10)
                .ignoresSafeArea(.all)
            }
        }
        .background(backgroudColor)
    }
    
    var guessOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Guess the Emoticon Feature",
                isDirectChildToContainer: true,
                content: {
                    // define content
                }
            )
        ) {
            DistractionCellView(image: "guessIcon", text: "Guess Emoticon", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
        }
    }
    
    var mandalaOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Feeling Mandala Feature",
                isDirectChildToContainer: true,
                content: {
                    // define content
                }
            )
        ) {
            DistractionCellView(image: "mandalaIcon", text: "Feeling Mandala", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
        }
    }
    
    var moodOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "How is your mood Feature",
                isDirectChildToContainer: true,
                content: {
                    // define content
                }
            )
        ) {
            DistractionCellView(image: "moodIcon", text: "How is your mood", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
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
