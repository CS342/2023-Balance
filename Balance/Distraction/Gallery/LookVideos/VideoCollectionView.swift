//
//  ImageCollectionView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI
import YouTubePlayerKit

struct YoutubeModalView: View {
    var videoID: String
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderMenu(title: "Youtube")
            let youTubePlayer = YouTubePlayer(
                source: .video(id: videoID),
                configuration: .init(
                    fullscreenMode: .system,
                    autoPlay: true,
                    showControls: true
                )
            )
            YouTubePlayerView(youTubePlayer) { state in
                switch state {
                case .idle:
                    ProgressView().tint(.white)
                case .ready:
                    EmptyView()
                case .error(let error):
                    Text(verbatim: "YouTube player couldn't be loaded\(error)")
                }
            }
        }.background(.black)
    }
}

struct VideoCollectionView: View {
    var videos = [Video]()
    var gridItemLayout = [GridItem(.fixed(110)), GridItem(.fixed(110)), GridItem(.fixed(110))]
    @State private var showingSheet = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridItemLayout, alignment: .center, spacing: 10) {
                ForEach(videos.indices, id: \.self) { index in
                    NavigationLink(
                        destination: ActivityLogBaseView(
                            viewName: "Video Selected: " + videos[index].videoId,
                            isDirectChildToContainer: true,
                            content: {
                                YoutubeModalView(videoID: videos[index].videoId)
                            }
                        )
                    ) {
                        AsyncImage(
                            url: URL(string: "http://img.youtube.com/vi/\(videos[index].videoId)/0.jpg"),
                            content: { image in
                                image.resizable()
                                    .scaledToFill()
                            },
                            placeholder: {
                                Image(systemName: "photo.fill")
                                    .tint(lightGrayColor)
                                    .accessibility(hidden: true)
                            }
                        )
                        .clipped()
                        .frame(width: 110, height: 110, alignment: .center)
                        .cornerRadius(10)
                        .accessibilityLabel(videos[index].videoId)
                    }
                }
            }
        }
    }
    
    init(videosArray: [Video]) {
        self.videos = videosArray
    }
}
