//
//  GalleryView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI
import WebKit

struct Video: Identifiable {
    var id = UUID()
    var videoId: String
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
    @State private var animalsTag = true
    @State private var landscapeTag = false
    @State private var funnyTag = false
    @State var index = 0
    
    var ids = [
        "0ZKqLcWdG-4",
        "iN6g2mr0p3Q",
        "F0WYFXxhPGY",
        "vQxTUQhVbg4"
    ]
    
    var idsFunny = [
        Video(videoId: "0ZKqLcWdG-4"),
        Video(videoId: "iN6g2mr0p3Q"),
        Video(videoId: "F0WYFXxhPGY"),
        Video(videoId: "vQxTUQhVbg4")
    ]
    
    var idsLandscape = [
        Video(videoId: "0ZKqLcWdG-4"),
        Video(videoId: "iN6g2mr0p3Q"),
        Video(videoId: "F0WYFXxhPGY"),
        Video(videoId: "vQxTUQhVbg4")
    ]
    
    var body: some View {
        HeaderMenu(title: "Look Videos")
        VStack(alignment: .center, spacing: 10) {
            highlightsTitle
            PagingView(index: $index.animation(), maxIndex: ids.count - 1) {
                ForEach(ids, id: \.self) { idData in
                    YouTubeGalleryView(videoId: idData)
                        .frame(width: 300, height: 300)
                        .padding()
                }
            }
            .aspectRatio(4 / 3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            PageControl(index: $index, maxIndex: ids.count)
                .padding(.top, 5.0)
            categoriesTitle
            tagsView
            if animalsTag {
                VideoCollectionView(videosArray: idsFunny)
                    .padding(.horizontal, 10.0)
            } else if landscapeTag {
                VideoCollectionView(videosArray: idsLandscape)
                    .padding(.horizontal, 10.0)
            } else if funnyTag {
                VideoCollectionView(videosArray: idsFunny)
                    .padding(.horizontal, 10.0)
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer(minLength: 10)
                animalsButton
                landscapeButton
                funnyButton
            }
        }
    }
    
    var animalsButton: some View {
        Button(action: {
            animalsTag = true
            landscapeTag = false
            funnyTag = false
        }) {
            Text("Animals")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(self.animalsTag ? violetColor : lightVioletColor)
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Animals"))
    }
    
    var landscapeButton: some View {
        Button(action: {
            animalsTag = false
            landscapeTag = true
            funnyTag = false
        }) {
            Text("Landscape")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(self.landscapeTag ? violetColor : lightVioletColor)
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Landscape"))
    }
    
    var funnyButton: some View {
        Button(action: {
            animalsTag = false
            landscapeTag = false
            funnyTag = true
        }) {
            Text("Funny Images")
                .font(.custom("Nunito", size: 18))
                .frame(width: 120, height: 30)
                .foregroundColor(.white)
                .background(self.funnyTag ? violetColor : lightVioletColor)
                .cornerRadius(20)
        }
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Viewing Funny Images"))
    }
}

#if DEBUG
struct VideoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        VideoGalleryView()
    }
}
#endif
