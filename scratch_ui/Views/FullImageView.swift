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
    var name: String
    
    init (name: String) {
        self.name = name
    }
    
    func postComment () {
        if self.comment == "" {
            self.error_message = "Say something!"
            self.show_error.toggle()
        }
        else {
            self.session.postComment(comment: self.comment, image_name: self.name)
        }
    }
    
    func loadComments () {
        self.session.loadComment(image_name: self.name) { comments in
            self.comments = comments
        }
    }
    
    var body: some View {
        ScrollView {
            
            if self.image != nil {
                Image(uiImage: self.image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            }
            else {
                Text("loading...")
            }
            
            VStack (alignment: .leading, spacing: 5) {
                Group {
                    Text("\(self.caption)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(self.hashtags)")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach (self.comments, id: \.self) { comment in
                        VStack (alignment: .leading) {
                            Text(comment["username"]! + ": " + comment["comment"]!)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                        
                        .padding(5)
                        .background(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                    }
                    
                    TextField("Add a comment...", text: self.$comment).padding()
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                Button(action: {
                    self.postComment()
                }) {
                    Text("POST COMMENT")
                        .font(.subheadline)
                        .frame(maxWidth: 120)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                }
                .alert(isPresented: self.$show_error) {
                    Alert(title: Text(self.error_message))
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
            }
            self.loadComments()
        }
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.showing_delete_alert.toggle()
            }) {
                Image(systemName: "trash")
                
            }
            
        })
        .alert(isPresented: $showing_delete_alert) {
            Alert(title: Text("Delete Image"), message: Text("Are you sure?"), primaryButton: .destructive(Text("DELETE")){
                self.session.deleteImage(name: self.name)
                self.presentationMode.wrappedValue.dismiss()
                }, secondaryButton: .cancel())
        }
    }
}

