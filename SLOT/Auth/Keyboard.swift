
//
//  heyboard.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/10/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    
    func createHideKeyboardGesture(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
        UIView.animate(withDuration: 0.28, animations: { () -> Void in
            self.navigationController?.navigationBar.isHidden = false
            self.view.frame =  CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
    func summonKeyboard(){
        UIView.animate(withDuration: 0.28, animations: { () -> Void in
            self.navigationController?.navigationBar.isHidden = true
            let y = self.view.frame.height
            self.view.frame = CGRect(x: 0.0, y: -y/5, width: self.view.frame.width, height: self.view.frame.height)
        })
    }
}
