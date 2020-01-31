//
//  UserPhotoView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-29.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct UserPhotoView: View {
    @EnvironmentObject var session: Session
    let width: CGFloat?
    
    init (width: CGFloat) {
        self.width = width
    }
    
    func getFullImage (name: String) {
        let storage_ref = Storage.storage().reference(withPath: "\(String(describing: self.session.userid))/\(name).jpg")
        
        storage_ref.getData(maxSize: 5*1024*1024) { (data, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.session.current_image = name
                self.session.full_image = UIImage(data: data!)!
            }
        }
    
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                ForEach(0..<self.session.images.count, id: \.self) {images in
                    HStack (spacing: 0) {
                        ForEach(0..<self.session.images[images].count, id: \.self) {image in
                            NavigationLink(destination: FullImageView()) {
                                Image(uiImage: self.session.images[images][image])
                                .renderingMode(.original)
                                .resizable()
                                .padding(5)
                                .frame(width: self.width, height: self.width)
                                .aspectRatio(contentMode: .fit)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded({
                                self.session.full_image = nil
                                self.getFullImage(name: self.session.images_tracker[images][image])
                            }))
                        }
                    }
                }
            
            }
        }
        
    }
}

//struct UserPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserPhotoView(width: 10).environmentObject(Session())
//    }
//}
