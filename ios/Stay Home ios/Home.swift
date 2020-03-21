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
import SDWebImageSwiftUI
import SDWebImage

struct Home: View {
    
    let pointsPerLevel = 50000
    
    @State private var centerCoordinates = CLLocationCoordinate2D()
    
    @State private var locations = [MKPointAnnotation]() // keeps track of home locations
    
    @State private var homePin = MKPointAnnotation() // pin for the home location
    
    @ObservedObject var locationManager = LocationManager()
    
    @State var firebaseDataLoaded = false
    
    @State var isAnimating = true

    @State var showInfoModal = false
    
    @State var showSpriteModal = false
    
    @State var currentSprite = "pinkboi"
    @State var gifURL = "https://user-images.githubusercontent.com/1212163/77212444-803cb400-6add-11ea-9ba3-3b173e7ce264.gif"
    @State var nickname = "COVID Cody"
    @State var description = "Stay home and flatten the curve!"
    @State var sprites = ["pinkboi", "covid19_resting", "facemask", "hands", "sanitizer", "window", "toiletpaper", "tapemeasure", "juice", "lungs"]
    
    @State var spriteDict = ["1": ["name": "pinkboi", "gif": "https://user-images.githubusercontent.com/1212163/77212444-803cb400-6add-11ea-9ba3-3b173e7ce264.gif", "nickname": "COVID Cody", "desc": "Stay home and flatten the curve!"],
                             "2": ["name": "covid19_resting", "gif": "", "nickname": "Soap Sam", "desc": "Soap and water is extremely effective!"],
                             "3": ["name": "facemask", "gif": "", "nickname": "Facemask Frank", "desc": "Keeping your hands off of your face keeps the virus off too!"],
                             "4": ["name": "hands", "gif": "", "nickname": "Hands Hans", "desc": "Soap and water is extremely effective!"],
                             "5": ["name": "sanitizer", "gif": "", "nickname": "Soap Sam", "desc": "Soap and water is extremely effective!"],
                             "6": ["name": "window", "gif": "", "nickname": "Soap Sam", "desc": "Soap and water is extremely effective!"],
                             "7": ["name": "toiletpaper", "gif": "", "nickname": "Soap Sam", "desc": "Soap and water is extremely effective!"],
                             "8": ["name": "tapemeasure", "gif": "", "nickname": "Soap Sam", "desc": "Soap and water is extremely effective!"],
                             "9": ["name": "juice", "gif": "", "nickname": "Soap Sam", "desc": "Soap and water is extremely effective!"],
                             "10": ["name": "lungs", "gif": "", "nickname": "Soap Sam", "desc": "Soap and water is extremely effective!"]
                            ]
    @State var reverseDict = ["pinkboi": 1, "covid19_resting": 2, "facemask": 3, "hands": 4, "sanitizer": 5, "window": 6, "toiletpaper": 7, "tapemeasure": 8, "juice": 9, "lungs": 10]
    
    // Shows unlocked sprites based off user level
    @State var userLevel = 1
    @State var points: Int = 0
    @State var pointsToNextLevel: Int = 0
    
    // For progress bar for next sprite unlock
    @State var progress : CGFloat = 1
    @State var outOfProgess : CGFloat = 6
    
    @State private var showingAlert = false
    
    // Initializes sprite information based off user level
    func initSpriteInfo(currentUserLevel: Int) {
        self.currentSprite = self.spriteDict["\(currentUserLevel)"]!["name"]!
        self.gifURL = self.spriteDict["\(currentUserLevel)"]!["gif"]!
        self.nickname = self.spriteDict["\(currentUserLevel)"]!["nickname"]!
        self.description = self.spriteDict["\(currentUserLevel)"]!["desc"]!
    }
    
    // Sets current sprite when user chooses in horizontal picker
    func setCurrentSprite(spriteName: String) {
        let currentUserLevel = self.reverseDict[spriteName]!
        initSpriteInfo(currentUserLevel: currentUserLevel)
    }
    
