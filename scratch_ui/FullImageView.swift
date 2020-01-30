//
//  FullImageView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-29.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct FullImageView: View {
    @EnvironmentObject var session: Session
//    @Binding var full_image: UIImage?
    
    
    var body: some View {
        VStack {
            if self.session.full_image != nil {
                Image(uiImage: self.session.full_image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            }
            else {
                Text("loading...")
            }
        }
        
    }
}

//struct FullImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        FullImageView(image_name: "4").environmentObject(Session())
//    }
//}
