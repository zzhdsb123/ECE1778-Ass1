//
//  AuthView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-09.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        TabView {
            UserView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                        .padding()
                        .background(Color.gray)
                        .padding()
                    Text("Profile")
                        .padding()
            }
            GlobalView()
                .tabItem {
                    Image(systemName: "house")
                        .padding()
                        .background(Color.gray)
                        .padding()
                    Text("Feed")
                        .padding()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
