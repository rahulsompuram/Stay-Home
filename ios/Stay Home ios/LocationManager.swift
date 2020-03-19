//
//  LocationManager.swift
//  
//
//  Created by Vishnu Ravi on 3/18/20.
//

import Foundation
import CoreLocation
import Combine
import FirebaseDatabase
import FirebaseAuth


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
                
                updateFirebase(isHome: self.isHome ?? false)
            }
        }
    }
    
    func updateFirebase(isHome: Bool) {
        var ref: DatabaseReference!
        let userID = Auth.auth().currentUser!.uid
        ref = Database.database().reference().child("Users").child(userID)
        let timeInterval = NSDate().timeIntervalSince1970
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let lastTickTimestamp = snapshot.childSnapshot(forPath: "LastTickTimestamp").value as? Double ?? 0.0
            let timeSinceLastTick = timeInterval - lastTickTimestamp
            
            // they are at home
            if (isHome && timeSinceLastTick < 500) {
                let currentStreak = snapshot.childSnapshot(forPath: "Streak").value as? IntegerLiteralType ?? 0
                let currentPoints = snapshot.childSnapshot(forPath: "Points").value as? IntegerLiteralType ?? 0
                let currentUnredeemedPoints = snapshot.childSnapshot(forPath: "UnredeemedPoints").value as? IntegerLiteralType ?? 0
                
                var additionalPoints = 200
                let newStreak = currentStreak + 1
                
                if (newStreak % 21 == 0) {
                    additionalPoints += 1000
                }
                
                if (newStreak % 500 == 0) {
                    let bonus = 20000 + 10000 * log2(Double(newStreak / 500))
                    additionalPoints += Int(bonus)
                }
                
                ref.child("Streak").setValue(newStreak)
                ref.child("Points").setValue(currentPoints + additionalPoints)
                print("Points = " + currentPoints.description + " + " + additionalPoints.description)
                ref.child("UnredeemedPoints").setValue(currentUnredeemedPoints + additionalPoints)
                
            } else {
                
                ref.child("Streak").setValue(0)
                
            }
            
            
            ref.child("LastTickTimestamp").setValue(timeInterval)
        }
        
    }
    
    @Published var isHome: Bool? // nil if home location isn't set or user denies/restricts location services
    
    @Published var homeCoordinates: CLLocation?
    
    override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
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
        
        if status == .restricted || status == .denied || status == .notDetermined {
            self.isHome = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        //print(#function, location)
    }
    
}
