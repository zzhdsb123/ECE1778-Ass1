//
//  Session.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-16.
//  Copyright © 2020 Artorias. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class Session: ObservableObject {
    @Published var email: String?
    @Published var isLoggedIn: Bool?
    @Published var bio: String?
    @Published var username: String?
    @Published var userid: String?
    @Published var user_image: UIImage?
    @Published var images = [[UIImage?]]()
    @Published var images_tracker = [[String]]()
    @Published var total: Int?
    @Published var count = 0
    @Published var full_image: UIImage?
    @Published var current_image: String?
    
    func signIn (email: String) {
        self.email = email
        let key = userid!
        let db = Firestore.firestore().collection("users")
        db.document(key).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.bio = snapshot?.data()?["bio"] as? String ?? ""
                self.username = snapshot?.data()?["username"] as? String ?? ""
                self.getUserImg()
                self.getAllImg()
            }
        }
        self.isLoggedIn = true
    }
    
    func signOut () {
        do {
            try Auth.auth().signOut()
            self.email = nil
            self.isLoggedIn = nil
            self.user_image = nil
            self.images = [[UIImage]]()
            self.total = 0
            self.count = 0
            self.current_image = nil
            self.images_tracker = [[String]]()
            self.full_image = nil
            }
            catch let err {
                print(err)
            }
        
        
    }
    
    func getUserImg () {
        let user_id = self.userid
        let storage_ref = Storage.storage().reference(withPath: "\(String(describing: user_id))/user_img_thumbnail.jpg")
        storage_ref.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.user_image = UIImage(data: data!)
            }
        }
    }
    
    func rearrangeImage (images: [String]) -> [[String]] {
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
        if count == self.total! && temp.count > 0 {
            arranged_image_name.append(temp)
            arranged_images.append(temp_image)
        }
        self.images = arranged_images
        self.images_tracker = arranged_image_name
        return arranged_image_name
    }
    
    func getAllImg () {
        let db = Firestore.firestore().collection("users").document(self.userid!)
        db.getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
//                let dispatchQueue = DispatchQueue(label: "taskQueue")
                var images = snapshot!.data()!["photos"] as! [String]
                self.total = images.count
                images.reverse()
                let total_images_name = self.rearrangeImage(images: images)
                print(total_images_name)
                for row in (0..<total_images_name.count) {
                    for col in (0..<total_images_name[row].count) {
                        let current_image = total_images_name[row][col]
                        let storage_ref = Storage.storage().reference(withPath: "\(String(describing: self.userid))/\(current_image)_thumbnail.jpg")
                        storage_ref.getData(maxSize: 5*1024*1024) { (data, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            else {
                                self.images[row][col] = UIImage(data: data!)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
}
