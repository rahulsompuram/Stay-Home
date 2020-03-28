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
    
    @EnvironmentObject var userData: UserDataViewModel
    
    // sprite image to choose based off user points
    @State var spriteDict = [1: "pinkboi", 2: "soapboi", 3: "maskboi", 4: "gloveboi", 5: "sanitizer", 6: "Window", 7: "TP", 8: "Sir_Six_Feet", 9: "Juiceboi", 10: "lungs"]
    
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
                            Image(self.spriteDict[self.userData.user?.level ?? 1] ?? "").resizable().frame(width: 150, height: 150, alignment: .center)
                            .shadow(radius: 10)
                            
                            Text("\(self.userData.user?.username ?? "")").font(.custom("AvenirNext-Bold", size: 26)).foregroundColor(Color.white)
                        }.padding()

                        HStack {
                            Spacer()
                            VStack(alignment: .center) {
                                Text("my points").font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                                Text("\(Int(self.userData.user?.points ?? 0))").font(.custom("AvenirNext-Bold", size: 26)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 15))
                            }
                            Spacer()
                        }
                    }.padding(EdgeInsets(top: 50, leading: 0, bottom: 15, trailing: 0))
                }
                
                Spacer()
                
                Group {
                    if (self.userData.user?.authType == 1) {
                        Button(action: {
                            self.userData.signoutCustom()
                        }) {
                            Text("Log out")
                                .font(.custom("AvenirNext-Medium", size: 20))
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color(red: 240/255, green: 176/255, blue: 175/255))
                                .foregroundColor(.white)
                                .border(Color(red: 240/255, green: 176/255, blue: 175/255), width: 1)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                        }.padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 15))
                    } else {
                        Login().frame(width: 300, height: 50).padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 15))
                    }
                }
            }
        }
    }
}
