//
//  SignUpView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-08.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct SignUpView: View {
    @State var email = "test@test.com"
    @State var password = "password"
    @State var confirm_password = "password"
    @State var username = "Artorias"
    @State var bio = "I am a banana"
    @State var error_msg = ""
    @State var err_show = false
    @State var picker = false
    @State var show_sheet = false
    @State var user_image: UIImage?
    @State var selected = false
    @State var camera = false
    @State var image = UIImage()
    @EnvironmentObject var session: Session
    
    func signUp () {
        self.session.signUp(email: self.email, password: self.password, confirm_password: self.confirm_password, username: self.username, bio: self.bio, user_img: self.user_image) { (error) in
            if error != nil {
                self.error_msg = error!
                self.err_show.toggle()
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ScrollView {
                Spacer()
                .frame(height: 40)
                
                HStack (alignment: .top) {
                    if self.user_image != nil {
                        Image(uiImage: self.user_image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100,
                             height: 100,
                             alignment: .topLeading)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    }
                    else {
                        Image(systemName: "person")
                        .resizable()
                        .scaledToFill()
                        .padding()
                        .frame(width: 100,
                            height: 100,
                            alignment: .topLeading)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    }
                    Spacer()
                        .frame(width: 40)
                    Text("Set Display Picture")
                        .foregroundColor(Color.white)
                    Spacer()
                        .frame(width: 60)
                }
                    
                Spacer()
                    .frame(height: 30)
                Group {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                    SecureField("Confirm Password", text: $confirm_password)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                    TextField("A short bio", text: $bio)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
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
                    
//                    Button(action: upLoad) {
//                    Text("Upload Test")
//                        .font(.subheadline)
//                        .frame(maxWidth: 100)
//                        .foregroundColor(Color.white)
//                        .padding()
//                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
//                        .padding()
//                        .shadow(radius: 10)
//                    }
                }
                Spacer()
            }
            .alert(isPresented: $err_show) {
                Alert(title: Text(self.error_msg))
            }
        }
        .sheet(isPresented: $picker, content: {
            ImageSelect(picker: self.$picker, image: self.$image, selected: self.$selected, camera: self.$camera, user_image: self.$user_image)
            
        })
        .actionSheet(isPresented: $show_sheet, content: {
            ActionSheet(title: Text("Take a picture or select one from the gallery"), buttons: [
                .default(Text("Take a picture"), action: {
                    self.selected = false
                    self.camera = true
                    self.picker.toggle()
                    
                }),
                .default(Text("Select an existing picture"), action: {
                    self.camera = false
                    self.selected = false
                    self.picker.toggle()
                }),
                .cancel()])
        })
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.show_sheet.toggle()
            }) {
                Image(systemName: "camera")
            }
            
        })
        .navigationBarTitle(Text("Register"), displayMode: .inline)
        .background(
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
