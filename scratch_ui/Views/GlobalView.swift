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
                    GlobalImages(width: geo.size.width)
                }
                .navigationBarTitle(Text("Explore").font(.subheadline), displayMode: .inline)
                .background(
                Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                )
                .navigationBarItems(trailing: HStack {
                    Button(action: {
                        self.session.loadGlobalImage()
                    }) {
                        Text("REFRESH")
                    }
                    
                    
                })
            }
            
        }
        
    }
}

struct GlobalView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalView()
    }
}
