//
//  DrawView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 20/04/2023.
//

import Foundation
import PencilKit
import SwiftUI

// swiftlint:disable type_body_length
struct DrawingView: UIViewRepresentable {
    @Environment(\.undoManager)
    private var undoManager
    @Binding var canvas: PKCanvasView
    @Binding var isdraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    @Binding var isColoring: Bool
    @Binding var ink: PKInkingTool
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isdraw ? ink : eraser
        canvas.minimumZoomScale = 0.2
        canvas.maximumZoomScale = 10
        canvas.contentSize = CGSize(width: 1000, height: 1000)
        canvas.contentInset = UIEdgeInsets(top: 500, left: 500, bottom: 500, right: 500)
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // updating the tool whenever the view updates
        uiView.tool = isdraw ? ink : eraser
    }
}

struct DrawView: View {
    @Environment(\.dismiss)
    var dismiss
    @Environment(\.undoManager)
    private var undoManager
    @EnvironmentObject var drawStore: DrawStore
    @EnvironmentObject var coloringStore: ColoringStore
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
    @State var isNewDraw = false
    @State var isColoring = false
    @State var ink = PKInkingTool(.pencil, color: .black)
    @State var isEraser = false
    @State var eraserWidth: Double = 99.0
    @State var lineWidth: CGFloat = 1.0
    @State var showLineWith = false
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                if isColoring == true {
                    HeaderMenu(title: "Coloring Something")
                } else {
                    HeaderMenu(title: "Drawing something")
                }
                Spacer().frame(height: 20)
                toolkitView
                if showLineWith == true {
                    sliderLineView
                }
                Spacer()
                DrawingView(canvas: $canvas, isdraw: $isdraw, type: $type, color: $color, isColoring: $isColoring, ink: $ink)
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
    
    var sliderLineView: some View {
        Slider(
            value: $lineWidth,
            in: 3...30,
            step: 5
        ) { didChange in
            print("Did change: \(didChange)")
            if didChange == false {
                ink = PKInkingTool(.pen, color: UIColor(color), width: lineWidth)
            }
        }
        .padding(.horizontal, 60)
        .tint(primaryColor)
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
                .font(.custom("Montserrat-SemiBold", size: 17))
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
        .buttonStyle(ActivityLogButtonStyle(activityDescription: isColoring == true ? "Coloring Draw SAVED" : "Draw SAVED"))
        .alert("Enter the title of the drawing", isPresented: $emptyDrawAlert) {
            TextField("Title", text: $title)
            Button("OK", action: saveImage)
        }
    }
    
    var toolkitView: some View {
        Group {
            HStack(alignment: .center) {
                eraseButton
                Spacer()
                undoButton
                Spacer()
                redoButton
                Spacer()
                rubberButton
                Spacer()
                pencilMenu
            }.padding(.horizontal, 20)
        }
    }
    
    var pencilView: some View {
        Button(action: {
            showLineWith = false
            isEraser = false
            isdraw = true
            type = .pencil
            ink = PKInkingTool(type, color: UIColor(color))
        }) {
            Label {
                Text("Pencil")
            } icon: {
                Image(systemName: "pencil")
            }
        }
    }
    
    var penView: some View {
        Button(action: {
            showLineWith = true
            isEraser = false
            isdraw = true
            type = .pen
            ink = PKInkingTool(type, color: UIColor(color), width: lineWidth)
        }) {
            Label {
                Text("Pen")
            } icon: {
                Image(systemName: "pencil.tip")
            }
        }
    }
    
    var markerView: some View {
        Button(action: {
            showLineWith = false
            isEraser = false
            isdraw = true
            type = .marker
            ink = PKInkingTool(type, color: UIColor(color))
        }) {
            Label {
                Text("Marker")
            } icon: {
                Image(systemName: "highlighter")
            }
        }
    }
    
