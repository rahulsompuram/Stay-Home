//
//  SessionStore.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/18/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import Combine
import FBSDKLoginKit

class SessionStore : BindableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var isLoggedIn = false { didSet { self.didChange.send(self) }}
    var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    init(session: User? = nil) {
        self.session = session
    }
    
    func listen () {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("Got user \(user)")
                self.isLoggedIn = true
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email,
                    photoURL: user.photoURL
                )
            } else {
                self.isLoggedIn = false
                self.session = nil
            }
        }
    }
    
    func signInWithGoogle () {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
//            self.isLoggedIn = false
//            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    // stop listening for auth changes
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
    
    func signIn(handler: @escaping AuthDataResultCallback) {
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

