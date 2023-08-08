//
//  DemoGlobalBannerContent.swift
//  Balance
//
//  Created by Gonzalo Perisset on 08/08/2023.
//

import SwiftUI

struct GlobalBannerContent: View {
    @ObservedObject var bannerManager: PresentBannerManager
    
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "star.circle")
                VStack(alignment: .leading, spacing: 2) {
                    Text(bannerManager.banner?.title ?? "")
                        .bold()
                    Text(bannerManager.banner?.message ?? "")
                        .fontWeight(.medium)
                }
                Spacer()
            }
            .padding(12)
            .foregroundColor(.white)
            .background(Color.gray)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut)
        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
        .onTapGesture {
            withAnimation {
                bannerManager.dismiss()
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    bannerManager.dismiss()
                }
            }
        })
    }
}
