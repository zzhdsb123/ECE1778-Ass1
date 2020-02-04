//
//  SignInView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-15.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct SignInView: View {
    @State var error_msg = ""
    @State var show = false
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var session: Session
    
    
    
    func signIn () {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { (res, err) in
            if err != nil {
                self.error_msg = err!.localizedDescription
                self.show.toggle()
            }
            else {
                self.session.userid = Auth.auth().currentUser!.uid
                self.session.signIn(email: self.email)
            }
        }
    }
    
    var body: some View {

        NavigationView {
            HStack(alignment: .top) {
                VStack() {
                    Text("My Instagram")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding()
                        .background(Color(red: 158 / 255, green: 158 / 255, blue: 180 / 255))
                        .foregroundColor(Color.white)
                        .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                        .frame(height: 40)
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
                    
                    Button(action: signIn) {
                        Text("LOG IN")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                            .padding()
                            .shadow(radius: 10)
                        }

                    ZStack{
                        Divider()
                            .padding()
                        Text("OR")
                            .padding()
                            .foregroundColor(Color(red: 158 / 255, green: 158 / 255, blue: 158 / 255))
                    }
                    
                    NavigationLink(destination: SignUpView()) {
                    Text("SIGN UP")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                    }
                    
                    Spacer()
         }
            }
                .background(
                    Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                )
                .navigationBarTitle("Home", displayMode: .inline)
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(true)
        }
        .alert(isPresented: $show) {
            Alert(title: Text(self.error_msg))}
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
