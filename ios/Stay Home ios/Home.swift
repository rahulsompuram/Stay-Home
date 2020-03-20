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
    
    @State var showSpriteModal = false
    @State var sprites = ["pinkboi", "pinkboi", "pinkboi", "pinkboi", "pinkboi", "pinkboi", "pinkboi", "pinkboi", "pinkboi", "pinkboi"]
    
    var body: some View {
        ZStack {
            ZStack {
                MapView(homeCoordinates: $locationManager.homeCoordinates, lastLocation: $locationManager.lastLocation, annotations: locations).saturation(0).edgesIgnoringSafeArea(.vertical)
                
                VStack{
                    
                    // Virus guy button
                    HStack{
                        Spacer()
                
                        Button(action: {
                            self.showSpriteModal.toggle()
                        }) {
                        Image("pinkboi").renderingMode(.original).resizable().frame(width: 75, height: 75, alignment: .center)
                            .padding(25)
                            .shadow(radius: 10)
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
            }.blur(radius: self.showSpriteModal ? 10 : 0).animation(.easeOut)
                .onAppear {
                    self.showSpriteModal = false
            }
            
            Color(red: 89/255, green: 123/255, blue: 235/255).edgesIgnoringSafeArea(.all).opacity(self.showSpriteModal ? 0.5 : 0)
            .animation(.easeOut)
         
            if (self.showSpriteModal) {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("my points").font(.custom("AvenirNext-Medium", size: 24)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5))
                            Text("100,000,000").font(.custom("AvenirNext-Bold", size: 32)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 5))
                        }.padding()
                        Spacer()
                        Button(action: {
                                self.showSpriteModal.toggle()
                            }){
                                Image(systemName: "xmark")
                                    .resizable()
                                    .font(Font.title.weight(.heavy))
                                    .foregroundColor(Color(red: 78/255, green: 89/255, blue: 140/255))
                                    .frame(width: 20, height: 20).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))
                    }
                    VStack(alignment: .center) {
                         Image("pinkboi").resizable().frame(width: 150, height: 150, alignment: .center)
                         .shadow(radius: 10)
                         Text("COVID Cody").font(.custom("AvenirNext-Bold", size: 22)).foregroundColor(Color.white)
                         Text("Stay home and flatten the curve!").font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(sprites, id: \.self) { sprites in
                                //Image($0).resizable().frame(width: 75, height: 75, alignment: .center)
                                Color(red: 78/255, green: 89/255, blue: 140/255).frame(width: 75, height: 75).opacity(0.5).cornerRadius(8).padding()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("100,000 points until next sprite unlock").font(.custom("AvenirNext-Bold", size: 18)).foregroundColor(Color(red: 78/255, green: 89/255, blue: 140/255)).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        ProgressBar(progress: .constant(1/6), width: 300, height: 15)
                    }.padding()
                    
                    Spacer()
                }
            }
        }
    }
}

struct ProgressBar: View {
    @Binding var progress: CGFloat
    var width: CGFloat
    var height: CGFloat
    var barColor: Color?
    var bgColor: Color?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(self.bgColor ?? Color.white)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(self.barColor ?? Color(red: 78/255, green: 89/255, blue: 140/255))
                    .frame(width: self.progress*geometry.size.width, height: geometry.size.height)
            }
        }
            .frame(width: width, height: height)
    }

}
