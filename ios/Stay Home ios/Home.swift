//
//  Map.swift
//  Stay Home ios
//
//  Created by Vishnu Ravi on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import MapKit

struct Home: View {
    
    @State private var centerCoordinates = CLLocationCoordinate2D()
    
    @State private var locations = [MKPointAnnotation]() // keeps track of home locations
    
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            MapView(homeCoordinates: $locationManager.homeCoordinates, lastLocation: $locationManager.lastLocation, annotations: locations)
                .edgesIgnoringSafeArea(.vertical)
            
            VStack{
                
                // Virus guy button
                HStack{
                    Spacer()
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .padding(25)
                }
                
                // Change home button
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            if let lastLocation = self.locationManager.lastLocation {
                                // set home to the most recent location
                                self.locationManager.homeCoordinates = lastLocation
                                
                                // add a pin for the new home location
                                let newLocation = MKPointAnnotation()
                                newLocation.coordinate = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                                self.locations.append(newLocation)
                            }
                        }) {
                            Text(self.locationManager.homeCoordinates == nil ? "Set Home" : "Change Home")
                        }
                        .padding()
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(Color(UIColor(red:0.94, green:0.69, blue:0.69, alpha:1.00)))
                        .cornerRadius(25)
                        .foregroundColor(.white)
                        .font(.title)
                    }
                    Spacer().frame(height: 50)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
