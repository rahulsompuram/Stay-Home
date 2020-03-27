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
                    //Image(sprite).resizable().frame(width: 25, height: 25)
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
    @State var username = " "
    let pointsPerLevel = 50000
    
    // for estimated rank of current user
    @State var estimatedRank: UInt = 0
    
    // for total user count
    @State var totalUsers = 0
    
    // for sprite image based off user points
    @State var userSprite = ""
    @State var spriteDict = [1: "pinkboi", 2: "soapboi", 3: "maskboi", 4: "gloveboi", 5: "sanitizer", 6: "Window", 7: "TP", 8: "Sir_Six_Feet", 9: "Juiceboi", 10: "lungs"]
    
    @EnvironmentObject var userData: UserDataViewModel
    
    
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
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("#\(estimatedRank)").font(.custom("AvenirNext-Bold", size: 18)).foregroundColor(Color.white)
                                Image(self.spriteDict[self.userData.user?.level ?? 1] ?? "").resizable().frame(width: 25, height: 25).shadow(radius: 5)
                                Text(self.userData.user?.username ?? "").font(.custom("AvenirNext-Medium", size: 18)).foregroundColor(Color.white)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\(Int(self.userData.user?.points ?? 0)) pts").font(.custom("AvenirNext-Medium", size: 18)).foregroundColor(Color.white)
                                }
                            }
                            Text("out of \(totalUsers) users").padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)).font(.custom("AvenirNext-Medium", size: 16)).foregroundColor(Color.white)
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
                    
                    guard let localUser = self.userData.user else { return }
                    
                    UITableView.appearance().separatorColor = .clear
                    UITableView.appearance().backgroundColor = UIColor(red: 78/255, green: 89/255, blue: 140/255, alpha: 1.0)
                    UITableViewCell.appearance().backgroundColor = UIColor(red: 78/255, green: 89/255, blue: 140/255, alpha: 1.0)
                    
                    ref = Database.database().reference()
                    
                    var localRows: [Row] = []
                    
                    var oneHundredthRankPoints: Double = 0
                    ref.child("Leaderboard").queryLimited(toFirst: 100).queryOrderedByValue().observeSingleEvent(of: .value) { (snapshot) in
                        
                        var rank = snapshot.childrenCount
                        
                        if let objects = snapshot.children.allObjects as? [DataSnapshot] {
                            
                            for user in objects {
                                
                                var username = user.key
                                
                                if (username == localUser.username) {
                                    self.estimatedRank = rank
                                }
                                
                                username = username.padding(toLength: 12, withPad: " ", startingAt: 0)
                                
                                if let points = user.value as? Double {
                                    localRows.append(Row(rank: rank, username: username, points: Int(points)))
                                    rank -= 1
                                    oneHundredthRankPoints = points
                                }
                            }
                        }
                        
                        localRows.reverse()
                        self.rows = localRows
                        
                        ref.child("TotalUsers").observeSingleEvent(of: .value) { (snapshot) in
                            if let totalUsers = snapshot.value as? Int {
                                self.totalUsers = totalUsers
                            }
                            
                            // if not inside the top 100, estimate
                            if (self.estimatedRank == 0) {
                                let percentile = 1 - localUser.points / oneHundredthRankPoints
                                self.estimatedRank = UInt(101 + Double(self.totalUsers - 100) * percentile)
                            }
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
