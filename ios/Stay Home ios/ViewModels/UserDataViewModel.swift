//
//  UserDataViewModel.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import Combine
import Firebase
import FBSDKLoginKit
import MapKit

final class UserDataViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var errorMessage = ""
    
    func reset(){
        self.user = User()
    }
    
    func trackAuthState() {
        let handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.user = User(email: user.email!)
            } else {
                self.user = nil
            }
        })
    }
    
    func signIn() {
        if AccessToken.current != nil {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
            Auth.auth().signIn(with: credential) { (res, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                
                print("Success - sign in")
            }
        }
    }
}
