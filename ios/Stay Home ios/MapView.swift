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

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = context.coordinator
        
        if let location = self.lastLocation {
            // center map to most recent location
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: false)
        }
        
        let ref = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var homeLat: Double = 0.0
            var homeLong: Double = 0.0
            
            if let hlat = snapshot.childSnapshot(forPath: "HomeLat").value as? Double {
                homeLat = hlat
            }
            if let hlong = snapshot.childSnapshot(forPath: "HomeLong").value as? Double {
                homeLong = hlong
            }
            
            // if homeLat or homeLong are 0, zoom in once on user
            // if both are nonzero, zoom in on (homeLat, homeLong)
        }
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {

        if annotations.count != view.annotations.count {
            // add a new pin if there's a new home location
            view.removeAnnotations(view.annotations)
            view.addAnnotation(annotations[annotations.count-1])
            
            // push to firebase
            var ref: DatabaseReference!
            ref = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
            ref.child("HomeLat").setValue(annotations[annotations.count-1].coordinate.latitude)
            ref.child("HomeLong").setValue(annotations[annotations.count-1].coordinate.longitude)
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
