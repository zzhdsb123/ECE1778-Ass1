//
//  Auth.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-16.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct AuthView: View {
    @EnvironmentObject var session: Session
    @State var error_msg = ""
    @State var picker = false
    @State var image = UIImage()
    @State var selected = false
    @State var show_sheet = false
    @State var camera = false
    @State var show = false
    @State var post_preview = false
    
    func uploadImage (name: String) {
        
        // original image
        let upload_ref = Storage.storage().reference(withPath: "\(String(describing: self.session.userid))/\(name).jpg")
        guard let image_data = self.image.jpegData(compressionQuality: 0.75) else {
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

        }

        // thumbnail
        let upload_ref_thumbnail = Storage.storage().reference(withPath: "\(String(describing: self.session.userid))/\(name)_thumbnail.jpg")
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
                self.upDate()
            }

        }
    }
    
    func upload () {
        
        let db = Firestore.firestore().collection("users").document(self.session.userid!)
        db.getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            let total = (snapshot!.data()!["total"] as! Int)
            var photos = (snapshot!.data()!["photos"] as! [String])
            db.setData(["total": total+1], merge: true)
//            print(total)
            let name = String(total)
            photos.append(name)
            db.setData(["photos": photos], merge: true)
            self.uploadImage(name: name)
            self.selected.toggle()
            self.error_msg = "Upload success!"
            self.show.toggle()
        }

        
    }
    
    func signOut () {
        self.session.signOut()
    }
    
    func testLogin () {
        if Auth.auth().currentUser != nil {
            print("Yes!")
        }
        else {
            print("No!")
        }
    }
    
    func upDate () {
        self.session.count = 0
        self.session.images = [[UIImage]]()
        self.session.images_tracker = [[String]]()
        let db = Firestore.firestore().collection("users")
        db.document(self.session.userid!).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.session.total = (snapshot!.data()!["total"] as? Int)! - 1
                self.session.getAllImg()
//                print(self.session.images)
//                print(self.session.images.count)
//                print(self.session.count)
//                print(self.session.total!)
            }
        }
        
    }
    
    var body: some View {
        GeometryReader {geo in
            
            NavigationView {
                
                ScrollView (.vertical) {
                    Spacer()
                        .frame(height: 30)
                    HStack {
                        if self.session.user_image != nil {
                            Image(uiImage: self.session.user_image!)
                                .resizable()
                                .frame(width: 120,
                                       height: 120,
                                       alignment: .topLeading)
                                .background(Color.gray)
                                .foregroundColor(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding()
                        }
                        else {
                            Image(systemName: "person")
                                .resizable()
                                .padding()
                                .frame(width: 120,
                                       height: 120,
                                       alignment: .topLeading)
                                .background(Color.gray)
                                .foregroundColor(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding()
                        }
                        Spacer()
                            .frame(width: 30)
                        VStack (alignment: .leading, spacing: 0) {
                            Text(String(self.session.username ?? "Loading username..."))
                            .foregroundColor(Color.white)
                            .font(.title)
                            Text(String(self.session.bio ?? "Loading bio..."))
                            .foregroundColor(Color.white)
                        }
                            
                            
                        }
                        .frame(maxWidth: .infinity)
                    if self.selected {
                        Image(uiImage: self.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding()
                        HStack {
                            Button(action: {
                                self.selected = false
                            }, label: {
                                Text("DISCARD")
                                .font(.subheadline)
                                .frame(maxWidth: 120)
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                                .padding()
                                .shadow(radius: 10)
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                self.upload()
                            }, label: {
                                Text("POST")
                                .font(.subheadline)
                                .frame(maxWidth: 120)
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                                .padding()
                                .shadow(radius: 10)
                            })
                        }
                        
                    }
                    
                    UserPhotoView(width: geo.size.width/3)
                    
                }
                .alert(isPresented: self.$show) {
                    Alert(title: Text(self.error_msg))
                }
                .frame(maxWidth: .infinity)
                .navigationBarItems(trailing: HStack {
                    Button(action: {
                        self.show_sheet.toggle()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color.black)
                    }
                    
                })
                .navigationBarTitle(Text("Profile").font(.subheadline), displayMode: .inline)
                .background(
                Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                )
                .actionSheet(isPresented: self.$show_sheet) {
                ActionSheet(title: Text("Sign out or upload a photo"), buttons: [
                .default(Text("Take a photo"), action: {
                    self.camera.toggle()
                    self.picker.toggle()
                }),
                .default(Text("Select from the gallery"), action: {
                    self.picker.toggle()
                }),
                .default(Text("Sign out"), action: {
                    self.signOut()
                }),
                .cancel()])
                
            }
                .sheet(isPresented: self.$picker, content: {
                    ImagePickerView(isPresented: self.$picker, selectedImage: self.$image, selected: self.$selected, camera: self.$camera)
                })
            }
            .frame(maxWidth: .infinity)
                    
        }
        
    }
    
}

struct Auth_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(Session())
    }
}

