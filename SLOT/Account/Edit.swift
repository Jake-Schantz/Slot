//
//  EditViewController.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/11/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    
    var selectedTitle: String = ""
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func updateButtonTapped(_ sender: Any) {
        guard let newInfo = textField.text
            else{return}
        CurrentUser.contentDictionary[selectedTitle] = newInfo
        CurrentUser.storeInfo()
        CurrentUser.saveInfoToDatabase()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        dismissKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectedTitle
        textField.text = CurrentUser.contentDictionary[selectedTitle]!
        
        updateButton.setTitle("Update \(selectedTitle)", for: .normal)
        updateButton.layer.cornerRadius = 18
//        self.createGradientLayer(inputView: updateButton)
        updateButton.backgroundColor = Slot.blue
        updateButton.layer.shadowColor = UIColor.black.cgColor
        updateButton.layer.shadowOpacity = 0.5
        updateButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        updateButton.layer.shadowRadius = 3
        
        var x = #imageLiteral(resourceName: "blackX")
        x = x.withRenderingMode(.alwaysOriginal)
        cancelButton.setImage(x, for: .normal)
    }

}
