//
//  FaceView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/05/2023.
//

import SwiftUI

struct FaceView: View {
    @State var faceImage: String
    @State var faceTitle: String
    @State var backColor: Color

    var body: some View {
        VStack {
            Image(faceImage)
                .resizable()
                .scaledToFit()
                .padding(20.0)
                .clipped()
                .frame(width: 80, height: 80)
                .background(backColor)
                .cornerRadius(15, corners: .allCorners)
                .shadow(color: .gray, radius: 5)
                .accessibility(hidden: true)
            Text(faceTitle)
                .font(.custom("Montserrat-Medium", size: 16))
                .foregroundColor(facesGrayColor)
                .minimumScaleFactor(0.01)
        }
    }
}

struct FaceView_Previews: PreviewProvider {
    static var previews: some View {
        FaceView(faceImage: "angryFace", faceTitle: "Angry", backColor: primaryColor)
    }
}
