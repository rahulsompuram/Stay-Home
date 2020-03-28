//
//  SignUpView.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/25/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var userData: UserDataViewModel
    
    @State var goBackView: Bool = false
    
    @State private var showingAlert = false
    @State var popupMessage = "blah"
    
    func signUp() {
        userData.signUpCustom(email: email, password: password, authType: 1) { (res, error) in
            if let error = error {
                print(error.localizedDescription)
                self.popupMessage = error.localizedDescription
                self.showingAlert.toggle()
                return
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        Group {
            if (self.goBackView) {
                StartView()
            } else {
                ZStack {
                    Color.init(red: 78/255, green: 89/255, blue: 140/255)
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Button(action: {
                                self.goBackView.toggle()
                                }){
                                    Image(systemName: "arrow.left")
                                        .resizable()
                                        .font(Font.title.weight(.bold))
                                        .foregroundColor(Color(red: 240/255, green: 176/255, blue: 175/255))
                                        .frame(width: 20, height: 20).padding()
                            }
                            Spacer()
                        }
                        Spacer()
                        
                        VStack {
                            Text("Create an account").font(.custom("AvenirNext-Bold", size: 24)).foregroundColor(Color.white)
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                        }
                        
                        
                        TextFieldWithLine(placeholder: "Email", text: $email, isSecure:  false).foregroundColor(Color.white).padding(25)
                        TextFieldWithLine(placeholder: "Password", text: $password, isSecure: true).foregroundColor(Color.white).padding(25)
                        
                        Button(action: signUp) {
                            Text("Sign up")
                            .font(.custom("AvenirNext-Medium", size: 20))
                            .padding()
                            .frame(width: 300, height: 50, alignment: .center)
                            .background(Color(red: 240/255, green: 176/255, blue: 175/255))
                            .foregroundColor(.white)
                            .border(Color(red: 240/255, green: 176/255, blue: 175/255), width: 1)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                        }.padding(EdgeInsets(top: 5, leading: 15, bottom: 30, trailing: 15))
                        
                        Spacer()
                        Spacer()
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Error"), message: Text(self.popupMessage), dismissButton: .default(Text("Got it!")))
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
