//
//  GalleryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI
import WebKit

struct VideoTagView: View {
    var selectedCategory: Category
    @Binding var selectedBtn: Int
    @Binding var filteredCat: [Video]
    
    var body: some View {
        Button(action: {
            self.selectedBtn = self.selectedCategory.id
            filteredCat.removeAll()
            for video in videoArray {
                for category in video.category where category.name == self.selectedCategory.name {
                    filteredCat.append(video)
                }
            }
        }) {
            Text(selectedCategory.name)
                .font(.custom("Nunito", size: 18))
                .foregroundColor(.white)
                .padding(20)
        }
        .frame(height: 30)
        .background(self.selectedBtn == self.selectedCategory.id ? violetColor : lightVioletColor)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(5)
    }
}

struct YouTubeGalleryView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        let web = WKWebView()
        return web
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoId)")
        else {
            return
        }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: url))
    }
}

struct VideoGalleryView: View {
    @State var index = 0
    @State var selectedCategory = videoCategoryArray[0]
    @State var filtered = videoArray
    @State var selected = 0
    let highlightArray = videoArray.filter { $0.highlight == true }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Look Videos")
                VStack(alignment: .center, spacing: 5) {
                    highlightsTitle
                    videoPaging
                    categoriesTitle
                    tagsView
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    var videoPaging: some View {
        TabView {
            ForEach(highlightArray, id: \.self) { idData in
                NavigationLink(
                    destination: ActivityLogBaseView(
                        viewName: "Video Highlight Selected: " + idData.videoId,
                        isDirectChildToContainer: true,
                        content: {
                            YoutubeModalView(videoID: idData.videoId)
                        }
                    )
                ) {
                    AsyncImage(
                        url: URL(string: "http://img.youtube.com/vi/\(idData.videoId)/0.jpg"),
                        content: { image in
                            image.resizable()
                                .scaledToFill()
                                .accessibility(hidden: true)
                        },
                        placeholder: {
                            Image(systemName: "photo.fill")
                                .tint(lightGrayColor)
                                .accessibility(hidden: true)
                        }
                    )
                    .clipped()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .accessibility(hidden: true)
                }
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    var highlightsTitle: some View {
        Text("Highlights").font(.custom("Nunito-Bold", size: 25))
            .foregroundColor(violetColor)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
    }
    
    var categoriesTitle: some View {
        Text("Categories").font(.custom("Nunito-Bold", size: 20))
            .foregroundColor(violetColor)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
    }
    
    var tagsView: some View {
        Group {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Spacer(minLength: 10)
                    ForEach(videoCategoryArray, id: \.self) { cat in
                        VideoTagView(selectedCategory: cat, selectedBtn: self.$selected, filteredCat: self.$filtered)
                    }
                }
            }
            ScrollView(.vertical) {
                VideoCollectionView(videosArray: filtered).padding(.horizontal, 10.0)
            }
        }
    }
}

#if DEBUG
struct VideoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        VideoGalleryView()
    }
}
#endif
