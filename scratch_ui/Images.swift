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
        FlowStack(columns: 3, numItems: self.session.total!, alignment: .leading) { (index, colWidth) in
            Image(uiImage: self.session.images[index])
                .resizable()
                .padding(5)
                .frame(width: colWidth, height: colWidth)
        }
    }
}

struct Images_Previews: PreviewProvider {
    static var previews: some View {
        Images()
    }
}
