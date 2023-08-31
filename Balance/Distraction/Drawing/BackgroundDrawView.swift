//
//  BackgroundDrawView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 24/04/2023.
//

import SwiftUI

struct MandalaTagView: View {
    var selectedCategory: Category
    @Binding var selectedBtn: Int
    @Binding var filteredCat: [Mandala]
    
    var body: some View {
        Button(action: {
            self.selectedBtn = self.selectedCategory.id
            filteredCat.removeAll()
            for photo in mandalaArray {
                for category in photo.category where category.name == self.selectedCategory.name {
                    filteredCat.append(photo)
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

struct BackgroundDrawView: View {
    @Binding var currentDraw: Draw
    @State var index = 0
    @State var selectedCategory = mandalaCategoryArray[0]
    @State var filtered = mandalaArray
    @State var selected = 0
    
    let highlightArray = mandalaArray.filter { $0.highlight == true }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "Coloring Something")
                VStack(alignment: .center, spacing: 10) {
                    highlightsTitle
                    imagePaging
                    categoriesTitle
                    tagsView
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    var imagePaging: some View {
        TabView {
            ForEach(highlightArray, id: \.self) { mandala in
                NavigationLink(
                    destination: ActivityLogBaseView(
                        viewName: "Mandala Selected: " + mandala.name,
                        isDirectChildToContainer: true,
                        content: {
                            DrawSketch(draw: currentDraw)
                        }
                    )
                ) {
                    Image(mandala.name)
                        .resizable()
                        .cornerRadius(20)
                        .aspectRatio(contentMode: .fit)
                        .padding(5)
                        .accessibility(hidden: true)
                        .tag(mandala.id)
                }.simultaneousGesture(TapGesture().onEnded {
                    self.currentDraw.backImage = mandala.name
                })
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
                    ForEach(mandalaCategoryArray, id: \.self) { cat in
                        MandalaTagView(selectedCategory: cat, selectedBtn: self.$selected, filteredCat: self.$filtered)
                    }
                }
            }
            ScrollView(.vertical) {
                MandalaCollectionView(currentDraw: $currentDraw, images: $filtered).padding(.horizontal, 10.0)
            }
        }
    }
}

#if DEBUG
struct BackgroundDrawView_Previews: PreviewProvider {
    @State static var currentDraw = Draw(id: UUID().uuidString, title: "Sample draw", image: Data(), date: Date(), backImage: "mandala1", zoom: 1.0)
    
    static var previews: some View {
        BackgroundDrawView(
            currentDraw: $currentDraw
        )
    }
}
#endif
