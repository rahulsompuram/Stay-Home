//
//  User.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//
import Foundation

struct User {
    var firstName: String
    var lastName: String
    var email: String
    var id: String?
    var isLoggedIn: Bool
    
    var lastRelocTimestamp: Double
    var lastTickTimestamp: Double
    var points: Double
    var streak: Double
    var unredeemedPoints: Double
    var username: String
    
    var pointsToNextLevel: Int
    var level: Int
    
    
    init(firstName: String = "",
         lastName: String = "",
         email: String = "",
         username: String = "",
         id: String? = nil,
         isLoggedIn: Bool = false) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.id = id
        self.isLoggedIn = isLoggedIn
        
        self.lastRelocTimestamp = 0
        self.lastTickTimestamp = 0
        self.points = 0
        self.streak = 0
        self.unredeemedPoints = 0
        
        self.pointsToNextLevel = 0
        self.level = 0
    }
         
}
