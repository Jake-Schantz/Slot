//
//  RootViewController.swift
//  SLOT
//
//  Created by Jacob Schantz on 4/10/18.
//  Copyright © 2018 Jake Schantz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit
import CoreLocation


protocol RootDelegate {
    func didTapOnView()
}



class RootViewController: UIViewController {
    
    var delegate : RootDelegate?
    let mapView = MKMapView()
    var locationManager : CLLocationManager = CLLocationManager()
    var isLocationFound = false
    var lots: [Lot] = []
    var annotations: [MKAnnotation] = []
    let bottomSheetVC = BottomSheetViewController()

    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.didTapOnView()
//        UINavigationBar.appearance().barStyle = .blackOpaque
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        UINavigationBar.appearance().barStyle = .default
//        UIApplication.shared.statusBarStyle = .
    }

    
    func createMapView(){
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    
    func createlocationManager(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    

    func fetchLots() {
        mapView.removeAnnotations(annotations)
        let ref = Database.database().reference()
        ref.child("lots").observe(DataEventType.childAdded, with: { (snapshot) in
            guard let selectedLot = snapshot.value as? [String:Any],
                let location = selectedLot["location"] as? [String:Any],
                let users = selectedLot["users"] as? Int,
                let capacity = selectedLot["capacity"] as? Int,
                let cost = selectedLot["cost"] as? Int,
                let latitude  = location["latitude"] as? Double,
                let longitude = location["longitude"] as? Double
                else {return}
            let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let newLot = Lot(location: locationCoordinate, totalCapacity: capacity, cost: cost, currentOcupants: users)
            self.lots.append(newLot)
            DispatchQueue.main.async {
                self.createAnnotation(from: newLot)
            }
        })
    }
    
    
    func createAnnotation(from lot: Lot){
        let annotation = MKPointAnnotation()
        annotation.coordinate = lot.location
        annotation.title = "$\(lot.cost).00/Hr"
        let percent: Int = Int((100*lot.currentOcupants)/lot.totalCapacity)
        annotation.subtitle = "\(percent)% Full"
        annotations.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
    func addSheetViews() {
        let height = view.frame.height
        let width  = view.frame.width
        self.delegate = bottomSheetVC
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        bottomSheetVC.view.frame = CGRect(x: 0, y: height, width: width, height: height)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMapView()
        createlocationManager()
        fetchLots()
        createNav()
        addSheetViews()
        createTapRecognizer()
    }
    
    func createTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
    }
    @objc func viewTapped() {
        delegate?.didTapOnView()
    }
}


extension RootViewController : CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isLocationFound {
            return
        }
        guard let location = locations.first
            else{return}
        if location.horizontalAccuracy < 10 && location.verticalAccuracy < 10 {
            isLocationFound = true
            guard let coordinate = locationManager.location?.coordinate
                else{return}
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
}



extension RootViewController : MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let userLocation = locationManager.location
            else{return nil}
        let userCoordinate = userLocation.coordinate
        let coordinate = annotation.coordinate
        if userCoordinate.latitude != coordinate.latitude && userCoordinate.longitude != coordinate.longitude {
            let annotationView = MKMarkerAnnotationView()
            guard let stringer = annotation.subtitle!
                else{return nil}
            let somthing = stringer.split(separator: "%")[0]
            guard let percentFull: Double = Double(somthing)
                else{return nil}
            var image = UIImage()
            var color = UIColor()
            if percentFull < 75 {
                image = #imageLiteral(resourceName: "greenDot")
                color = Slot.green
            }
            else if percentFull < 95{
                image = #imageLiteral(resourceName: "yellowDot")
                color = Slot.yellow
            }
            else {
                image = #imageLiteral(resourceName: "redDot")
                color = Slot.red
            }
            annotationView.animatesWhenAdded = true
            annotationView.markerTintColor = color
            annotationView.canShowCallout = true
//            annotationView.image = image
            annotationView.titleVisibility = .visible
            annotationView.subtitleVisibility = .adaptive
            annotationView.rightCalloutAccessoryView = UIButton()
            return annotationView
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        viewTapped()
    }
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        //        guard let coordinate = view.annotation?.coordinate
//        //            else{return}
//        //        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//        //        let region = MKCoordinateRegion(center: coordinate, span: span)
//        //        mapView.setRegion(region, animated: true)
//        guard let userLocation = locationManager.location,
//            let annotation = view.annotation
//            else{return}
//        let coordinate = annotation.coordinate
//        for restaurant in restaurants {
//            let restPlacemark = restaurant.placemark.coordinate
//            if restPlacemark.latitude == coordinate.latitude && restPlacemark.longitude == coordinate.longitude {
//                let placemark = MKPlacemark(coordinate: userLocation.coordinate)
//                let userMapItem = MKMapItem(placemark: placemark)
//                self.navigate(from: userMapItem, to: restaurant)
//            }
//        }
//    }
    
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let render = MKPolylineRenderer(overlay: overlay)
//        render.strokeColor = UIColor.blue
//        render.lineWidth = 5
//        return render
//    }
}
