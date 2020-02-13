//
//  ImageSelect.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-08.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import Firebase

struct ImageSelect: View {
    @Binding var picker: Bool
    @Binding var image: UIImage
    @Binding var selected: Bool
    @Binding var camera: Bool
    @Binding var user_image: UIImage?
    @State var hash = ""
    @State var caption = ""
    @EnvironmentObject var session: Session
    
    func hashTag (hash_tag: Bool) -> String {
        if hash_tag {
            self.session.labelImage(image: self.image) { (hash) in
                if hash != nil {
                    self.hash = hash!
                }
            }
        }
        return "Enable Auto Hashtags"
    }
    
    func sendPhoto () -> String {
        if self.session.user_id == nil {
            self.picker = false
            self.user_image = self.image
        }
        else {
            self.session.uploadImage (image: self.image, hash: self.hash, caption: self.caption) { (err) in
                //
            }
            self.picker = false
        }
        return ""
    }
    
    var body: some View {
        Group {
            if self.selected == false {
                ImagePickerView(isPresented: self.$picker, selectedImage: self.$image, selected: self.$selected, camera: self.$camera)
            }
            else if self.session.user_id != nil {
                ScrollView {
                    VStack (alignment: .leading) {
                        Image(uiImage: self.image)
                        .resizable()
                        .aspectRatio(self.session.calculateAspectRatio(image: self.image), contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        
                        if self.session.user_id != nil {
                            
                            TextField("Caption", text: self.$caption)
                                .padding()
                            TextField("Hashtags", text: self.$hash)
                                .padding()
                            Toggle(isOn: self.$session.auto_hashtag) {
                                if self.session.auto_hashtag {
                                    Text(self.hashTag(hash_tag: self.session.auto_hashtag))
                                }
                                else {
                                    Text(self.hashTag(hash_tag: self.session.auto_hashtag))
                                }
                            }
                                .padding()
                        }
                        
                        HStack {
                            
                            Button(action: {
                                self.sendPhoto()
                                
                            }) {
                                Text("CONFIRM")
                                .font(.subheadline)
                                .frame(maxWidth: 120)
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                                .padding()
                                .shadow(radius: 10)
                            }
                            .onAppear() {
                                if self.session.user_id != nil && self.session.auto_hashtag {
                                    self.session.labelImage(image: self.image) { (hash) in
                                        if hash != nil {
                                            self.hash = hash!
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                
            }
            
            else if self.session.user_id == nil {
                Text(self.sendPhoto())
            }
        }
        
    }
}

//struct ImageSelect_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageSelect()
//    }
//}
