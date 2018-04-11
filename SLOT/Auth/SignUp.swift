//
//  SignUp.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/10/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let ref = Database.database().reference()
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else{return}
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.alert("error", validError.localizedDescription)
            }
            if let validUser = user {
                self.navigationController?.popViewController(animated: true)
                let uid = validUser.uid
                let currentUserRef = ref.child("users").child((Auth.auth().currentUser?.uid)!)
                currentUserRef.updateChildValues(["firstName" : "", "lastName": "", "email" : email, "phoneNumber": "", "licensePlateNumber": "", "creditCardNumber": ""])
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createGradientLayer(inputView: self.view)
        signUpButton.layer.cornerRadius = 18
        
        
        self.hideKeyboard()
        passwordTextField.makePlaceHolderWhite("Password")
        emailTextField.makePlaceHolderWhite("Email")
        passwordTextField.customizeAuth()
        emailTextField.customizeAuth()
        
    }
    
}
