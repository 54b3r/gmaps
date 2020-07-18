//
//  ViewController.swift
//  gmaps
//
//  Created by Marvin Matos on 7/15/20.
//  Copyright © 2020 Marvin Matos. All rights reserved.
//

import UIKit
import GoogleMaps
// get location of
class VacationDestination: NSObject {
    let name: String
    let subtext: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, subtext: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.subtext = subtext
        self.location = location
        self.zoom = zoom
    }
    
}

class ViewController: UIViewController {
    var locationManager = CLLocationManager()
    var mapView: GMSMapView?
    var currentDestination: VacationDestination?
    
    // Lets have an array of destinations to go through in a strategic way, lets put some logic in there to get some workflow going 40.680216, -73.939027
     //desMarvinsCrib = CLLocationCoordinate2DMake(40.680216,-73.939027)
     //desCentralPark = CLLocationCoordinate2DMake(40.78125, -73.966729)
     //desSydney = CLLocationCoordinate2DMake(-33.86,151.20)
    
    // once env is built this should be coming from DB or service
    let destinations = [
        VacationDestination(name: "Marvins Crib", subtext: "Home", location: CLLocationCoordinate2D(latitude: 40.680216,longitude: -73.939027), zoom: 15),
        VacationDestination(name: "Central Park",subtext: "NYC Park",location: CLLocationCoordinate2D(latitude: 40.78125, longitude: -73.966729), zoom: 13),
        VacationDestination(name: "Sydney", subtext: "Australia", location: CLLocationCoordinate2D(latitude: -33.86,longitude: 151.20), zoom: 13)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize the google maps service key api
        GMSServices.provideAPIKey("AIzaSyAC3sAZXI89euXtUaq0Yts8f8WbxQtv8d0")
        self.navigationItem.title = "Intresting Locations"
        // Do any additional setup after loading the view.
        // Set the position of the map that will be shown
         // Sydney Australia
        // let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let camera = GMSCameraPosition.camera(withLatitude: 40.742293, longitude: -73.994100, zoom: 13)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        self.view.addSubview(mapView!)
        
        // Create a marker in the center of the map
        let marker = GMSMarker()
        // WW International 40.742293, -73.994100
        marker.position = CLLocationCoordinate2D(latitude: 40.742293, longitude: -73.994100)
        marker.title = "WW International Headquarters"
        marker.snippet = "New York, New York"
        marker.map = mapView!
        // Remove this marker for a sec
//        mapView?.clear()
        // Make sure for the action, you use action: #selector
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(sender:)))
        
    }
    // Maybe pass in the Lat, long, title, and snippet?
    //func next(latt:Int, lng:Int)  {
    @objc func next(sender: UIBarButtonItem) {
        if currentDestination == nil {
            currentDestination = destinations.first
            setMapCamera()
        } else {
            // this if just makes sure that we bind index to a non nil value
            let destinationsArray = destinations
            let destinationsIndex = destinations.firstIndex(of: currentDestination!)
            //  let destinationsIndexEnd = destinations.endIndex
            
            if  destinationsArray[safe: destinationsIndex!] != nil {
                // catch error
                currentDestination = destinationsArray[safe: destinationsIndex! + 1]
                setMapCamera()
            }

        }
    }
    
    private func setMapCamera() {
        // Set the mapView to be current destination (first destination in the list of destinations)
        CATransaction.begin()
        // Set animation speed of camera moving to next location
        CATransaction.setValue(1.5, forKey: kCATransactionAnimationDuration)
        mapView!.animate(to: GMSCameraPosition.camera(withLatitude: currentDestination!.location.latitude, longitude: currentDestination!.location.longitude, zoom: currentDestination!.zoom))
        CATransaction.commit()
        let m = GMSMarker(position: currentDestination!.location)
        // Should be set via form or something
        m.title = currentDestination!.name
        m.snippet = currentDestination!.subtext
        m.map = mapView
    }
    
    func getUsersCurrentLocation() {
        // Get location of user using CoreLocation lib
        // ask user to use location services
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            // If we have permission to use location services, lets get the current location of the phone
            let userLocation:CLLocationManager = locationManager
            
            let lat = userLocation.location?.coordinate.latitude
            let long = userLocation.location?.coordinate.longitude
            
            
            let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 12)
            let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)

            
            // Needed to set the var userLocation to the type so i can access the methods?
            let uLMarker = GMSMarker()
            // Ovverride where the map will open up to
            // mapView.camera = GMSCameraPosition.camera(withLatitude: 40.78125, longitude: -73.966729, zoom: 10.0)
            // need to make sure its unwrapped
            
            
            uLMarker.position = CLLocationCoordinate2D(latitude: lat!,
                                                       longitude: long!)
            uLMarker.title = "GPS Location"
            uLMarker.snippet = "Users Current Location"
            uLMarker.map = mapView
        }
    }
}

