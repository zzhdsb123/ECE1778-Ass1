//
//  SignUpView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-15.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import Firebase


struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var confirm_password = ""
    @State var username = ""
    @State var bio = ""
    @State var show = false
    @State var error_msg = ""
    
    func signUp () {
        if self.email == "" || self.password == "" || self.confirm_password == "" || self.username == "" || self.bio == "" {
            self.error_msg = "Please fill in the required field."
            self.show.toggle()
        }
        
        else if self.password != self.confirm_password {
            self.error_msg = "Passwords need to be the same."
            self.show.toggle()
        }
            
        else {
            Auth.auth().createUser(withEmail: self.email, password: self.password) {
                (res, err) in  if err != nil {
                    self.error_msg =  err!.localizedDescription
                    }
                else {
                    let db = Database.database().reference().child("users")
                    db.childByAutoId().setValue(["username": self.username, "bio": self.bio, "email": self.email])
                    self.error_msg = "Success"
                }
                self.show.toggle()
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                HStack (alignment: .top) {
                    Text("Register")
                    Spacer()
                    Image(systemName: "camera")
                }
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding()
                .background(Color(red: 158 / 255, green: 158 / 255, blue: 180 / 255))
                .foregroundColor(Color.white)
                
                Spacer()
                    .frame(height: 40)
                
                HStack (alignment: .top) {
                    Image(systemName: "person")
                        .resizable()
                        .padding()
                        .frame(width: 80,
                               height: 80,
                               alignment: .topLeading)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    Spacer()
                        .frame(width: 40)
                    Text("Set Display Picture")
                    Spacer()
                        .frame(width: 60)
                }
                    
                Spacer()
                    .frame(height: 30)
                Group {
                    TextField("Email", text: $email)
                        .padding()
                    SecureField("Password", text: $password)
                        .padding()
                    SecureField("Confirm Password", text: $confirm_password)
                        .padding()
                    TextField("Username", text: $username)
                        .padding()
                    TextField("A short bio", text: $bio)
                        .padding()
                }
                HStack {
                    Spacer()
                    Button(action: signUp) {
                    Text("SIGN UP")
                        .font(.subheadline)
                        .frame(maxWidth: 100)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                    }
                }
                Spacer()
            }
            .alert(isPresented: $show) {
                Alert(title: Text(self.error_msg))
            }
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
