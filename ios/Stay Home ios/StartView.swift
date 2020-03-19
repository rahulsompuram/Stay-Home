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
                Login().frame(width: 300, height: 50).padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 15))
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
