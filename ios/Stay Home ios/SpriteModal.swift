//
//  SpriteModal.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/21/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import SDWebImage

struct SpriteModal: View {
    @Environment(\.presentationMode) var presentationMode
    
    let pointsPerLevel = 50000
    static let url = "https://rahulsompuram.github.io/Stay-Home/"
    
    @State var isAnimating = true
    
    @State var firebaseLoading = true
    
    @State var sprites = ["pinkboi", "soapboi", "maskboi", "gloveboi", "sanitizer", "Window", "TP", "Sir_Six_Feet", "Juiceboi", "lungs"]
    
    @State var spriteDict = ["1": ["name": "pinkboi", "gif": url + "pinkboi.gif", "nickname": "Covid Cody", "desc": "Together we can beat corona virus!"],
                             "2": ["name": "soapboi", "gif": url + "soapboi.gif", "nickname": "Soapy Sam", "desc": "Soap and water is extremely effective. Wash your hands!"],
                             "3": ["name": "maskboi", "gif": url + "maskboi.gif", "nickname": "Facemask Frank", "desc": "These guys can help prevent the viral spread if used properly."],
                             "4": ["name": "gloveboi", "gif": url + "gloveboi.gif", "nickname": "Hands Hans", "desc": "Keeping your hands off of your face keeps the virus off too."],
                             "5": ["name": "sanitizer", "gif": url + "sanitizer.gif", "nickname": "Sanitizer Suzy", "desc": "You've seen this one on the news."],
                             "6": ["name": "Window", "gif": url + "Window.gif", "nickname": "Window Windy", "desc": "Open windows to improve ventilation!"],
                             "7": ["name": "TP", "gif": url + "TP.gif", "nickname": "T.P.", "desc": "The way some people buy toilet paper...you gotta wonder what goes on in the bathroom!"],
                             "8": ["name": "Sir_Six_Feet", "gif": url + "Sir_Six_Feet.gif", "nickname": "Sir Six Feet", "desc": "If you have to go out, maintain safe distance of 6 feet!"],
                             "9": ["name": "Juiceboi", "gif": url + "Juiceboi.gif", "nickname": "Juice Jésus", "desc": "Vitamin C won't prevent covid, but staying hydrated keeps your immune system healthy!"],
                             "10": ["name": "lungs", "gif": url + "lungs.gif", "nickname": "Lisa & Larry", "desc": "These superheros keep the wind in your sails. STAY home to keep them protected!"]
    ]
    @State var reverseDict = ["pinkboi": 1, "soapboi": 2, "maskboi": 3, "gloveboi": 4, "sanitizer": 5, "Window": 6, "TP": 7, "Sir_Six_Feet": 8, "Juiceboi": 9, "lungs": 10]
    
    // Shows unlocked sprites based off user level
    @State var userLevel = 1
    @State var points: Int = 0
    @State var pointsToNextLevel: Int = 0
    
    // For progress bar for next sprite unlock
    @State var progress : CGFloat = 1
    @State var outOfProgess : CGFloat = 6
    
