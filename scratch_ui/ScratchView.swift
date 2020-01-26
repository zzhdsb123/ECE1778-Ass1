//
//  ScratchView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-18.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import FlowStack

struct ScratchView: View {
    @State var present = false
    
    var body: some View {
        FlowStack(columns: 3, numItems: 27, alignment: .leading) { index, colWidth in
          Text(" \(index) ").frame(width: colWidth, height: colWidth)
        }
        .actionSheet(isPresented: $present) {
        ActionSheet(title: Text("Action Sheet"))
        }
    }
}

struct ScratchView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchView()
    }
}
