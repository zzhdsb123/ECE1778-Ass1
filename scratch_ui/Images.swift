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
    @State var count = 0
    
    var body: some View {
        GeometryReader {geometry in
            WaterfallGrid(self.session.images, id: \.self) { image in
                Image(uiImage: image)
                .resizable()
                .padding(5)
                .frame(width: geometry.size.width/3, height: geometry.size.width/3)
            }
            .gridStyle(columns: 3)
            .scrollOptions(
              direction: .vertical
            )
        }
    }
}

struct Images_Previews: PreviewProvider {
    static var previews: some View {
        Images()
    }
}
