//
//  Leaderboard.swift
//  Stay Home ios
//
//  Created by Vishnu Ravi on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

var ref: DatabaseReference!

struct Row: View {
    var rank: UInt
    var username: String
    var points: IntegerLiteralType
    var id: UUID = UUID()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
            }
            HStack(alignment: .top) {
                Text("#\(rank)").padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)).font(.custom("AvenirNext-Bold", size: 18)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                
                HStack {
                    Image("pinkboi").resizable().frame(width: 25, height: 25)
                    Text("\(username)").padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)).font(.custom("AvenirNext-Medium", size: 18)).foregroundColor(Color.white)
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(points) pts").padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 5)).font(.custom("AvenirNext-Medium", size: 18)).foregroundColor(Color.white)
                }
            }
            HStack {
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
        .background(Color(red: 89/255, green: 123/255, blue: 235/255))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct Leaderboard: View {
    
    @State var rows: [Row] = []
    
    @State var points = 0
    @State var rank = 0
    @State var username = " "
        
    var body: some View {
        
        ZStack {
            
            Color.init(red: 78/255, green: 89/255, blue: 140/255)
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Leaderboard")
                        .font(.custom("AvenirNext-Bold", size: 30)).foregroundColor(Color.white).padding()
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                    }
                    HStack(alignment: .top) {
                        Text(/*"#\(self.rank)"*/"").padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)).font(.custom("AvenirNext-Bold", size: 18)).foregroundColor(Color.white).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                        
                        HStack {
                            Image("pinkboi").resizable().frame(width: 25, height: 25).shadow(radius: 5)
                            Text(self.username).padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)).font(.custom("AvenirNext-Medium", size: 18)).foregroundColor(Color.white)
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(self.points) pts").padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 5)).font(.custom("AvenirNext-Medium", size: 18)).foregroundColor(Color.white)
                        }
                    }
                    HStack {
                        Spacer()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .background(Color(red: 240/255, green: 176/255, blue: 175/255))
                
                List(self.rows, id: \.id) { item in
                        Row(rank: item.rank, username: item.username, points: item.points)
                    
                    }.onAppear() {
                        
                        UITableView.appearance().separatorColor = .clear
                        UITableView.appearance().backgroundColor = UIColor(red: 78/255, green: 89/255, blue: 140/255, alpha: 1.0)
                        UITableViewCell.appearance().backgroundColor = UIColor(red: 78/255, green: 89/255, blue: 140/255, alpha: 1.0)
                        
                        ref = Database.database().reference()
                        
                        var localRows: [Row] = []
                        
                        // make this max out at ~100 results
                        ref.child("Leaderboard").queryLimited(toFirst: 100).queryOrderedByValue().observeSingleEvent(of: .value) { (snapshot) in
                            
                            var rank = snapshot.childrenCount
                            
                            for user in snapshot.children.allObjects as! [DataSnapshot] {
                                
                                var username = user.key
                                username = username.padding(toLength: 12, withPad: " ", startingAt: 0)
                                let points = user.value as! IntegerLiteralType
                
                            localRows.append(Row(rank: rank, username: username, points: points))
                                
                                rank -= 1
                            }
                            
                            localRows.reverse()
                            self.rows = localRows
                        }
                        
                        ref.child("Users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
                            if let points = snapshot.childSnapshot(forPath: "Points").value as? Int {
                                self.points = points
                            }
                            
                            if let username = snapshot.childSnapshot(forPath: "Username").value as? String {
                                self.username = username
                            }
                        }
                    }
            }
        }
    }
}

struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard()
    }
}
