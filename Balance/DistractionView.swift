//
//  ChillView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

// swiftlint:disable line_length
struct DistractionView: View {
    var body: some View {
        ActivityLogContainer {
            HeaderMenu(title: "Distraction")
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    picturesOption
                    musicOption
                    videosOption
                    gamesOption
                    writeOption
                    drawingOption
                }
                .padding(10)
                .ignoresSafeArea(.all)
            }
        }
    }
    
    var drawingOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Drawing Something Feature",
                isDirectChildToContainer: true,
                content: {
                    // define action
                }
            )
        ) {
            DistractionCellView(image: "drawingIcon", text: "Drawing something", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
        }
    }
    
    var writeOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Write Something Feature",
                isDirectChildToContainer: true,
                content: {
                    // define action
                }
            )
        ) {
            DistractionCellView(image: "writesIcon", text: "Write something", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
        }
    }
    
    var gamesOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Games Feature",
                isDirectChildToContainer: true,
                content: {
                    GamesView()
                }
            )
        ) {
            DistractionCellView(image: "sudokuIcon", text: "Games", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
        }
    }
    
    var videosOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Look Videos Feature",
                isDirectChildToContainer: true,
                content: {
                    VideoGalleryView()
                }
            )
        ) {
            DistractionCellView(image: "videosIcon", text: "Look videos", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
        }
    }
    
    var musicOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Listen music Feature",
                isDirectChildToContainer: true,
                content: {
                    Music()
                }
            )
        ) {
            DistractionCellView(image: "musicIcon", text: "Listen to music", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
        }
    }
    
    var picturesOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Look at pictures Feature",
                isDirectChildToContainer: true,
                content: {
                    GalleryView()
                }
            )
        ) {
            DistractionCellView(image: "picturesIcon", text: "Look at pictures", textDescription: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", pointVal: "+5")
        }
    }
}

#if DEBUG
struct DistractionView_Previews: PreviewProvider {
    static var previews: some View {
        DistractionView()
    }
}
#endif
