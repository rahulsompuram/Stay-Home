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
                    Image(systemName: "rosette")
            }
            .tag(1)
            
            Home()
                .tabItem {
                    Image(systemName: "house")
            }
            .tag(2)
            
            Profile()
                .tabItem {
                    Image(systemName: "person.fill")
            }
            .tag(3)
        }
    }
}

struct TabHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabHomeView()
    }
}
