//
//  UserImageView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-09.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct UserImageView: View {
    @EnvironmentObject var session: Session
    let width: CGFloat?
    
    init (width: CGFloat) {
        self.width = width
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                ForEach(0..<self.session.user_image_list.count, id: \.self) {images in
                    HStack (spacing: 0) {
                        ForEach(0..<self.session.user_image_list[images].count, id: \.self) {image in
                            NavigationLink(destination: FullImageView(name: self.session.user_image_tracker[images][image])) {
                                if self.session.user_image_list[images][image] != nil {
                                    Image(uiImage: self.session.user_image_list[images][image]!)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(self.session.calculateAspectRatio(image: self.session.user_image_list[images][image]!), contentMode: .fill)
                                    .frame(width: self.width! * 0.95, height: self.width! * 0.95)
                                    .mask(Rectangle().size(width: self.width! * 0.95, height: self.width! * 0.95).cornerRadius(10))
                                    .clipped()
                                    .padding(2)

                                }
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
            
            }
        }
        
    }
}