    func getUnlockedSprites() -> [String] {
        var counter = 0
        var unlockedSprites : [String] = []
        var levelCounter = userLevel + 1
        
        while (counter < self.userLevel) {
            unlockedSprites.append(sprites[counter])
            counter += 1
        }
        
        let leftover = sprites.count - userLevel
        
        if leftover > 0 {
            for _ in (1...leftover) {
                unlockedSprites.append("Level \(levelCounter)")
                levelCounter += 1
            }
        }
        
        return unlockedSprites
    }
    
    
    // tap gesture for sprite
    var tapSprite: some Gesture {
        TapGesture(count: 1)
            .onEnded {
                // toggle +1 on
                self.plusOneActive.toggle()
                
                // wait 0.5s then toggle +1 off
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.plusOneActive.toggle()
                }
                
        }
    }
    
    @State var plusOneActive = false
    
    var body: some View {
        
        ZStack {
            ZStack {
                
                if(self.locationManager.lastLocation != nil && self.firebaseDataLoaded){
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
                                    
                                    let timeInterval = NSDate().timeIntervalSince1970
                                    
                                    let ref = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
                                    
                                    // check if there's already been a relocation in the last 24 hours
                                    ref.child("LastRelocTimestamp").observeSingleEvent(of: .value) { (snapshot) in
                                        let lastRelocTimestamp = snapshot.value as! Double
                                        let delta_t = timeInterval - lastRelocTimestamp
                                        
                                        if (delta_t < 86400 && lastRelocTimestamp != 0) {
                                            self.showingAlert = true
                                        } else {
                                            // set home to the most recent location
                                            self.locationManager.homeCoordinates = lastLocation
                                            
                                            // push new home location to firebase
                                            ref.child("HomeLat").setValue(lastLocation.coordinate.latitude)
                                            ref.child("HomeLong").setValue(lastLocation.coordinate.longitude)
                            
                                            // set home pin
                                            let newHomePin = MKPointAnnotation()
                                            newHomePin.coordinate = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                                            self.homePin = newHomePin
                                            
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
            }.blur(radius: self.showSpriteModal ? 20 : 0).animation(.easeOut)
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
                            Text("\(self.points)").font(.custom("AvenirNext-Bold", size: 32)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
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
                        ZStack{
                            HStack{
                                Spacer()
                                Text("+1")
                                    .opacity(self.plusOneActive ? 1 : 0)
                                    .scaleEffect(self.plusOneActive ? 3 : 1)
                                    .animation(.default)
                                    .padding(.trailing, 50)
                            }
                        WebImage(url: URL(string: self.gifURL), isAnimating: $isAnimating)
                        .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                        .placeholder(Image(systemName: "photo")) // Placeholder Image
                        .placeholder {
                            Rectangle().foregroundColor(.gray)
                        }
                        .indicator(.activity) // Activity Indicator
                        .animation(.easeInOut(duration: 0.5)) // Animation Duration
                        .transition(.fade) // Fade Transition
                        .scaledToFit()
                        .frame(width: 150, height: 150, alignment: .center)
                        .gesture(tapSprite)
                        }

                        
                        Text(self.nickname).font(.custom("AvenirNext-Bold", size: 22)).foregroundColor(Color.white)
                        Text(self.description).font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(getUnlockedSprites(), id: \.self) { sprite in
                                Group {
                                    if (sprite.contains("Level")) {
                                        ZStack {
                                            Color(red: 78/255, green: 89/255, blue: 140/255).frame(width: 75, height: 75).opacity(0.5).cornerRadius(8).padding()
                                            Text(sprite).font(.custom("AvenirNext-Bold", size: 14)).foregroundColor(Color.white)
                                        }
                                    } else {
                                        Button(action: {
                                            self.currentSprite = sprite
                                            self.setCurrentSprite(spriteName: sprite)
                                        }) {
                                        Image(sprite).renderingMode(.original).resizable().frame(width: 75, height: 75, alignment: .center)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("\(self.pointsToNextLevel) points until next sprite unlock").font(.custom("AvenirNext-Bold", size: 18)).foregroundColor(Color(red: 78/255, green: 89/255, blue: 140/255)).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        ProgressBar(progress: .constant(1 - CGFloat(self.pointsToNextLevel) / CGFloat(self.pointsPerLevel)), width: 300, height: 15)
                    }.padding()
                    
                    Spacer()
                }.onAppear {
                    self.initSpriteInfo(currentUserLevel: self.userLevel)
                }
            }
        }
        
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Cannot change home location"), message: Text("You can only change your home location once per day"), dismissButton: .default(Text("Got it!")))
        }
        
        .onAppear {
            // check firebase for existing home location
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
                
                if (homeLat != 0 && homeLong != 0){
                    // if home coordinates exist in firebase, set them locally.
                    self.locationManager.homeCoordinates = CLLocation(latitude: homeLat, longitude: homeLong)
                    
                    // add a pin for the new home location
                    let newHomePin = MKPointAnnotation()
                    newHomePin.coordinate = CLLocationCoordinate2D(latitude: homeLat, longitude: homeLong)
                    self.homePin = newHomePin
                }
                
                self.firebaseDataLoaded = true
            }
            
            ref.child("Points").observe(.value) { (snapshot) in
                if let points = snapshot.value as? Int {
                    self.points = points
                    
                    
                    // simple linear curve
                    self.userLevel = Int(points / self.pointsPerLevel) + 1
                    
                    self.pointsToNextLevel = self.pointsPerLevel - (points % self.pointsPerLevel)
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
