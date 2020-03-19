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
    @State var goToNextScreen = false
    
    var body: some View {
        ZStack {
            Color.init(red: 78/255, green: 89/255, blue: 140/255)
            .edgesIgnoringSafeArea(.all)
            
            VStack  {
                Spacer()
                
                VStack {
                    Text("Enter a username").font(.custom("AvenirNext-Bold", size: 24)).foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                    TextFieldWithLine(placeholder: "", text: $username).foregroundColor(Color.white).padding(25)
                }
                
                Spacer()
                Spacer()
                
                VStack(alignment: .center) {
                    Button(action: {
                        // code that runs when "Done" button is pressed
                        
                        if (self.username.count > 12) {
                            self.popupMessage = "Username cannot be more than 12 characters"
                            self.showingAlert = true
                        } else {
                            var ref: DatabaseReference!
                            ref = Database.database().reference()
                            ref.child("UsernameList").observeSingleEvent(of: .value) { (snapshot) in
                                if (snapshot.hasChild(self.username.lowercased())) {
                                    self.popupMessage = "Username already taken"
                                    self.showingAlert = true
                                } else {
                                    ref.child("UsernameList").child(self.username.lowercased()).setValue(getDate())
                                    ref.child("Users").child(Auth.auth().currentUser!.uid).child("Username").setValue(self.username.lowercased())
                                    self.goToNextScreen = true
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

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct TextFieldWithLine: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private var text: Binding<String>
    private var placeholder: String
    private var lineHeight: CGFloat
    
    init(placeholder: String, text: Binding<String>, lineHeight: CGFloat = CGFloat(0.5)) {
        self.placeholder = placeholder
        self.text = text
        self.lineHeight = lineHeight
    }
    
    var body: some View {
        
        VStack {
            CustomTextField(
                placeholder: Text("e.g. bob123").foregroundColor(Color(red: 223/255, green: 230/255, blue: 233/255)),
                text: text
            )
            HorizontalLine(height: lineHeight, color: Color.white)
        }.padding(.bottom, lineHeight)
    }
}


