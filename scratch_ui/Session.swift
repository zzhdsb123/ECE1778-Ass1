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

class Session: ObservableObject {
    @Published var email: String?
    @Published var isLoggedIn: Bool?
    
    func signIn (email: String) {
        self.isLoggedIn = true
        self.email = email
    }
}
