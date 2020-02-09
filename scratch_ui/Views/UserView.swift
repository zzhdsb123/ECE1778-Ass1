//
//  UserView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-08.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct UserView: View {
    @EnvironmentObject var session: Session
    @State var picker = false
    @State var show_sheet = false
    @State var user_image: UIImage?
    @State var selected = false
    @State var camera = false
    @State var image = UIImage()
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView (.vertical) {
                    Spacer()
                        .frame(height: 30)
                    HStack {
                        ZStack {
                            Button(action: {
                                self.show_sheet.toggle()
                            }) {
                                Image(systemName: "camera")
                                .resizable()
                                .frame(width: 60, height: 50)
                                .foregroundColor(Color.white)
                                .padding()
                                .offset(x: -55, y: 35)
                                .shadow(radius: 10)
                            }
                            if self.session.user_image == nil {
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
                                    .zIndex(-1)
                            }
                            else {
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
                                    .zIndex(-1)
                            }
                        }
                        Spacer()
                            .frame(width: 30)
                        VStack (alignment: .leading, spacing: 0) {
                            Text(self.session.user_info["username"] ?? "Loading username...")
                            .foregroundColor(Color.white)
                            .font(.title)
                            Text(self.session.user_info["bio"] ?? "Loading bio...")
                            .foregroundColor(Color.white)
                        }
                    }
                .frame(maxWidth: .infinity)
                    
                }
                .sheet(isPresented: self.$picker, content: {
                    ImageSelect(picker: self.$picker, image: self.$image, selected: self.$selected, camera: self.$camera, user_image: self.$user_image).environmentObject(self.session)
                    
                })
                .actionSheet(isPresented: self.$show_sheet, content: {
                ActionSheet(title: Text("Take a picture or select one from the gallery"), buttons: [
                    .default(Text("Take a picture"), action: {
                        self.selected = false
                        self.camera = true
                        self.picker.toggle()
                        
                    }),
                    .default(Text("Select an existing picture"), action: {
                        self.camera = false
                        self.selected = false
                        self.picker.toggle()
                    }),
                    .cancel()])
                })
                .navigationBarTitle(Text("Profile").font(.subheadline), displayMode: .inline)
                .background(
                Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                )
                
            }
            .onAppear {
                self.session.loadData()
            }
        }
        
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
