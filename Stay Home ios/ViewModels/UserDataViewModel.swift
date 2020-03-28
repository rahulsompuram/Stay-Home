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
    @Published var isNewUser: Bool?
    @Published var errorMessage = ""
    
    var authType: Int = 0
    
    // begin custom sign up / login
    var handle: AuthStateDidChangeListenerHandle?
    
    func signUpCustom(email: String, password: String, authType: Int, handler: @escaping AuthDataResultCallback) {
        self.authType = authType
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signInCustom(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signoutCustom() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error signing out")
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
    // end custom sign up / login
    
    // reset password
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ message: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
    
    func reset(){
        self.user = User()
    }
    
    let pointsPerLevel: Double = 50000
    
    func trackAuthState() {
        _ = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                
                var ref: DatabaseReference!
                let userID = Auth.auth().currentUser!.uid
                ref = Database.database().reference().child("Users").child(userID)
                
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if(!snapshot.exists()) {
                        print("New user!")
                        self.isNewUser = true
                        ref.child("Points").setValue(0)
                        ref.child("HomeLat").setValue(0)
                        ref.child("HomeLong").setValue(0)
                        ref.child("Country").setValue("Unknown")
                        ref.child("LastRelocTimestamp").setValue(0)
                        ref.child("LastTickTimestamp").setValue(0)
                        ref.child("Streak").setValue(0)
                        ref.child("UnredeemedPoints").setValue(0)
                        // AuthType: facebook = 0, custom = 1
                        ref.child("AuthType").setValue(self.authType)
                    } else {
                        print("Existing user!")
                        ref.observe(.value) { (snapshot) in
                            if let authType = snapshot.childSnapshot(forPath: "AuthType").value as? Int {
                                self.user?.authType = authType
                            }
                            
                            if let lastRelocTimestamp = snapshot.childSnapshot(forPath: "lastRelocTimestamp").value as? Double {
                                self.user?.lastRelocTimestamp = lastRelocTimestamp
                            }
                            if let lastTickTimestamp = snapshot.childSnapshot(forPath: "lastTickTimestamp").value as? Double {
                                self.user?.lastTickTimestamp = lastTickTimestamp
                            }
                            if let points = snapshot.childSnapshot(forPath: "Points").value as? Double {
                                self.user?.points = points
                                                                
                                var level = Int(points / self.pointsPerLevel) + 1
                                if (level > 10) {
                                    level = 10
                                }
                                self.user?.level = level
                                
                                if (level == 10) {
                                    self.user?.pointsToNextLevel = 999999999
                                } else {
                                    self.user?.pointsToNextLevel = Int(self.pointsPerLevel) - (Int(points) % Int(self.pointsPerLevel))
                                }
                            }
                            if let streak = snapshot.childSnapshot(forPath: "Streak").value as? Double {
                                self.user?.streak = streak
                            }
                            if let unredeemedPoints = snapshot.childSnapshot(forPath: "unredeemedPoints").value as? Double {
                                self.user?.unredeemedPoints = unredeemedPoints
                            }
                            if let username = snapshot.childSnapshot(forPath: "Username").value as? String {
                                self.user?.username = username
                            }
                            
                        }
                        
                        
                        self.isNewUser = false
                    }
                }
                
                self.user = User(email: user.email!)
                
            } else {
                self.user = nil
            }
            
        })
    }
    
    // Facebook sign in
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
