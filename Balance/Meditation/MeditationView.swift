//
//  MeditationView.swift
//  Balance
//
//  Created by Daniel Guo on 2/26/23.
//

import SwiftUI

struct MeditationView: View {
    var body: some View {
        //ScrollView(.vertical){
            VStack{
                VideoView(videoID: "0ZKqLcWdG-4")
                    .frame(minHeight: 0, maxHeight: UIScreen.main.bounds.height * 0.3).cornerRadius(12).padding(.horizontal, 24)
                VideoView(videoID: "iN6g2mr0p3Q")
                    .frame(minHeight: 0, maxHeight: UIScreen.main.bounds.height * 0.3).cornerRadius(12).padding(.horizontal, 24)
                VideoView(videoID: "F0WYFXxhPGY")
                    .frame(minHeight: 0, maxHeight: UIScreen.main.bounds.height * 0.3).cornerRadius(12).padding(.horizontal, 24)
                VideoView(videoID: "vQxTUQhVbg4")
                    .frame(minHeight: 0, maxHeight: UIScreen.main.bounds.height * 0.3).cornerRadius(12).padding(.horizontal, 24)
            }
        //}
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView()
    }
}
