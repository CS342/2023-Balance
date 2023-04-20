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
    @State var toolPicker = PKToolPicker()
    
    // Updating inktype
    var ink: PKInkingTool {
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isdraw ? ink : eraser
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // updating the tool whenever the view updates
        uiView.tool = isdraw ? ink : eraser
    }
}

// swiftlint: disable closure_body_length
struct DrawView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.undoManager) private var undoManager
    @State var canvas = PKCanvasView()
    @State var isdraw = true
    @State var color: Color = .black
    @State var type: PKInkingTool.InkType = .pencil
    @State var colorPicker = false
    
    var body: some View {
        ZStack {
            backgroudColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 10) {
                HeaderMenu(title: "Drawing something")
                toolkitView
                DrawingView(canvas: $canvas, isdraw: $isdraw, type: $type, color: $color)
                
                    .navigationBarItems(leading: Button(action: {
                        saveImage()
                    }, label: {
                        Image(systemName: "square.and.arrow.down.fill")
                            .font(.title)
                            .foregroundColor(Color.orange)
                    }), trailing: HStack(spacing: 15) {
                        Button(action: {
                            // erase tool
                            isdraw = false
                            isdraw.toggle()
                        }) {
                            Image(systemName: "pencil.slash")
                                .font(.title)
                                .foregroundColor(Color.orange)
                        }
                        Menu {
                            // ColorPicker
                            ColorPicker(selection: $color) {
                                Button(action: {
                                    colorPicker.toggle()
                                }) {
                                    Label {
                                        Text("Color")
                                    } icon: {
                                        Image(systemName: "eyedropper.full")
                                            .foregroundColor(Color.orange)
                                    }
                                }
                            }
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
                            Image(systemName: "menubar.dock.rectangle")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundColor(Color.orange)
                        }
                    })
                    .sheet(isPresented: $colorPicker) {
                        ColorPicker("Pick Color", selection: $color)
                            .padding()
                    }
                Spacer()
                HStack {
                    ForEach([Color.green, .orange, .blue, .red, .pink, .black, .purple], id: \.self) { color in
                        colorButton(color: color)
                    }
                }
                saveButton
            }
        }
    }
    
    var saveButton: some View {
        Button(action: {
            saveImage()
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
            Spacer()
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
            Spacer()
            Menu {
                // ColorPicker
                ColorPicker(selection: $color) {
                    Button(action: {
                        colorPicker.toggle()
                    }) {
                        Label {
                            Text("Color")
                        } icon: {
                            Image(systemName: "eyedropper.full")
                                .foregroundColor(Color.orange)
                        }
                    }
                }
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
            //            Button {
            //
            //            } label: {
            //                VStack {
            //                    Image("pencilIcon")
            //                        .resizable()
            //                        .scaledToFit()
            //                        .clipped()
            //                        .frame(width: 80, height: 80)
            //                        .accessibilityLabel("pencilIcon")
            //                    Text("Paint")
            //                        .font(.custom("Nunito-Bold", size: 14))
            //                        .foregroundColor(Color.gray)
            //                        .multilineTextAlignment(.center)
            //                }
            //                .padding(10.0)
            //            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func colorButton(color: Color) -> some View {
        Button {
            self.color = color
        } label: {
            Image(systemName: "circle.fill")
                .font(.largeTitle)
                .foregroundColor(color)
//                .mask {
//                    Image(systemName: "pencil.tip")
//                        .font(.largeTitle)
//                }
        }
    }
    
    func saveImage() {
        // getting image from Canvas
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        // saving to album
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}


struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView()
    }
}
