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
                                        .cornerRadius(15)
                                        .padding(5)
                                        .frame(width: self.width, height: self.width)
                                    
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

