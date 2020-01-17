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

class Session: ObservableObject {
    @Published var email: String?
    @Published var isLoggedIn: Bool?
    @Published var bio: String?
    @Published var username: String?
    
    func signIn (email: String) {
        self.email = email
        let key = email
        let db = Firestore.firestore().collection("users")
        db.document(key).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.bio = snapshot?.data()?["bio"] as? String ?? ""
                self.username = snapshot?.data()?["username"] as? String ?? ""
            }
        }
        self.isLoggedIn = true
    }
    
    func signOut () {
        self.email = nil
        self.isLoggedIn = nil
    }
}
