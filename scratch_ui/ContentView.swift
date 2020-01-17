//
//  ContentView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-08.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import Firebase


struct DetailView: View {
  let discipline: String
  var body: some View {
    Text(discipline)
  }
}

struct ContentView: View {
    @EnvironmentObject var session : Session
    
    @ViewBuilder
    
    var body: some View {
        if self.session.isLoggedIn != nil {
            AuthView()
        }
        else {
            SignInView()
        }
        
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
