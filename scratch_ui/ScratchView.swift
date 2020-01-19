//
//  ScratchView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-18.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI

struct ScratchView: View {
    @State var present = false
    var body: some View {
        VStack {
            Button(action: {
                self.present.toggle()
            }) {
            Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
            }
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
