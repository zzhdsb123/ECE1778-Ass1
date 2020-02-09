//
//  Session.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-16.
//  Copyright © 2020 Artorias. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Firebase

class Session: ObservableObject {
    @Published var user_id: String?
    @Published var user_image: UIImage?
    @Published var user_info = [String:String]()
    
    
    
    func loadData () {
        if self.user_image == nil {
            self.loadUserImage()
        }
        if self.user_info.isEmpty {
            self.loadUserInfo()
        }
    }
    
    func uploadImage(image: UIImage, completion: @escaping (_ err: String?) -> Void) {
        print(self.user_id!)
        let db = Firestore.firestore()
        db.collection("photos").document("general").getDocument { (document, error) in
            if error != nil {
                completion(error!.localizedDescription)
            }
            else {
                var total_photo = document!.data()!["total"] as! Int
                var all_photos = document!.data()!["photos"] as! [String]
                let photo_name = String(total_photo)
                total_photo += 1
                all_photos.append(photo_name)
                db.collection("photos").document("general").setData(["photos": all_photos, "total": total_photo], merge: true)
                
                db.collection("photos").document(photo_name).setData(["hash_tag": [], "comment": []], merge: true)
                db.collection("users").document(self.user_id!).getDocument { (document, error) in
                    if error != nil {
                        completion(error!.localizedDescription)
                    }
                    else {
                        var all_user_photos = document!.data()!["photos"] as! [String]
                        all_user_photos.append(photo_name)
                        db.collection("users").document(self.user_id!).setData(["photos": all_user_photos], merge: true)
                    }
                }
            }
        }
        
    }
    
    func loadUserInfo () {
        let db = Firestore.firestore().collection("users")
        db.document(self.user_id!).getDocument { (data, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                let bio = data?.data()?["bio"] as! String
                let username = data?.data()?["username"] as! String
                self.user_info["bio"] = bio
                self.user_info["username"] = username
            }
        }
    }
    
    func loadUserImage () {
        let storage_ref = Storage.storage().reference(withPath: "\(String(describing: self.user_id))/user_img_thumbnail.jpg")
        storage_ref.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.user_image = UIImage(data: data!)
            }
        }
    }
    
    func uploadUserImage(user_image: UIImage) {

        let upload_ref = Storage.storage().reference(withPath: "\(String(describing: self.user_id))/user_img.jpg")
        guard let image_data = user_image.jpegData(compressionQuality: 0.5) else {
            print("Oh no! Something went wrong!")
            return
        }
        let meta_data = StorageMetadata.init()
        meta_data.contentType = "image/jpeg"
        upload_ref.putData(image_data, metadata: meta_data) { (junk, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        
        let upload_ref_thumbnail = Storage.storage().reference(withPath: "\(String(describing: self.user_id))/user_img_thumbnail.jpg")
        guard let image_data_thumbnail = user_image.jpegData(compressionQuality: 0.25) else {
            print("Oh no! Something went wrong!")
            return
        }
        upload_ref_thumbnail.putData(image_data_thumbnail, metadata: meta_data) { (junk, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    
    }
    
    func signUp(email: String, password: String, confirm_password: String, username: String, bio: String, user_img: UIImage?, completion: @escaping (_ err: String?) -> Void) {
        if email == "" || password == "" || confirm_password == "" || username == "" || bio == "" {
            completion("Please fill in the required field.")
        }
        else if password != confirm_password {
            completion("Passwords do not match.")
        }
        else if user_img == nil {
            completion("Please choose a user photo.")
        }
        else {
            Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
                if err != nil {
                    completion(err!.localizedDescription)
                }
                else {
                    Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
                        if error != nil {
                            completion(error!.localizedDescription)
                        }
                        self.user_id = Auth.auth().currentUser!.uid
                        let db = Firestore.firestore().collection("users")
                        db.document(self.user_id!).setData(["username": username, "bio": bio, "email": email, "photos": [String]()])
                        self.uploadUserImage(user_image: user_img!)
                        
                    }
                }
                
            }
        }
    }
    
    func signIn (email: String, password: String, completion: @escaping (_ err: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            if error != nil {
                completion(error!.localizedDescription)
            }
            else {
                self.user_id = Auth.auth().currentUser!.uid
            }
        }
    }
}
