//
//  SignUpView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-15.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var confirm_password = ""
    @State var username = ""
    @State var bio = ""
    @State var show = false
    @State var error_msg = ""
    @State var picker = false
    @State var image = UIImage()
    @State var selected = false
    @State var show_sheet = false
    @State var camera = false
    @EnvironmentObject var session: Session
    
    
    func signUp () {
        if self.email == "" || self.password == "" || self.confirm_password == "" || self.username == "" || self.bio == "" {
            self.error_msg = "Please fill in the required field."
            self.show.toggle()
        }
        
        else if self.password != self.confirm_password {
            self.error_msg = "Passwords need to be the same."
            self.show.toggle()
        }
            
        else if self.selected == false {
            self.error_msg = "Please select an image!"
            self.show.toggle()
        }
            
        else {
            Auth.auth().createUser(withEmail: self.email, password: self.password) {
                (res, err) in  if err != nil {
                    self.error_msg =  err!.localizedDescription
                    self.show.toggle()
                    }
                else {
                    
                    Auth.auth().signIn(withEmail: self.email, password: self.password) { (res, err) in
                        if err != nil {
                            self.error_msg = err!.localizedDescription
                            self.show.toggle()
                        }
                    }
                    if Auth.auth().currentUser != nil {
                        self.session.userid = Auth.auth().currentUser!.uid
                        let db = Firestore.firestore().collection("users")
                        db.document(self.session.userid!).setData(["username": self.username, "bio": self.bio, "email": self.email, "photos": [String](), "total": 1])
                        self.upLoad()
                        self.session.user_image = self.image
                        self.session.signIn(email: self.email)
                        
                    }
                    else {
                        self.error_msg = "Oh no, something went wrong!"
                        self.show.toggle()
                    }
                }
            
            }
        }
    }
    
    func upLoad () {
//        let random_id = UUID.init().uuidString
        let upload_ref = Storage.storage().reference(withPath: "\(String(describing: self.session.userid))/user_img.jpg")
        guard let image_data = self.image.jpegData(compressionQuality: 1.0) else {
            self.error_msg = "Oh no! Something went wrong!"
            self.show.toggle()
            return
        }
        let meta_data = StorageMetadata.init()
        meta_data.contentType = "image/jpeg"
        upload_ref.putData(image_data, metadata: meta_data) { (junk, error) in
            if error != nil {
                self.error_msg = error!.localizedDescription
                self.show.toggle()
            }
            else {
                self.error_msg = "Success!"
                self.show.toggle()
            }
            
        }
        
        
        let upload_ref_thumbnail = Storage.storage().reference(withPath: "\(String(describing: self.session.userid))/user_img_thumbnail.jpg")
        guard let image_data_thumbnail = self.image.jpegData(compressionQuality: 0.25) else {
            self.error_msg = "Oh no! Something went wrong!"
            self.show.toggle()
            return
        }
        upload_ref_thumbnail.putData(image_data_thumbnail, metadata: meta_data) { (junk, error) in
            if error != nil {
                self.error_msg = error!.localizedDescription
                self.show.toggle()
            }
            else {
                self.error_msg = "Success!"
                self.show.toggle()
            }
            
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ScrollView {
                HStack (alignment: .top) {
                    Text("Register")
                    Spacer()
                    Button(action: {
                        self.show_sheet.toggle()
                        
//                        self.camera.toggle()
//                        self.picker.toggle()
                        
                    }) {
                        Image(systemName: "camera")
                    }
                    
                }
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding()
                .background(Color(red: 158 / 255, green: 158 / 255, blue: 180 / 255))
                .foregroundColor(Color.white)
                
                Spacer()
                    .frame(height: 40)
                
                HStack (alignment: .top) {
                    if self.selected != false {
                        Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
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
                    
                    Button(action: upLoad) {
                    Text("Upload Test")
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
        .sheet(isPresented: $picker, content: {
            ImagePickerView(isPresented: self.$picker, selectedImage: self.$image, selected: self.$selected, camera: self.$camera)
        })
        .actionSheet(isPresented: $show_sheet, content: {
            ActionSheet(title: Text("Take a picture or select one from the gallery"), buttons: [
                .default(Text("Take a picture"), action: {
                    self.camera.toggle()
                    self.picker.toggle()
                }),
                .default(Text("Select an existing picture"), action: {
                    self.picker.toggle()
                }),
                .cancel()])
        })
        .background(
            Image("background")
                .resizable()
                .frame(width:1400, height: 925)
        )
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
