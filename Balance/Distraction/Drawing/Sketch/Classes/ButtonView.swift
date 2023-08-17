//
//  ButtonView.swift
//  Sketch
//
//  Created by daihase on 2018/04/06.
//  Copyright (c) 2018 daihase. All rights reserved.
//

import UIKit

// swiftlint:disable all
protocol ButtonViewInterface: AnyObject {
    func tapPenButton()
    func tapEraserButton()
    func tapUndoButton()
    func tapRedoButton()
    func tapClearButton()
    func tapPaletteButton()
    func tapFillButton()    
    func tapBlueButton()
    func tapRedButton()
    func tapPinkButton()
    func tapOrangeButton()
    func tapPurpleButton()
}

class ButtonView: UIView {
    var delegate: ButtonViewInterface?
    
    class func instanceFromNib(_ delegate: ButtonViewInterface?) -> ButtonView {
        let buttonView : ButtonView = UINib(
            nibName: "ButtonView",
            bundle: Bundle.main
            ).instantiate(
                withOwner: self,
                options: nil
            ).first as! ButtonView
        
        buttonView.delegate = delegate
        
        return buttonView
    }
    
    // Tap pen Button
    @IBAction func tapPenButton(_ sender: Any) {
        delegate?.tapPenButton()
    }
    
    // Tap Eraser Button
    @IBAction func tapEraserButton(_ sender: Any) {
        delegate?.tapEraserButton()
    }
    
    // Tap Undo Buddon
    @IBAction func tapUndoButton(_ sender: Any) {
        delegate?.tapUndoButton()
    }
    
    // Tap Redo Button
    @IBAction func tapRedoButton(_ sender: Any) {
        delegate?.tapRedoButton()
    }
    
    // Tap Clear Button
    @IBAction func tapClearButton(_ sender: Any) {
        delegate?.tapClearButton()
    }
    
    // Tap Palette Button
    @IBAction func tapPaletteButton(_ sender: Any) {
        delegate?.tapPaletteButton()
    }
    
    // Tap Fill Button
    @IBAction func tapFillButton(_ sender: Any) {
        delegate?.tapFillButton()
    }
    
    @IBAction func tapBlueButton(_ sender: Any) {
        delegate?.tapBlueButton()
    }

    @IBAction func tapOrangeButton(_ sender: Any) {
        delegate?.tapOrangeButton()
    }

    @IBAction func tapPinkButton(_ sender: Any) {
        delegate?.tapPinkButton()
    }

    @IBAction func tapPurpleButton(_ sender: Any) {
        delegate?.tapPurpleButton()
    }
    
    @IBAction func tapRedButton(_ sender: Any) {
        delegate?.tapRedButton()
    }
    
}
