//
//  Lot.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/11/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import Foundation
import MapKit

class Lot {
    var location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var totalCapacity: Int = 0
    var cost: Int = 0
    var currentOcupants: Int = 0
    
    init(location: CLLocationCoordinate2D, totalCapacity: Int, cost: Int, currentOcupants: Int) {
        self.location = location
        self.totalCapacity = totalCapacity
        self.cost = cost
        self.currentOcupants = currentOcupants
    }
}
