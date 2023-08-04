//
//  ChillView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/03/2023.
//

import SwiftUI

struct DistractionView: View {
    @State private var currentDraw = Draw()
    @EnvironmentObject var store: DrawStore
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                HeaderMenu(title: "Distraction")
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        picturesOption
                        musicOption
                        videosOption
                        gamesOption
                        drawingOption
                        coloringOption
                    }
                    .padding(20)
                    .ignoresSafeArea(.all)
                }
            }
        }
    }
    
    var coloringOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Coloring Something Feature",
                isDirectChildToContainer: true,
                content: {
                    ColoringHomeView()
                }
            )
        ) {
            CellView(image: "drawingIcon", text: "Coloring something")
        }
    }
    
    var drawingOption: some View {
        NavigationLink(
            destination: ActivityLogBaseView(
                viewName: "Drawing Something Feature",
                isDirectChildToContainer: true,
                content: {
                    DrawHomeView()
                }
            )
        ) {
            CellView(image: "writesIcon", text: "Drawing something")
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
            CellView(image: "sudokuIcon", text: "Games")
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
            CellView(image: "videosIcon", text: "Look at videos")
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
            CellView(image: "musicIcon", text: "Listen to music")
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
            CellView(image: "picturesIcon", text: "Look at pictures")
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
