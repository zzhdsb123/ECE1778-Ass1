//
//  FullImageView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-09.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI

struct FullImageView: View {
    @EnvironmentObject var session: Session
    @Environment(\.presentationMode) var presentationMode
    @State private var showing_delete_alert = false
    @State var image: UIImage?
    @State var caption = ""
    @State var hashtags = ""
    @State var comments = [[String: String]]()
    @State var comment = ""
    @State var error_message = ""
    @State var show_error = false
    @State var image_uploader: String?
    var name: String
    
    func loadCommentsUserImage () {
        self.session.loadCommensUserImages(comments: self.comments)
    }
    
    init (name: String) {
        self.name = name
    }
    
    func postComment () {
        if self.comment == "" {
            self.error_message = "Say something!"
            self.show_error.toggle()
        }
        else {
            self.session.postComment(comment: self.comment, image_name: self.name) {
                self.loadComments()
            }
        }
    }
    
    func loadComments () {
        self.session.loadComment(image_name: self.name) { comments in
            self.comments = comments
            self.loadCommentsUserImage()
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                
                if self.image != nil {
                    Image(uiImage: self.image!)
                    .resizable()
                    .aspectRatio(self.session.calculateAspectRatio(image: self.image!), contentMode: .fit)
                    .frame(maxWidth: .infinity)
                }
                else {
                    Text("loading...")
                }
                
                VStack (alignment: .leading, spacing: 5) {
                    Group {
                        VStack (alignment: .leading, spacing: 0) {
                            Text("\(self.caption)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(5)
                                
                            Text("\(self.hashtags)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(5)
                                
                        }
                        .padding(5)
                        .background(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        
                        Spacer()
                            .frame(height: 10)
                        
                        ForEach (self.comments, id: \.self) { comment in
                            HStack {
                                if self.session.comment_user_image[comment["user_id"]!] != nil {
                                    Image(uiImage: self.session.comment_user_image[comment["user_id"]!]!)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 40, height: 40)
                                        .padding(5)
                                }
                                else {
                                    Image(systemName: "person")
                                        .padding()
                                        .frame(width: 40, height: 40)
                                        .padding(5)
                                    
                                }
                                
                                Text(comment["username"]! + ": " + comment["comment"]!)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(5)
                            }
                            
                            .padding(5)
                            .background(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                            .cornerRadius(20)
                            .shadow(radius: 20)
                        }
                        
                    Spacer()
                        .frame(height: 10)
                        
                    }
                    
                }
                
                
                
            }
            
            .onAppear() {
                self.session.loadFullImage(name: self.name) { (image) in
                    if image != nil {
                        self.image = image
                    }
                }
                self.session.getImageDetail(name: self.name) { result in
                    self.caption = result["caption"]!
                    self.hashtags = result["hash_tag"]!
                    self.image_uploader = result["uploader"]!
                    
                }
                self.loadComments()
            }
            .navigationBarItems(trailing: HStack {
                if self.image_uploader == self.session.user_id {
                    Button(action: {
                        self.showing_delete_alert.toggle()
                    }) {
                        Image(systemName: "trash")
                    }
                }
                
                
            })
            .alert(isPresented: $showing_delete_alert) {
                Alert(title: Text("Delete Image"), message: Text("Are you sure?"), primaryButton: .destructive(Text("DELETE")){
                    self.session.deleteImage(name: self.name)
                    self.session.loadGlobalImage()
                    self.presentationMode.wrappedValue.dismiss()
                    }, secondaryButton: .cancel())
            }
            
            HStack (spacing: 0) {
                TextField("Add a comment...", text: self.$comment).padding()
                    .background(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                    .cornerRadius(5)
                    .padding()
                    
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    self.postComment()
                    self.loadComments()
                    self.comment = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.headline)
                        .padding()

                        .shadow(radius: 10)
                }
                .alert(isPresented: self.$show_error) {
                    Alert(title: Text(self.error_message))
                }
            }
        }
        
    }
}

