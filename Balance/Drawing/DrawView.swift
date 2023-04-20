//
//  DrawView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 20/04/2023.
//

import Foundation
import PencilKit
import SwiftUI

// struct Line {
//    var points = [CGPoint]()
//    var color: Color = .red
//    var lineWidth: Double = 1.0
// }

struct MyCanvas: UIViewRepresentable {
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: MyCanvas
        
        init(_ uiView: MyCanvas) {
            self.parent = uiView
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            if !self.parent.cntrl.didRemove {
                self.parent.cntrl.drawings.append(canvasView.drawing)
            }
        }
    }
    var cntrl: PKCanvasController

    func makeUIView(context: Context) -> PKCanvasView {
        cntrl.canvas = PKCanvasView()
        cntrl.canvas.delegate = context.coordinator
        cntrl.canvas.becomeFirstResponder()
        return cntrl.canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class PKCanvasController {
    var canvas = PKCanvasView()
    var drawings = [PKDrawing]()
    var didRemove = false
    
    func clear() {
        canvas.drawing = PKDrawing()
        drawings = [PKDrawing]()
    }
    
    func undoDrawing() {
        if !drawings.isEmpty {
            didRemove = true
            drawings.removeLast()
            canvas.drawing = drawings.last ?? PKDrawing()
            didRemove = false
        }
    }
}
// swiftlint: disable closure_body_length
struct DrawView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.undoManager) private var undoManager
    let pkCntrl = PKCanvasController()
    
    //    @State private var canvasView = PKCanvasView()
    
//    @State private var currentLine = Line()
//    @State private var lines: [Line] = []
//    @State private var thickness: Double = 1.0
    
    var body: some View {
        ZStack {
            backgroudColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                HeaderMenu(title: "Drawing something")
                toolkitView
                MyCanvas(cntrl: pkCntrl)
                
                Spacer()
                //                Canvas { context, size in
                //                    for line in lines {
                //                        var path = Path()
                //                        path.addLines(line.points)
                //                        context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
                //                    }
                //                }
                //                .frame(minWidth: 400, minHeight: 400)
                //                .gesture(
                //                    DragGesture(minimumDistance: 0,
                //                                coordinateSpace: .local)
                //                    .onChanged({ value in
                //                        let newPoint = value.location
                //                        currentLine.points.append(newPoint)
                //                        self.lines.append(currentLine)
                //                    })
                //                    .onEnded({ value in
                //                        self.lines.append(currentLine)
                //                        self.currentLine = Line(points: [], color: currentLine.color, lineWidth: thickness)
                //                    })
                //                )
                //                HStack {
                //                    Slider(value: $thickness, in: 1...20) {
                //                        Text("Thickness")
                //                    }.frame(maxWidth: 200)
                //                        .onChange(of: thickness) { newThickness in
                //                            currentLine.lineWidth = newThickness
                //                        }
                //                    Divider()
                //                    ColorPickerView(selectedColor: $currentLine.color)
                //                        .onChange(of: currentLine.color) { newColor in
                //                            print(newColor)
                //                            currentLine.color = newColor
                //                        }
                //                }
                saveButton
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Save")
                .font(.system(.title2))
                .padding(.horizontal, 10.0)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 44.0)
        }
        .buttonBorderShape(.roundedRectangle(radius: 10))
        .background(Color(#colorLiteral(red: 0.30, green: 0.79, blue: 0.94, alpha: 1.00)))
        .cornerRadius(10)
        .padding(.horizontal, 20.0)
    }
    
    var toolkitView: some View {
        HStack {
            Spacer()
            Button {
                self.pkCntrl.undoDrawing()
            } label: {
                VStack {
                    Image("undoIcon")
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: 80, height: 80)
                        .accessibilityLabel("undoIcon")
                    Text("Undo")
                        .font(.custom("Nunito-Bold", size: 14))
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(10.0)
            }
            Spacer()
            Button {
                self.pkCntrl.clear()
            } label: {
                VStack {
                    Image("eraseIcon")
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: 80, height: 80)
                        .accessibilityLabel("erasecon")
                    Text("Erase")
                        .font(.custom("Nunito-Bold", size: 14))
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(10.0)
            }
            Spacer()
            Button { } label: {
                VStack {
                    Image("pencilIcon")
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: 80, height: 80)
                        .accessibilityLabel("pencilIcon")
                    Text("Paint")
                        .font(.custom("Nunito-Bold", size: 14))
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(10.0)
            }
            Spacer()
        }
    }
}

struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView()
    }
}
