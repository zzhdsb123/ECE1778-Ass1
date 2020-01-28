//
//  Images.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-27.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import WaterfallGrid

struct Images: View {
    @EnvironmentObject var session: Session
    
    var body: some View {
        GeometryReader {geo in
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.session.images, id: \.self) {images in
                    HStack (spacing: 0) {
                        ForEach(images, id: \.self) {image in
                            Image(uiImage: image)
                            .resizable()
                            .padding(5)
                            .frame(width: geo.size.width/3, height: geo.size.width/3)
                        }
                    }
                }
            }
        }
    }
}

struct Images_Previews: PreviewProvider {
    static var previews: some View {
        Images()
    }
}
