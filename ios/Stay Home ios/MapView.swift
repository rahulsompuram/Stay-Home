//
//  MapView.swift
//  Stay Home ios
//
//  Created by Vishnu Ravi on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import MapKit
import FirebaseAuth
import FirebaseDatabase

struct MapView: UIViewRepresentable {
    
    @Binding var homeCoordinates: CLLocation?
    
    @Binding var lastLocation: CLLocation?
    
    var annotations: [MKPointAnnotation]
    
    var homePin: MKPointAnnotation

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = context.coordinator
        
        // if home is set, use that as the center, else use the last location
        var location = self.lastLocation ?? CLLocation()
        if let homeLocation = self.homeCoordinates { location = homeLocation }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: false)
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
            // update the pins if anything changes
            view.removeAnnotations(view.annotations)
            
            // home pin
            homePin.title = "Home"
            view.addAnnotation(homePin)
            
            // your location pin
            if let lastLocation = self.lastLocation {
                let currentPin = MKPointAnnotation()
                currentPin.coordinate = lastLocation.coordinate
                currentPin.title = "You"
                view.addAnnotation(currentPin)
            }
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
    }
}
