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
    @Published var auto_hashtag = true
    @Published var user_image_list = [[UIImage?]]()
    @Published var user_image_tracker = [[String]]()
    
    func loadAllUserImages () {
        let db = Firestore.firestore().collection("users").document(self.user_id!)
        db.getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                var user_image_name_list = snapshot!.data()!["photos"] as! [String]
                user_image_name_list.reverse()
                self.user_image_tracker = self.rearrangeImageatLogin(images: user_image_name_list, total: user_image_name_list.count)
                for row in (0..<self.user_image_tracker.count) {
                    for col in (0..<self.user_image_tracker[row].count) {
                        let current_image = self.user_image_tracker[row][col]
                        let storage_ref = Storage.storage().reference(withPath: "photos/\(current_image)_thumbnail.jpg")
                        storage_ref.getData(maxSize: 5*1024*1024) { (data, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            else {
                                self.user_image_list[row][col] = UIImage(data: data!)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func rearrangeImageatLogin (images: [String], total: Int) -> [[String]] {
        var arranged_image_name = [[String]]()
        var arranged_images = [[UIImage?]]()
        var temp = [String]()
        var temp_image = [UIImage?]()
        var count = 0
        for image in images {
            count += 1
            if temp.count < 3{
                temp.append(image)
                temp_image.append(nil)
            }
            else {
                arranged_image_name.append(temp)
                arranged_images.append(temp_image)
                temp = [String]()
                temp_image = [UIImage?]()
                temp.append(image)
                temp_image.append(nil)
            }
        }
        if count == total && temp.count > 0 {
            arranged_image_name.append(temp)
            arranged_images.append(temp_image)
        }
        self.user_image_list = arranged_images
        return arranged_image_name
    }
    
    func loadData () {
        if self.user_image == nil {
            self.loadUserImage()
        }
        if self.user_info.isEmpty {
            self.loadUserInfo()
        }
        if self.user_image_list.count == 0{
            self.loadAllUserImages()
        }
    }
    
    func uploadImage(image: UIImage, hash: String, caption: String, completion: @escaping (_ err: String?) -> Void) {
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
                
                db.collection("photos").document(photo_name).setData(["hash_tag": hash, "comment": [], "caption": caption, "uploader": self.user_id!], merge: true)
                db.collection("users").document(self.user_id!).getDocument { (document, error) in
                    if error != nil {
                        completion(error!.localizedDescription)
                    }
                    else {
                        var all_user_photos = document!.data()!["photos"] as! [String]
                        all_user_photos.append(photo_name)
                        db.collection("users").document(self.user_id!).setData(["photos": all_user_photos], merge: true)
                        self.uploadImageHelper(image: image, name: photo_name) { (error) in
                            if error != nil {
                                print(error!)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func uploadImageHelper (image: UIImage, name: String, completion: @escaping (_ err: String?) -> Void) {
        // original image
        let upload_ref = Storage.storage().reference(withPath: "photos/\(name).jpg")
        guard let image_data = image.jpegData(compressionQuality: 0.75) else {
            completion("Oh no! Something went wrong!")
            return
        }
        let meta_data = StorageMetadata.init()
        meta_data.contentType = "image/jpeg"
        upload_ref.putData(image_data, metadata: meta_data) { (junk, error) in
            if error != nil {
                completion(error!.localizedDescription)
                return
            }

        }

        // thumbnail
        let upload_ref_thumbnail = Storage.storage().reference(withPath: "photos/\(name)_thumbnail.jpg")
        guard let image_data_thumbnail = image.jpegData(compressionQuality: 0.25) else {
            completion("Oh no! Something went wrong!")
            return
        }
        upload_ref_thumbnail.putData(image_data_thumbnail, metadata: meta_data) { (junk, error) in
            if error != nil {
                completion(error!.localizedDescription)
                return
            }

        }
    }
    
    func labelImage (image: UIImage, completion: @escaping (_ hashtag: String?) -> Void) {
        let label_image = VisionImage(image: image)
        let options = VisionOnDeviceImageLabelerOptions()
        options.confidenceThreshold = 0.7
        let labeler = Vision.vision().onDeviceImageLabeler(options: options)
        labeler.process(label_image) { (labels, error) in
            guard error == nil, let labels = labels else { return }
            var hash = ""
            for label in labels {
                hash = hash + "#" + label.text + " "
                print(label.text)
            }
            completion(hash)
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
