//
//  LocationManager.swift
//  
//
//  Created by Vishnu Ravi on 3/18/20.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    private let maxDistanceFromHome: Double = 30.0 // meters
    
    @Published var locationStatus: CLAuthorizationStatus?
    
    @Published var lastLocation: CLLocation? {
        didSet {
            if self.homeCoordinates != nil {
                // home location is set, calculate distance from home
                guard let lastLocation = self.lastLocation else { return }
                guard let distanceInMeters = self.distanceFromHome(location: lastLocation) else { return }
                self.isHome = !(distanceInMeters > maxDistanceFromHome)
                print("\(distanceInMeters)m from home")
            }
        }
    }
    
    @Published var isHome: Bool? // nil if home location isn't set
    
    @Published var homeCoordinates: CLLocation?
    
    override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func distanceFromHome(location: CLLocation) -> Double? {
        if let homeCoordinates = self.homeCoordinates {
            return location.distance(from: homeCoordinates)
        }else{
            return nil
        }
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
        
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        //print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        //print(#function, location)
    }
    
}
