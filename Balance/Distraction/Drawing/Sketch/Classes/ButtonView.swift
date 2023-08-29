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
    func tapGreenButton()
    func tapYellowButton()
    func tapWhiteButton()
    func tapGrayButton()
    func tapBlackButton()
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
        
        
        buttonView.viewWithTag(101)?.layer.borderWidth = 1.0;
        buttonView.viewWithTag(101)?.layer.borderColor = UIColor.lightGray.cgColor;
        buttonView.viewWithTag(101)?.layer.cornerRadius = 5.0;

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
    
    @IBAction func tapGreenButton(_ sender: Any) {
        delegate?.tapGreenButton()
    }
    
    @IBAction func tapYellowButton(_ sender: Any) {
        delegate?.tapYellowButton()
    }
    
    @IBAction func tapWhiteButton(_ sender: Any) {
        delegate?.tapWhiteButton()
    }
    
    @IBAction func tapGrayButton(_ sender: Any) {
        delegate?.tapGrayButton()
    }
    
    @IBAction func tapBlackButton(_ sender: Any) {
        delegate?.tapBlackButton()
    }
}
