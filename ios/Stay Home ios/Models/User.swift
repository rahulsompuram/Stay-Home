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
    var username: String
    var email: String
    var id: String?
    var isLoggedIn: Bool
    
    
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
    }
         
}
