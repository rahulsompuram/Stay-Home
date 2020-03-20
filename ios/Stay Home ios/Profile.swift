//
//  Profile.swift
//  Stay Home ios
//
//  Created by Vishnu Ravi on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import Firebase

struct Profile: View {
    
    @State var username = ""
    @State var points = 0
    
    var body: some View {
        ZStack {
            Color.init(red: 78/255, green: 89/255, blue: 140/255)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Profile")
                        .font(.custom("AvenirNext-Bold", size: 30)).foregroundColor(Color.white).padding()
                    Spacer()
                }
                
                ZStack {
                    Color.init(red: 89/255, green: 123/255, blue: 235/255).frame(maxWidth: .infinity, maxHeight: 350).opacity(0.75).clipShape(Circle()).shadow(radius: 10)

                    VStack {
                        VStack {
                            Image("pinkboi").resizable().frame(width: 150, height: 150, alignment: .center)
                            .shadow(radius: 10)
                            
                            Text("\(self.username)").font(.custom("AvenirNext-Bold", size: 26)).foregroundColor(Color.white)
                        }.padding()

                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                Text("my points").font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                                Text("\(self.points)").font(.custom("AvenirNext-Bold", size: 26)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 15))
                            }
                            Spacer()
                        }
                    }.padding(EdgeInsets(top: 50, leading: 0, bottom: 15, trailing: 0))
                }
                
                Spacer()
                Login().frame(width: 300, height: 50).padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 15))
            }
        }.onAppear {
            var ref = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if let username = snapshot.childSnapshot(forPath: "Username").value as? String {
                    self.username = username
                }
                
                if let points = snapshot.childSnapshot(forPath: "Points").value as? Int {
                    self.points = points
                }
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
