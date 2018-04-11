//
//  Notification.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/10/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import Foundation


extension NotificationCenter {
    
    static func appLogin() {
        let authNotification = Notification(name: Notification.Name(rawValue: "AuthLogin"), object: nil, userInfo: nil)
        self.default.post(authNotification)
    }
    static func appLogout() {
        let authNotification = Notification(name: Notification.Name(rawValue: "AuthLogout"), object: nil, userInfo: nil)
        self.default.post(authNotification)
    }
}


