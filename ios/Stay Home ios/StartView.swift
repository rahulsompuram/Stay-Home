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

            VStack(alignment: .center, spacing: 50) {
                Text("Stay Home").font(.custom("AvenirNext-Bold", size: 28)).foregroundColor(.white)
                Login().frame(width: 300, height: 50).padding()
            }.padding()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
