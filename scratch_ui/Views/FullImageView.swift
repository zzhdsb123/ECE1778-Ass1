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
    @State var caption = "???"
    @State var hashtags = ""
    
    var name: String
    
    init (name: String) {
        self.name = name
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
            
            
            Text("\(self.caption)")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(self.hashtags)")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .onAppear() {
            self.session.loadFullImage(name: self.name) { (image) in
                if image != nil {
                    self.image = image
                }
            }
            self.session.getImageDetail(name: self.name) { (result) in
                self.caption = result["caption"]!
                self.hashtags = result["hash_tag"]!
            }
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
//                    self.delete()
                }, secondaryButton: .cancel())
        }
    }
}

