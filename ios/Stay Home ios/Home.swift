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
    
    @ObservedObject var locationManager = LocationManager()
    
    var currentCoordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: locationManager.lastLocation?.coordinate.latitude ?? 0, longitude: locationManager.lastLocation?.coordinate.longitude ?? 0)
    }
    
    var body: some View {
        ZStack {
            MapView(centerCoordinates: $centerCoordinates, homeCoordinates: $locationManager.homeCoordinates)
                .edgesIgnoringSafeArea(.vertical)
            
            // Current location circle
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack{
                
                // Virus guy button
                HStack{
                    Spacer()
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 32, height: 32)
                        .padding(25)
                }
                
                // Change home button
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            self.locationManager.homeCoordinates = self.currentCoordinates
                        }) {
                            Text("Change Home")
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
