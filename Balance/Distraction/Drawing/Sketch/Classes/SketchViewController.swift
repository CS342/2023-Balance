//
//  SketchViewController.swift
//  Sketch
//
//  Created by daihase on 04/07/2018.
//  Copyright (c) 2018 daihase. All rights reserved.
//
import Combine
import PencilKit
import UIKit

// swiftlint:disable all
class SketchViewController: UIViewController, ButtonViewInterface, UIScrollViewDelegate {
    @IBOutlet var sketchView: SketchView!
    @IBOutlet var sketchScrollView: UIScrollView!
    var coloringStore: ColoringStore?
    var buttonView: ButtonView!
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    var cancellable: AnyCancellable?
    var draw : Draw?

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView = ButtonView.instanceFromNib(self)
        
        view.addSubview(scrollView)
        scrollView.addSubview(buttonView)
        
        scrollView.contentSize = buttonView.frame.size
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = 20
        buttonView.frame.size.width = UIScreen.main.bounds.width
        
        sketchView.layer.borderWidth = 5
        sketchView.layer.borderColor = UIColor.gray.cgColor
        sketchView.isUserInteractionEnabled = true
        sketchView.drawTool = .fill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImageLocally()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        sketchView.resetTool()
        return self.sketchView
    }
    
    @IBAction func saveImage(_ sender: Any) {
        if draw?.title == "" {
            let alert = UIAlertController(title: "Enter the title of the drawing", message: "", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = "Coloring..."
            }
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                self.draw?.title = textField!.text!
                self.save()
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            save()
        }
    }
    
    func save() {
        let imageData = (self.sketchView.image?.pngData())!
        self.draw?.image = imageData
        self.coloringStore!.saveDraw((self.draw)!)
        ColoringStore.save(coloringDraws: self.coloringStore!.coloringDraws) { result in
            if case .failure(let error) = result {
                print(error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SketchViewController: UIColorPickerViewControllerDelegate {
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
}


//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - ButtonViewInterface
//////////////////////////////////////////////////////////////////////////////////////////
extension SketchViewController {
    func tapPenButton() {
        sketchView.drawTool = .pen
    }
    
    func tapEraserButton() {
        sketchView.drawTool = .eraser
    }
    
    func tapUndoButton() {
        sketchView.undo()
    }
    
    func tapRedoButton() {
        sketchView.redo()
    }
    
    func tapClearButton() {
        sketchView.clear()
    }
    
    func tapPaletteButton() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        
        self.cancellable = picker.publisher(for: \.selectedColor)
            .sink { color in
                DispatchQueue.main.async {
                    self.sketchView.lineColor = color
                }
            }
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func tapFillButton() {
        sketchView.drawTool = .fill
    }
    
    func tapBlueButton() {
        self.sketchView.lineColor = .blue
    }
    
    func tapOrangeButton() {
        self.sketchView.lineColor = .orange
    }
    
    func tapPinkButton() {
        self.sketchView.lineColor = .systemPink
    }
    
    func tapPurpleButton() {
        self.sketchView.lineColor = .purple
    }
    
    func tapRedButton() {
        self.sketchView.lineColor = .red
    }
    
    func tapGreenButton() {
        self.sketchView.lineColor = .green
    }
    
    func tapYellowButton() {
        self.sketchView.lineColor = .yellow
    }
    
    func tapWhiteButton() {
        self.sketchView.lineColor = .white
    }
    
    func tapGrayButton() {
        self.sketchView.lineColor = .gray
    }
    
    func tapBlackButton() {
        self.sketchView.lineColor = .black
    }
    
    private func setImageLocally() {
        if !(draw?.image.isEmpty)! {
            let image = UIImage(data: draw!.image)
            if image == nil {
                let drawing = try? PKDrawing(data: draw!.image)
                let imageDraw = (drawing?.image(from: .init(x: 0, y: 0, width: 350, height: 350), scale: 1))!
                
                let backImage = UIImage(named: draw!.backImage)!
                let mergeImage = backImage.mergeWith(topImage: imageDraw)
                self.sketchView.loadImage(image: mergeImage, drawMode: .scale)
            } else {
                self.sketchView.loadImage(image: image!, drawMode: .scale)
            }
            return
        }
        
        if !(draw?.backImage.isEmpty)! {
            self.sketchView.loadImage(image: UIImage(named: draw!.backImage)!, drawMode: .scale)
        }
    }
}
