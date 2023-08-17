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
    var buttonView: ButtonView!
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 100))
    var backgroundImage = ""
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonView = ButtonView.instanceFromNib(self)

        view.addSubview(scrollView)
        scrollView.addSubview(buttonView)

        scrollView.contentSize = buttonView.frame.size
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame.origin.x = 0
        scrollView.frame.origin.y = 0
        buttonView.frame.size.width = UIScreen.main.bounds.width
        
        setImageLocally()
        sketchView.layer.borderWidth = 5
        sketchView.layer.borderColor = UIColor.gray.cgColor
        sketchView.isUserInteractionEnabled = true

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler))
        sketchView.addGestureRecognizer(pinchGestureRecognizer)
        

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.sketchView.addGestureRecognizer(panGesture)
        
        sketchView.drawTool = .fill
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
        if let view = self.sketchView {
            sketchView.resetTool()
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
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

    private func setImageLocally() {
        self.sketchView.loadImage(image: UIImage(named: backgroundImage)!, drawMode: .scale)
    }
}
