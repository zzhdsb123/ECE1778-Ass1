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
import FlowStack

struct AuthView: View {
    @EnvironmentObject var session: Session
    @State var error_msg = ""
    @State var picker = false
    @State var image = UIImage()
    @State var selected = false
    @State var show_sheet = false
    @State var camera = false
    
    func upload () {
        //
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
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                ScrollView {
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
                    if self.selected {
                        Image(uiImage: self.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding()
                        HStack {
                            Button(action: {
                                //
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
                                //
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
                    
                }
            }
            
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    self.show_sheet.toggle()
                }) {
                    Image(systemName: "square.and.arrow.up").font(.system(size: 20))
                        .foregroundColor(Color.black)
                }
                
            })
            .navigationBarTitle(Text("Profile").font(.subheadline), displayMode: .inline)
            .background(
            Image("background")
            .resizable()
            .frame(width:1400, height: 925)
            )
        }
        .actionSheet(isPresented: $show_sheet) {
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
        .sheet(isPresented: $picker, content: {
            ImagePickerView(isPresented: self.$picker, selectedImage: self.$image, selected: self.$selected, camera: self.$camera)
        })
    }
    
}

struct Auth_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(Session())
    }
}

