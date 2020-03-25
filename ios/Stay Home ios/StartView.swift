//
//  StartView.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI

struct StartView: View {    
    var body: some View {
        ZStack {
            Color.init(red: 78/255, green: 89/255, blue: 140/255)
            .edgesIgnoringSafeArea(.all)

            VStack {
                VStack {
                    Spacer()
                    Image("pinkboi").resizable().frame(width: 150, height: 150, alignment: .center).shadow(radius: 10)
                    Text("Stay Home").font(.custom("AvenirNext-Bold", size: 28)).foregroundColor(.white)
                    Spacer()
                }.padding(EdgeInsets(top: 50, leading: 0, bottom: 15, trailing: 0))
                
                Spacer()
                VStack(alignment: .center) {
                    Login().frame(width: 300, height: 50).padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                    Text("or").font(.custom("AvenirNext-Bold", size: 18)).foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    
                    NavigationLink(destination: SignInView()) {
                        Button(action: {

                        }) {
                            Text("Log in")
                                .font(.custom("AvenirNext-Medium", size: 18))
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color(red: 240/255, green: 176/255, blue: 175/255))
                                .foregroundColor(.white)
                                .border(Color(red: 240/255, green: 176/255, blue: 175/255), width: 1)
                                .cornerRadius(25)
                        }.padding()
                    }
                    
                    NavigationLink(destination: SignUpView()) {
                        HStack {
                            Text("I'm a new user.")
                            .font(.custom("AvenirNext-Medium", size: 18))
                            .foregroundColor(.white)
                            Text("Create an account")
                            .font(.custom("AvenirNext-Bold", size: 18))
                            .foregroundColor(Color(red: 240/255, green: 176/255, blue: 175/255))
                        }
                    }.padding(EdgeInsets(top: 5, leading: 15, bottom: 30, trailing: 15))
                }
            }
        }    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
