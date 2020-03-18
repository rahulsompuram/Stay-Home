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
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    @ObservedObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate)
                .edgesIgnoringSafeArea(.all)
            HStack {
                Text("latitude: \(userLatitude)")
                Text("longitude: \(userLongitude)")
            }
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
                            // create a new location
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
