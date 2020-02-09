//
//  ImageSelect.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-08.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI

struct ImageSelect: View {
    @Binding var picker: Bool
    @Binding var image: UIImage
    @Binding var selected: Bool
    @Binding var camera: Bool
    @Binding var user_image: UIImage?
    @EnvironmentObject var session: Session
    
    var body: some View {
        Group {
            if self.selected == false {
                ImagePickerView(isPresented: self.$picker, selectedImage: self.$image, selected: self.$selected, camera: self.$camera)
            }
            else {
                VStack (alignment: .leading) {
                    Image(uiImage: self.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    HStack {
                        
                        Button(action: {
                            if self.session.user_id == nil {
                                self.picker = false
                                self.user_image = self.image
                            }
                            else {
                                self.session.uploadImage (image: self.image) { (err) in
                                    //
                                }
                                self.picker = false
                            }
                            
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
                    }
                }
                
            }
        }
        
    }
}

//struct ImageSelect_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageSelect()
//    }
//}
