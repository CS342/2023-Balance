//
//  DrawView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 20/04/2023.
//

import Foundation
import PencilKit
import SwiftUI

struct DrawingView: UIViewRepresentable {
    @Environment(\.undoManager) private var undoManager
    @Binding var canvas: PKCanvasView
    @Binding var isdraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    
    // Updating inktype
    var ink: PKInkingTool {
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isdraw ? ink : eraser
        canvas.minimumZoomScale = 1
        canvas.maximumZoomScale = 1
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // updating the tool whenever the view updates
        uiView.tool = isdraw ? ink : eraser
    }
}

struct DrawView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.undoManager) private var undoManager
    @ObservedObject var store: DrawStore
    @Binding var currentDraw: Draw
    @State var canvas = PKCanvasView()
    @State var isdraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    @State private var id = UUID().uuidString
    @State private var savedDraws: [Draw] = []
    @State private var emptyDrawAlert = false
    @State private var image = Data()
    @State private var title = ""
    @State private var showingAlert = false
    @State var drawingSize = CGSize(width: 350, height: 350)
    @State var backgroundImage = ""
    @State var isNewDraw = false
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                HeaderMenu(title: "Drawing something")
                Spacer().frame(height: 20)
                toolkitView
                Spacer()
                DrawingView(canvas: $canvas, isdraw: $isdraw, type: $type, color: $color)
                    .frame(width: drawingSize.width, height: drawingSize.height)
                    .border(Color.gray, width: 5)
                Spacer()
                colorView
                    .onAppear {
                        loadCurrentDraw()
                    }
                Spacer()
                saveView
            }
        }
    }
    
    var colorView: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center) {
                Spacer()
                ForEach([Color.yellow, .green, .orange, .blue, .red, .pink, .purple, .brown, .black], id: \.self) { color in
                    colorButton(color: color)
                }
                ColorPicker("", selection: $color)
            }
        }
    }
    
    var saveView: some View {
        Button {
            if self.title.isEmpty {
                self.emptyDrawAlert = true
            } else {
                saveImage()
            }
        } label: {
            Text("Save")
                .font(.system(.title2))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
                .font(.custom("Nunito-Bold", size: 17))
        }
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(primaryColor)
        .cornerRadius(10)
        .padding(.horizontal, 20.0)
        .buttonStyle(ActivityLogButtonStyle(activityDescription: "Saved a Draw"))
        .alert("Enter the title of the drawing", isPresented: $emptyDrawAlert) {
            TextField("Title", text: $title)
            Button("OK", action: saveImage)
        }
    }
    
    var toolkitView: some View {
        HStack {
            Spacer()
            undoButton
            Spacer()
            eraseButton
            Spacer()
            pencilMenu
            Spacer()
        }
    }
    
    var pencilMenu: some View {
        Menu {
            Button(action: {
                // changing type
                isdraw = true
                type = .pencil
            }) {
                Label {
                    Text("Pencil")
                } icon: {
                    Image(systemName: "pencil")
                }
            }
            Button(action: {
                isdraw = true
                type = .pen
            }) {
                Label {
                    Text("Pen")
                } icon: {
                    Image(systemName: "pencil.tip")
                }
            }
            Button(action: {
                isdraw = true
                type = .marker
            }) {
                Label {
                    Text("Marker")
                } icon: {
                    Image(systemName: "highlighter")
                }
            }
        } label: {
            VStack {
                Image("pencilIcon")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 40, height: 40)
                    .accessibilityLabel("pencilIcon")
                Text("Paint")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    var eraseButton: some View {
        Button {
            // erase tool
            isdraw = false
            isdraw.toggle()
            canvas.drawing = PKDrawing()
        } label: {
            VStack {
                Image("eraseIcon")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 40, height: 40)
                    .accessibilityLabel("erasecon")
                Text("Erase")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(10.0)
        }
    }
    
    var undoButton: some View {
        Button {
            undoManager?.undo()
        } label: {
            VStack {
                Image("undoIcon")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 40, height: 40)
                    .accessibilityLabel("undoIcon")
                Text("Undo")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(10.0)
        }
    }
    
    func loadCurrentDraw() {
        if self.currentDraw.backImage.isEmpty {
            self.currentDraw.backImage = backgroundImage
        }
        self.title = currentDraw.title
        self.image = currentDraw.image
        self.id = currentDraw.id
        let drawing = try? PKDrawing(data: currentDraw.image)
        canvas.drawing = drawing ?? PKDrawing()
        let img = Image(currentDraw.backImage)
            .resizable()
            .scaledToFit()
            .clipped()
            .frame(width: drawingSize.width, height: drawingSize.height)
            .accessibilityLabel("base64String")
        
        canvas.backgroundColor = UIColor.clear
        canvas.isOpaque = false
        canvas.becomeFirstResponder()
        
        let imageView = UIImageView(image: img.asUIImage())
        imageView.contentMode = .scaleAspectFit
        
        let subView = self.canvas.subviews[0]
        subView.addSubview(imageView)
        subView.sendSubviewToBack(imageView)
    }
    
    @ViewBuilder
    func colorButton(color: Color) -> some View {
        Button {
            self.color = color
        } label: {
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .clipped()
                .frame(width: 30, height: 30)
                .font(.largeTitle)
                .foregroundColor(color)
        }
    }
    
    func saveImage() {
        let newDraw = Draw(
            id: currentDraw.id,
            title: title,
            image: canvas.drawing.dataRepresentation(),
            date: Date(),
            backImage: currentDraw.backImage
        )
        
        store.saveDraw(newDraw)
        
        DrawStore.save(draws: store.draws) { result in
            if case .failure(let error) = result {
                print(error.localizedDescription)
            }
        }
        
        if isNewDraw {
            NavigationUtil.popToRootView()
        } else {
            dismiss()
        }
    }
}

struct DrawView_Previews: PreviewProvider {
    @State static var currentDraw = Draw(id: UUID().uuidString, title: "Sample draw", image: Data(), date: Date(), backImage: "mandala1")
    
    static var previews: some View {
        let store = DrawStore()
        DrawView(
            store: store,
            currentDraw: $currentDraw
        )
    }
}
