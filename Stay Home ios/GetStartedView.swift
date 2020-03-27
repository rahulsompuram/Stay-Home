//
//  GetStartedView.swift
//  Stay Home ios
//
//  Created by Rahul Sompuram on 3/19/20.
//  Copyright © 2020 Stay Home. All rights reserved.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

func getDate()->String {
    let date = Date()
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let formattedDate = format.string(from: date)
    return(formattedDate)
}

struct GetStartedView: View {
    @State var username: String
    @State private var showingAlert = false
    @State var popupMessage = "blah"
    @State var showGameInfoView = false
    
    var body: some View {
        ZStack {
            if self.showGameInfoView {
                GameInfoView()
            } else {
                Color.init(red: 78/255, green: 89/255, blue: 140/255)
                .edgesIgnoringSafeArea(.all)
                
                VStack  {
                    Spacer()
                    
                    VStack {
                        Text("Enter a username").font(.custom("AvenirNext-Bold", size: 24)).foregroundColor(Color.white)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                        TextFieldWithLine(placeholder: "e.g. bob123", text: $username, isSecure: false).foregroundColor(Color.white).padding(25)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Button(action: {
                            // code that runs when "Done" button is pressed
                            if(self.username.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                                self.popupMessage = "Username can't be empty"
                                self.showingAlert = true
                            } else if (self.username.count > 12) {
                                self.popupMessage = "Username cannot be more than 12 characters"
                                self.showingAlert = true
                            } else {
                                var ref: DatabaseReference!
                                ref = Database.database().reference()
                                ref.child("UsernameList").observeSingleEvent(of: .value) { (snapshot) in
                                    if (snapshot.hasChild(self.username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))) {
                                        self.popupMessage = "Username already taken"
                                        self.showingAlert = true
                                    } else {
                                        ref.child("UsernameList").child(self.username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)).setValue(getDate())
                                        ref.child("Users").child(Auth.auth().currentUser!.uid).child("Username").setValue(self.username.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
                                        
                                        ref.child("TotalUsers").observeSingleEvent(of: .value) { (snapshot) in
                                            if let totalUsers = snapshot.value as? Int {
                                                ref.child("TotalUsers").setValue(totalUsers + 1)
                                            }
                                            
                                            self.showGameInfoView.toggle()
                                        }
                                    }
                                }
                            }
                        }) {
                            Text("Done")
                                .font(.custom("AvenirNext-Medium", size: 20))
                                .padding()
                                .frame(width: 300, height: 50, alignment: .center)
                                .background(Color(red: 240/255, green: 176/255, blue: 175/255))
                                .foregroundColor(.white)
                                .border(Color(red: 240/255, green: 176/255, blue: 175/255), width: 1)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                        }.padding()
                    }.padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 15))
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid username"), message: Text(self.popupMessage), dismissButton: .default(Text("Got it!")))
        }
    }
}

struct HorizontalLine: View {
   private var height: CGFloat
   private var color: Color?
    
   init(height: CGFloat = 1.0, color: Color){
        self.height = height
        self.color = color
    }
    
    var body: some View {
        Rectangle().frame(height: height, alignment: .bottom).foregroundColor(color)
    }
}

// FIX THIS TO ADD isSecure to change password placeholder to white color
struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit).autocapitalization(.none)
        }
    }
}

struct TextFieldWithLine: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private var text: Binding<String>
    private var placeholder: String
    private var isSecure: Bool
    private var lineHeight: CGFloat
    
    @State var passwordIcon: String = "eye.slash"
    @State var passwordHidden: Bool = true
    
    init(placeholder: String, text: Binding<String>, isSecure: Bool = false, lineHeight: CGFloat = CGFloat(0.5)) {
        self.placeholder = placeholder
        self.text = text
        self.isSecure = isSecure
        self.lineHeight = lineHeight
    }
    
    var body: some View {
        
        VStack {
            if(isSecure){
                HStack(){
                    if(self.passwordHidden){
                        SecureField(placeholder, text: text)
                    }else{
                        //TextField(placeholder, text: text).autocapitalization(.none)
                        CustomTextField(
                            placeholder: Text(placeholder).foregroundColor(Color(red: 223/255, green: 230/255, blue: 233/255)),
                            text: text
                        )
                    }
                    Button(action: {
                        self.passwordHidden.toggle()
                        if(self.passwordHidden){
                            self.passwordIcon = "eye.slash"
                        }else{
                            self.passwordIcon = "eye"
                        }
                    }){
                        Image(systemName: self.passwordIcon).padding(5).foregroundColor(Color.white)
                    }
                }
                HorizontalLine(height: lineHeight, color: Color.white)
            }else{
                //TextField(placeholder, text: text)
                CustomTextField(
                    placeholder: Text(placeholder).foregroundColor(Color(red: 223/255, green: 230/255, blue: 233/255)),
                    text: text
                )
                HorizontalLine(height: lineHeight, color: Color.white)
            }
        }.padding(.bottom, lineHeight)
    }
}


