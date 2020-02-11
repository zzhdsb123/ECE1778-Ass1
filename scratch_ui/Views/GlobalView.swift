//
//  GlobalView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-09.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI

struct GlobalView: View {
    @EnvironmentObject var session: Session
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ScrollView {
                    Text("123")
                    
                }
            }
            .onAppear() {
                self.session.loadGlobalData()
            }
            
        }
        
    }
}

struct GlobalView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalView()
    }
}
