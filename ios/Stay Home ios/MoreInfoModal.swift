//
//  MoreInfoModal.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/20/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI

struct MoreInfoModal: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.init(red: 78/255, green: 89/255, blue: 140/255)
            
            VStack {
                Spacer()
                
                VStack(alignment: .center) {
                    Text("Game information").font(.custom("AvenirNext-Bold", size: 24)).foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 50, trailing: 15))
                    //CHANGE THE BELOW TEXT
                    Text("Stay home and help flatten the curve for corona virus!\n\nFirst enable your location and set your home (don't worry you can change it once a day). Then, stay there to earn points and unlock sprites.\n\nKeep the app running in the background to accumulate points!").font(.custom("AvenirNext-Medium", size: 20)).foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                }
                
                Spacer()
                Spacer()
                
                VStack(alignment: .center) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
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

struct MoreInfoModal_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoModal()
    }
}
