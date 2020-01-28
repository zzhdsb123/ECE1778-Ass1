//
//  ScratchView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-18.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import WaterfallGrid

struct ScratchView: View {
    @State var present = false
    
    var body: some View {
        GeometryReader {geometry in
            WaterfallGrid((0..<4), id: \.self) { index in
                Image(systemName: "person")
                .resizable()
                .padding(5)
                .frame(width: geometry.size.width/3, height: geometry.size.width/3)
            }
            .gridStyle(columns: 3)
        }
        
//        FlowStack(columns: 3, numItems: 4, alignment: .leading) { index, colWidth in
//          Text(" \(index) ").frame(width: colWidth, height: colWidth)
//        }
//        .actionSheet(isPresented: $present) {
//        ActionSheet(title: Text("Action Sheet"))
//        }
    }
}

struct ScratchView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchView()
    }
}
