//
//  GlobalImages.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-11.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI

struct GlobalImages: View {
    @EnvironmentObject var session: Session
    var width: CGFloat
    
    init (width: CGFloat) {
        self.width = width
    }
    
    var body: some View {
        
        VStack (spacing: 0) {
            Group {
                ForEach (self.session.global_image, id: \.self) { image_helper in
                    Group {
                        if image_helper != nil {
                            NavigationLink(destination: FullImageView(name: image_helper!.name)) {
                                if image_helper!.image != nil {
                                    Image(uiImage: image_helper!.image!)
                                        .resizable()
                                        .aspectRatio(self.session.calculateAspectRatio(image: image_helper!.image!), contentMode: .fill)
                                        .frame(width: self.width * 0.97, height: self.width * 0.97)
                                        .mask(Rectangle().size(width: self.width * 0.97, height: self.width * 0.97).cornerRadius(10))
                                        .clipped()
                                        .padding(5)

                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                Text("")
                .padding()
                .frame(width: self.width * 0.97, height: 1)
                .cornerRadius(10)
                .padding()
            }
            
            
        }
        
    }
}

