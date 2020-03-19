//
//  Leaderboard.swift
//  Stay Home ios
//
//  Created by Vishnu Ravi on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

var ref: DatabaseReference!

struct Row: View {
    var rank: UInt
    var username: String
    var points: IntegerLiteralType
    var id: UUID = UUID()
    
    var body: some View {
        Text("#\(rank) || \(username) || \(points)pts")
//        HStack {
//            Text("#\(rank)")
//            Text("\(username)")
//            Text("\(points)pts").align
//        }
    }
}

struct Leaderboard: View {
    
    @State var rows: [Row] = []
        
    var body: some View {
        List(self.rows, id: \.id) { item in
            Row(rank: item.rank, username: item.username, points: item.points)
        }.onAppear() {
            
            UITableView.appearance().separatorColor = .clear
            
            self.rows = []
            ref = Database.database().reference()
            
            // make this max out at ~100 results
            ref.child("Leaderboard").queryOrderedByValue().observeSingleEvent(of: .value) { (snapshot) in
                
                var rank = snapshot.childrenCount
                
                for rows in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    var username = rows.key
                    username = username.padding(toLength: 12, withPad: " ", startingAt: 0)
                    let points = rows.value as! IntegerLiteralType
    
                self.rows.append(Row(rank: rank, username: username, points: points))
                    
                    rank -= 1
                }
                
                self.rows.reverse()
            }
            
        }
    }
}

struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard()
    }
}
