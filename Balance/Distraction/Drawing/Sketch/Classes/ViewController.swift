//
//  ViewController.swift
//  Sketch
//
//  Created by daihase on 04/07/2018.
//  Copyright (c) 2018 daihase. All rights reserved.
//
import Combine
import UIKit

// swiftlint:disable all
class ViewController: UIViewController, ButtonViewInterface {
    @IBOutlet var sketchView: SketchView!
    var coloringStore: ColoringStore?
    var buttonView: ButtonView!
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    var cancellable: AnyCancellable?
    var draw = Draw()

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
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler))
        sketchView.addGestureRecognizer(pinchGestureRecognizer)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.sketchView.addGestureRecognizer(panGesture)
        
        sketchView.drawTool = .fill
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setImageLocally()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer? = nil) {
        sketchView.resetTool()
        let translation = sender?.translation(in: self.view)
        sender?.view!.center = CGPoint(x: (sender?.view!.center.x)! + translation!.x, y: (sender?.view!.center.y)! + translation!.y)
        sender?.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func pinchHandler(recognizer : UIPinchGestureRecognizer) {
        sketchView.resetTool()
        if let view = self.sketchView {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    @IBAction func saveImage(_ sender: Any) {
        let alert = UIAlertController(title: "Please enter a name", message: "", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = "Coloring..."
        }

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let imageData = (self.sketchView.image?.pngData())!
            self.draw.title = textField!.text!
            self.draw.image = imageData
            
            self.coloringStore!.saveDraw(self.draw)
            ColoringStore.save(coloringDraws: self.coloringStore!.coloringDraws) { result in
                if case .failure(let error) = result {
                    print(error.localizedDescription)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UIColorPickerViewControllerDelegate {
    
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
extension ViewController {
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
    
    private func setImageLocally() {
        if !draw.image.isEmpty {
            self.sketchView.loadImage(image: UIImage(data: draw.image)!, drawMode: .scale)
            return
        }
        
        if !draw.backImage.isEmpty {
            self.sketchView.loadImage(image: UIImage(named: draw.backImage)!, drawMode: .scale)
        }
    }
}
