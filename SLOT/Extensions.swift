//
//  Extensions.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/10/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(_ title: String,_ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func createGradientLayer(inputView: UIView) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = inputView.bounds
        gradientLayer.cornerRadius = inputView.layer.cornerRadius
        gradientLayer.cornerRadius = inputView.layer.cornerRadius
        gradientLayer.colors =  [Slot.blue.cgColor, Slot.purple.cgColor]
        inputView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func addBlurEffect(to inputView: UIView) {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = inputView.frame
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        inputView.addSubview(visualEffectView)
    }
    
    func addLetterSpacing(_ inputString: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: inputString)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: NSMakeRange(0, attributedString.length-1))
        return attributedString
    }
    
    
    func createOptionsLabel(_ inputText: String) -> UILabel {
        let label = UILabel()
        label.text = inputText
        label.textColor = Slot.blue
        label.textAlignment = .center
        label.font = UIFont(name: Slot.fontString, size: 20.0)
        label.attributedText = addLetterSpacing(label.text!)
        return label
    }
    
    func createNavTitle(_ title: String){
        let navTitle = createOptionsLabel(title)
        navTitle.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        self.navigationItem.titleView = navTitle
    }
}

extension UITextField {
    func customizeAuth(){
        self.backgroundColor = .clear
        self.tintColor = .white
        self.textColor = .white
        self.font = UIFont(name: Slot.fontString, size: 20)
    }
    
    func makePlaceHolderWhite(_ placeHolderText: String){
        self.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
}
