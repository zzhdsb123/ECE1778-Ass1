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
import Firebase

class Session: ObservableObject {
    @Published var email: String?
    @Published var isLoggedIn: Bool?
    @Published var bio: String?
    @Published var username: String?
    
    func signIn (email: String) {
        self.email = email
        let key = email.replacingOccurrences(of: ".", with: ",")
        let db = Database.database().reference().child("users")
        db.child("\(key)/bio").observeSingleEvent(of: .value) { (snapshot) in
            self.bio = snapshot.value as? String
        }
        db.child("\(key)/username").observeSingleEvent(of: .value) { (snapshot) in
            self.username = snapshot.value as? String
        }
        self.isLoggedIn = true
    }
    
    func signOut () {
        self.email = nil
        self.isLoggedIn = nil
    }
}