    var pencilMenu: some View {
        Menu {
            pencilView
            penView
            markerView
        } label: {
            VStack {
                Image(systemName: "paintbrush.pointed")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 40, height: 40)
                    .accessibilityLabel("pencilIcon")
                    .foregroundColor(.gray)
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
            showLineWith = false
            isEraser = false
            isdraw = false
            isdraw.toggle()
            canvas.drawing = PKDrawing()
        } label: {
            VStack {
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 40, height: 40)
                    .accessibilityLabel("trashIcon")
                    .foregroundColor(.gray)
                Text("Clear")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(10.0)
        }
    }
    
    var rubberButton: some View {
        Button {
            showLineWith = false
            isEraser = true
            isdraw = true
            type = .pen
            ink = PKInkingTool(type, color: .white, width: eraserWidth)
        } label: {
            VStack {
                Image(systemName: "eraser")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 40, height: 40)
                    .accessibilityLabel("erasecon")
                    .foregroundColor(.gray)
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
            showLineWith = false
            isEraser = false
            undoManager?.undo()
        } label: {
            VStack {
                Image(systemName: "arrow.uturn.backward")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 40, height: 40)
                    .accessibilityLabel("undoIcon")
                    .foregroundColor(.gray)
                Text("Undo")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(10.0)
        }
    }
    
    var redoButton: some View {
        Button {
            showLineWith = false
            isEraser = false
            undoManager?.redo()
        } label: {
            VStack {
                Image(systemName: "arrow.uturn.forward")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 40, height: 40)
                    .accessibilityLabel("redoIcon")
                    .foregroundColor(.gray)
                Text("Redo")
                    .font(.custom("Nunito-Bold", size: 14))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(10.0)
        }
    }
    
    func loadCurrentDraw() {
        self.title = currentDraw.title
        self.image = currentDraw.image
        self.id = currentDraw.id
        
        let drawing = try? PKDrawing(data: currentDraw.image)
        canvas.drawing = drawing ?? PKDrawing()
        canvas.setZoomScale(currentDraw.zoom, animated: true)
        canvas.backgroundColor = UIColor.clear
        canvas.isOpaque = false
        canvas.becomeFirstResponder()
        canvas.contentOffset = CGPoint(x: currentDraw.offsetX, y: currentDraw.offsetY)
        if !self.currentDraw.backImage.isEmpty {
            let img = Image(currentDraw.backImage)
                .resizable()
                .scaledToFit()
                .clipped()
                .frame(width: drawingSize.width, height: drawingSize.height)
                .accessibilityLabel("base64String")
            let imageView = UIImageView(image: img.asUIImage())
            let subView = self.canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
        }
    }
    
    @ViewBuilder
    func colorButton(color: Color) -> some View {
        Button {
            self.color = color
            if type == .pen {
                ink = PKInkingTool(type, color: UIColor(color), width: lineWidth)
            } else {
                ink = PKInkingTool(type, color: UIColor(color))
            }
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
            backImage: currentDraw.backImage,
            zoom: canvas.zoomScale,
            offsetX: canvas.contentOffset.x,
            offsetY: canvas.contentOffset.y
        )
        
        if isColoring {
            coloringStore.saveDraw(newDraw)
            ColoringStore.save(coloringDraws: coloringStore.coloringDraws) { result in
                if case .failure(let error) = result {
                    print(error.localizedDescription)
                }
            }
        } else {
            drawStore.saveDraw(newDraw)
            DrawStore.save(draws: drawStore.draws) { result in
                if case .failure(let error) = result {
                    print(error.localizedDescription)
                }
            }
        }
        dismiss()
    }
}

struct DrawView_Previews: PreviewProvider {
    @State static var currentDraw = Draw(id: UUID().uuidString, title: "Sample draw", image: Data(), date: Date(), backImage: "mandala1")
    
    static var previews: some View {
        DrawView(
            currentDraw: $currentDraw
        )
    }
}
