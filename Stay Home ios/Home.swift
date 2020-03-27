//
//  Map.swift
//  Stay Home ios
//
//  Created by Vishnu Ravi on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase

struct Home: View {
    
    @EnvironmentObject var userData: UserDataViewModel
    
    let pointsPerLevel = 50000
    static let url = "https://rahulsompuram.github.io/Stay-Home/"
    
    @State private var centerCoordinates = CLLocationCoordinate2D()
    
    @State private var locations = [MKPointAnnotation]() // keeps track of home locations
    
    @State private var homePin = MKPointAnnotation() // pin for the home location
    
    @ObservedObject var locationManager = LocationManager()
    
    @State var homeLocationLoaded = false
    
    @State var isAnimating = true
    
    @State var showInfoModal = false
    
    @State var showSpriteModal = false
    
    @State var spriteDict = ["1": "pinkboi", "2": "soapboi", "3": "maskboi", "4": "gloveboi", "5": "sanitizer", "6": "Window", "7": "TP", "8": "Sir_Six_Feet", "9": "Juiceboi", "10": "lungs"]
    
    @State private var showingAlert = false
    
    var body: some View {
        
        ZStack {
            ZStack {
                
                if(self.locationManager.lastLocation != nil && self.homeLocationLoaded){
                    MapView(homeCoordinates: $locationManager.homeCoordinates, lastLocation: $locationManager.lastLocation, annotations: locations, homePin: homePin)
                        .saturation(0)
                        .edgesIgnoringSafeArea(.vertical)
                }else{
                    Text("Getting your location...").font(.custom("AvenirNext-Medium", size: 18))
                }
                
                VStack{
                    
                    // Virus guy button
                    HStack{
                        Button(action: {
                            self.showInfoModal.toggle()
                        }) {
                            Image(systemName: "info.circle.fill").renderingMode(.original).resizable().frame(width: 25, height: 25, alignment: .center)
                                .padding(25)
                                .shadow(radius: 10)
                        }.sheet(isPresented: self.$showInfoModal) {
                            MoreInfoModal()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.showSpriteModal.toggle()
                        }) {
                            Image(self.spriteDict["\(self.userData.user?.level ?? 1)"] ?? "").renderingMode(.original).resizable().frame(width: 75, height: 75, alignment: .center)
                                .padding(25)
                                .shadow(radius: 10)
                        }.sheet(isPresented: self.$showSpriteModal) {
                            SpriteModal().environmentObject(self.userData)
                        }
                    }
                    
                    // Change home button
                    VStack {
                        Spacer()
                        Text(self.locationManager.isHome != nil ? (self.locationManager.isHome! ? "You're home" : "You're not home") : "")
                            .font(.custom("AvenirNext-Bold", size: 18))
                            .frame(width: 300, height: 50, alignment: .center)
                        HStack {
                            Button(action: {
                                guard let currentUser = Auth.auth().currentUser else { return }
                                
                                if let lastLocation = self.locationManager.lastLocation {
                                    
                                    let ref = Database.database().reference().child("Users").child(currentUser.uid)
                                    let timeInterval = NSDate().timeIntervalSince1970
                                    
                                    ref.child("LastRelocTimestamp").observeSingleEvent(of: .value) { (snapshot) in
                                        let lastRelocTimestamp = snapshot.value as! Double
                                        let delta_t = timeInterval - lastRelocTimestamp
                                        
                                        if (delta_t < 86400 && lastRelocTimestamp != 0){
                                            self.showingAlert = true
                                        } else {
                                            // set home to the most recent location
                                            self.locationManager.homeCoordinates = lastLocation
                                            
                                            // set the home pin
                                            let newHomePin = MKPointAnnotation()
                                            newHomePin.coordinate = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                                            self.homePin = newHomePin
                                            
                                            // save the updated data to the plist
                                            let newHomeLocation = HomeLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                                            
                                            HomeLocationLoader.write(homeLocation: newHomeLocation)
                                            
                                            if lastRelocTimestamp != 0 {
                                                ref.child("LastRelocTimestamp").setValue(NSDate().timeIntervalSince1970)
                                            }else{
                                                ref.child("LastRelocTimestamp").setValue(1000)
                                            }
                                        }
                                    }
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
            
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Cannot change home location"), message: Text("You can only change your home location once per day"), dismissButton: .default(Text("Got it!")))
        }
            
        .onAppear {
            // read in home location from plist
            let homeLocation = HomeLocationLoader.load()
            
            if(homeLocation.latitude != 0 && homeLocation.longitude != 0){
                
                // set home coordinates
                self.locationManager.homeCoordinates = CLLocation(latitude: homeLocation.latitude, longitude: homeLocation.longitude)
                
                // add a pin for the home location
                let newHomePin = MKPointAnnotation()
                newHomePin.coordinate = CLLocationCoordinate2D(latitude: homeLocation.latitude, longitude: homeLocation.longitude)
                self.homePin = newHomePin
            }
            
            self.homeLocationLoaded = true
            
        }
    }
}
