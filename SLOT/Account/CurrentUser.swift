//
//  User.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/11/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import MapKit

class CurrentUser {
    
    
    static var firstName: String = ""
    static var lastName: String = ""
    static var email: String = ""
    static var phoneNumber: String = ""
    static var licensePlateNumber: String = ""
    static var creditCardNumber: String = ""
    
    
    static var contentDictionary: [String: String] = ["First Name": "", "Last Name": "", "License Plate Number": "", "Email Address": "", "Phone Number": "", "Credit Card Info": ""]
    
    static func storeInfo(){
        CurrentUser.firstName = CurrentUser.contentDictionary["First Name"]!
        CurrentUser.lastName = CurrentUser.contentDictionary["Last Name"]!
        CurrentUser.email = CurrentUser.contentDictionary["Email Address"]!
        CurrentUser.phoneNumber = CurrentUser.contentDictionary["Phone Number"]!
        CurrentUser.licensePlateNumber = CurrentUser.contentDictionary["License Plate Number"]!
        CurrentUser.creditCardNumber = CurrentUser.contentDictionary["Credit Card Info"]!
    }
    static func saveInfoToDatabase(){
        let ref = Database.database().reference()
        let currentUserRef = ref.child("users").child((Auth.auth().currentUser?.uid)!)
        currentUserRef.updateChildValues(["firstName" : CurrentUser.firstName, "lastName" : CurrentUser.lastName, "email" : CurrentUser.email, "phoneNumber" : CurrentUser.phoneNumber, "licensePlateNumber" : CurrentUser.licensePlateNumber, "creditCardNumber" : CurrentUser.creditCardNumber])
    }
    
    
    static func grabInfo() {
        CurrentUser.contentDictionary["First Name"] = CurrentUser.firstName
        CurrentUser.contentDictionary["Last Name"] = CurrentUser.lastName
        CurrentUser.contentDictionary["Email Address"] = CurrentUser.email
        CurrentUser.contentDictionary["Phone Number"] = CurrentUser.phoneNumber
        CurrentUser.contentDictionary["License Plate Number"] = CurrentUser.licensePlateNumber
        CurrentUser.contentDictionary["Credit Card Info"] = CurrentUser.creditCardNumber
    }
    static func fetchInfoFromDatabase(completion: @escaping () -> Void) {
        let ref = Database.database().reference()
        let currentUserRef = ref.child("users").child((Auth.auth().currentUser?.uid)!)
        currentUserRef.observeSingleEvent(of: .value, with: { (data) in
            guard let validData = data.value as? [String:Any],
                let firstName = validData["firstName"] as? String,
                let lastName = validData["lastName"] as? String,
                let email = validData["email"] as? String,
                let phoneNumber = validData["phoneNumber"] as? String,
                let licensePlateNumber = validData["licensePlateNumber"] as? String,
                let creditCardNumber = validData["creditCardNumber"] as? String
                else{return}
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.phoneNumber = phoneNumber
            self.licensePlateNumber = licensePlateNumber
            self.creditCardNumber = creditCardNumber
            completion()
        })
    }
}


class creditCard {
    var cardNumber: String
    var expirationDate: String
    var securityCode: String
    init(cardNumber: String, expirationDate: String, securityCode: String){
        self.cardNumber = cardNumber
        self.expirationDate = expirationDate
        self.securityCode = securityCode
    }
}
