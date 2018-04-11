//
//  RootUI.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/11/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import Foundation
import MapKit
import UIKit


extension RootViewController {
    
    func addBlurEffect() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view?.addSubview(visualEffectView)
    }
    
    
    func createNav(){
        addBlurEffect()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = Slot.white
        createAccountButton()
        createFocusButton()
        self.createNavTitle("Map")
    }
    
    
    func createAccountButton(){
        var image = UIImage(named: "account")
        image = image?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(accountButtonTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    @objc func accountButtonTapped(){
        guard let accountVC = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController
            else{return}
        navigationController?.pushViewController(accountVC, animated: true)
    }
    
    
    
    func createFocusButton(){
        var image = UIImage(named: "focus")
        image = image?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(focusButtonTapped))
        self.navigationItem.leftBarButtonItem = button
    }
    @objc func focusButtonTapped(){
        guard let userLocation = locationManager.location
            else{return}
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
