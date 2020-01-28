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
    @Published var images = [UIImage]()
    @Published var total: Int?
    
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
                self.total = (snapshot!.data()!["total"] as? Int)! - 1
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
    
    func getAllImg () {
        let db = Firestore.firestore().collection("users").document(self.userid!)
        db.getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                let dispatchQueue = DispatchQueue(label: "taskQueue")
                var images = snapshot!.data()!["photos"] as! [String]
                images.reverse()
                let dispatchSemaphore = DispatchSemaphore(value: 0)
                
                dispatchQueue.async {
                    for image in images {
                        let storage_ref = Storage.storage().reference(withPath: "\(String(describing: self.userid))/\(image)_thumbnail.jpg")
                        storage_ref.getData(maxSize: 5*1024*1024) { (data, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            else {
                                self.images.append(UIImage(data: data!)!)
                                dispatchSemaphore.signal()
                            }
                        }
                        dispatchSemaphore.wait()
                    }
                }
            }
        }
        //
    }
}
