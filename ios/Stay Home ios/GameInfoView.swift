//
//  GameInfoView.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/19/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI

struct GameInfoView: View {
    var body: some View {
        ZStack {
            Color.init(red: 78/255, green: 89/255, blue: 140/255)
            .edgesIgnoringSafeArea(.all)
            
            VStack  {
                Spacer()
                
                VStack(alignment: .center) {
                    Text("The game is simple").font(.custom("AvenirNext-Bold", size: 24)).foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 50, trailing: 15))
                    Text("Stay home and help flatten the curve for corona virus!\n\nTurn on your location and stay home to earn points and unlock sprites.").font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                }
                
                Spacer()
                Spacer()
                
                VStack(alignment: .center) {
                    Button(action: {
                        
                    }) {
                        Text("Done")
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

struct GameInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GameInfoView()
    }
}
