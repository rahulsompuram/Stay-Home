//
//  HomeView.swift
//  Stay Home ios
//
//  Created by Vishnu Ravi on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI

struct TabHomeView: View {
    @State var selection = 2  // starts on Home tab
    
    var body: some View {
        
        TabView(selection: $selection) {
            Leaderboard()
                .tabItem {
                    Image(systemName: "rosette").font(.system(size: 25))
            }
            .tag(1)
            
            Home()
                .tabItem {
                    Image(systemName: "house").font(.system(size: 25))
            }
            .tag(2)
            
            Profile()
                .tabItem {
                    Image(systemName: "person.crop.circle").font(.system(size: 25))
            }
            .tag(3)
        }
        //.edgesIgnoringSafeArea(.top).accentColor(Color(red: 78/255, green: 89/255, blue: 140/255))
    }
}

struct TabHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabHomeView()
    }
}
