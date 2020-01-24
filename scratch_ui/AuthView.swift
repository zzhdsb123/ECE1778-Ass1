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
    
    var body: some View {
        VStack {
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
                .frame(height: 20)
            Text(String(self.session.username ?? "Loading username..."))
                .foregroundColor(Color.white)
                .font(.title)
                .padding()
            
            Text(String(self.session.bio ?? "Loading bio..."))
                .foregroundColor(Color.white)
                .padding()
            
            Spacer()
                .frame(height: 80)
            
            Button(action: signOut) {
                Text("SIGN OUT")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                    .padding()
                    .shadow(radius: 10)
            }
            
//            Button(action: getUserImg){
//                Text("Test")
//                    .font(.subheadline)
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(Color.white)
//                    .padding()
//                    .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
//                    .padding()
//                    .shadow(radius: 10)
//            }
            
        }
        .background(
        Image("background")
        .resizable()
            .frame(width:1400, height: 925)
        )
    }
}

//struct Auth_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthView().environmentObject(Session())
//    }
//}