    func getUnlockedSprites() -> [String] {
        var counter = 0
        var unlockedSprites : [String] = []
        var levelCounter = userLevel + 1
        
        while (counter < self.userLevel && counter < 10) {
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
                
                let ref = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    let points = snapshot.childSnapshot(forPath: "Points").value as! Int
                    let unredeemedPoints = snapshot.childSnapshot(forPath: "UnredeemedPoints").value as! Int
                    let username = snapshot.childSnapshot(forPath: "Username").value as! String
                    
                    ref.child("Points").setValue(points + 1)
                    ref.child("UnredeemedPoints").setValue(unredeemedPoints + 1)
                    
                    Database.database().reference().child("Leaderboard").child(username).setValue(unredeemedPoints + 1)
                    
                }
                
                // wait 0.5s then toggle +1 off
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.plusOneActive.toggle()
                }
                
        }
    }
    
    @State var plusOneActive = false
    
    var body: some View {
        ZStack {
            Color.init(red: 78/255, green: 89/255, blue: 140/255).edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("my points").font(.custom("AvenirNext-Medium", size: 24)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5))
                        Text("\(self.points)").font(.custom("AvenirNext-Bold", size: 32)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    }.padding()
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "xmark")
                            .resizable()
                            .font(Font.title.weight(.heavy))
                            .foregroundColor(Color(red: 240/255, green: 176/255, blue: 175/255))
                            .frame(width: 20, height: 20).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 25))
                }
                VStack(alignment: .center) {
                    ZStack{
                        HStack{
                            Text("+1")
                                .foregroundColor(Color(red: 240/255, green: 176/255, blue: 175/255))
                                .opacity(self.plusOneActive ? 1 : 0)
                                .scaleEffect(self.plusOneActive ? 3 : 1)
                                .animation(.default)
                                .padding(.leading, 50)
                            Spacer()
                            Text("+1")
                                .foregroundColor(Color(red: 240/255, green: 176/255, blue: 175/255))
                                .opacity(self.plusOneActive ? 1 : 0)
                                .scaleEffect(self.plusOneActive ? 3 : 1)
                                .animation(.default)
                                .padding(.trailing, 50)
                        }
                        if(!self.firebaseLoading){
                            
                            WebImage(url: URL(string: self.spriteDict["\(self.userLevel)"]!["gif"]!), isAnimating: $isAnimating)
                                .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                                .placeholder(Image(systemName: "photo")) // Placeholder Image
                                .placeholder {
                                    Circle().foregroundColor(Color(red: 89/255, green: 123/255, blue: 235/255))
                            }
                                .indicator(.activity) // Activity Indicator
                                .animation(.easeInOut(duration: 0.5)) // Animation Duration
                                .transition(.fade) // Fade Transition
                                .scaledToFit()
                                .frame(width: 200, height: 200, alignment: .center)
                                .gesture(tapSprite)
                        }else{
                            Spacer().frame(height: 200)
                        }
                        
                    }
                    
                    VStack(alignment: .center) {
                        Text(self.spriteDict["\(self.userLevel)"]!["nickname"]!).font(.custom("AvenirNext-Bold", size: 22)).foregroundColor(Color.white)
                        HStack {
                            Spacer()
                            Text(self.spriteDict["\(self.userLevel)"]!["desc"]!).font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.white).multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Text("Unlocked\nSprites").font(.custom("AvenirNext-Bold", size: 14)).foregroundColor(Color(red: 89/255, green: 123/255, blue: 235/255)).padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 5))
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(getUnlockedSprites(), id: \.self) { sprite in
                                Group {
                                    if (sprite.contains("Level")) {
                                        ZStack {
                                            Color(red: 89/255, green: 123/255, blue: 235/255).frame(width: 75, height: 75).opacity(0.5).cornerRadius(8).padding()
                                            Text(sprite).font(.custom("AvenirNext-Bold", size: 14)).foregroundColor(Color.white)
                                        }
                                    } else {
                                        Image(sprite).renderingMode(.original).resizable().frame(width: 75, height: 75, alignment: .center)
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                Spacer()
                
                VStack(alignment: .center) {
                    if (self.pointsToNextLevel == 999999999) {
                        Text("All current levels are unlocked!").font(.custom("AvenirNext-Bold", size: 18)).foregroundColor(Color(red: 89/255, green: 123/255, blue: 235/255)).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        ProgressBar(progress: .constant(CGFloat(1.0)), width: 300, height: 15)
                    } else {
                        Text("\(self.pointsToNextLevel) points until next sprite unlock").font(.custom("AvenirNext-Bold", size: 18)).foregroundColor(Color(red: 89/255, green: 123/255, blue: 235/255)).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        ProgressBar(progress: .constant(1 - CGFloat(self.pointsToNextLevel) / CGFloat(self.pointsPerLevel)), width: 300, height: 15)
                    }
                }.padding()
                
                Spacer()
            }
        }.onAppear {
            let ref = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
            
            ref.child("Points").observe(.value) { (snapshot) in
                if let points = snapshot.value as? Int {
                    self.points = points
                    
                    
                    // simple linear curve
                    var userLevel = Int(points / self.pointsPerLevel) + 1
                    if (userLevel > 10) {
                        userLevel = 10
                    }
                    self.userLevel = userLevel
                    
                    if (self.userLevel == 10) {
                        self.pointsToNextLevel = 999999999
                    } else {
                        self.pointsToNextLevel = self.pointsPerLevel - (points % self.pointsPerLevel)
                    }
                    self.firebaseLoading = false
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
                    .foregroundColor(self.barColor ?? Color(red: 89/255, green: 123/255, blue: 235/255))
                    .frame(width: self.progress*geometry.size.width, height: geometry.size.height)
            }
        }
        .frame(width: width, height: height)
    }
    
}
