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
            MapView(homeCoordinates: $locationManager.homeCoordinates, lastLocation: $locationManager.lastLocation, annotations: locations).grayscale(1.0).contrast(2.0)
                .edgesIgnoringSafeArea(.vertical)
            
            VStack{
                
                // Virus guy button
                HStack{
                    Spacer()
                    Image("covid19_resting").resizable().frame(width: 75, height: 75, alignment: .center)
                    .padding(25)
                    .shadow(radius: 10)
                }
                
                // Change home button
                VStack {
                    Spacer()
                    Text(self.locationManager.isHome != nil ? (self.locationManager.isHome! ? "You're home" : "You're not home") : "")
                        .font(.custom("AvenirNext-Bold", size: 18))
                        .frame(width: 300, height: 50, alignment: .center)
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
                        .font(.custom("AvenirNext-Medium", size: 20))
                        .padding()
                        .frame(width: 300, height: 50, alignment: .center)
                        .background(Color(red: 240/255, green: 176/255, blue: 175/255))
                        .foregroundColor(.white)
                        .border(Color(red: 240/255, green: 176/255, blue: 175/255), width: 1)
                        .cornerRadius(25)
                        .shadow(radius: 10)
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
