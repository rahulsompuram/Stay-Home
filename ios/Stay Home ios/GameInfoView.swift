//
//  GameInfoView.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/19/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI

struct GameInfoView: View {
    
    @State var showTabHomeView = false
    
    var body: some View {
        ZStack {
            if self.showTabHomeView {
                TabHomeView()
            } else {
                Color.init(red: 78/255, green: 89/255, blue: 140/255)
                .edgesIgnoringSafeArea(.all)
                
                VStack  {
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("The game is simple").font(.custom("AvenirNext-Bold", size: 24)).foregroundColor(Color.white)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 50, trailing: 15))
                        Text("Stay home and help flatten the curve for corona virus!\n\nEarn points the longer you stay at home. Gain bonuses for hour-long and day-long streaks!\n\nAs you level up, you'll unlock cool new animations along with tips for staying safe.\n\nYou can set your home location a max of once per day. Make sure to enable location services and keep the app running in the background to keep getting points!\n\n(Hint: tap on your sprite and see what happens!)").font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.white)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                    }
                    
                    Spacer()
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Button(action: {
                            self.showTabHomeView.toggle()
                        }) {
                            Text("Start")
                                .font(.custom("AvenirNext-Medium", size: 20))
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color(red: 240/255, green: 176/255, blue: 175/255))
                                .foregroundColor(.white)
                                .border(Color(red: 240/255, green: 176/255, blue: 175/255), width: 1)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                        }.padding()
                    }.padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 15))
                }
            }
        }
    }
}

struct GameInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GameInfoView()
    }
}
