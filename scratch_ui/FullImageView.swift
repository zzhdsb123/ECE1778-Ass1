//
//  FullImageView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-29.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import FirebaseStorage

struct FullImageView: View {
    @EnvironmentObject var session: Session
//    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showing_delete_alert = false
    
    func delete () {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            if self.session.full_image != nil {
                Image(uiImage: self.session.full_image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            }
            else {
                Text("loading...")
            }
        }
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.showing_delete_alert.toggle()
            }) {
                Image(systemName: "trash")
            }
            
        })
            .alert(isPresented: $showing_delete_alert) {
                Alert(title: Text("Delete Image"), message: Text("Are you sure?"), primaryButton: .destructive(Text("DELETE")){
                    self.delete()
                    }, secondaryButton: .cancel())
        }
    }
}

//struct FullImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        FullImageView(image_name: "4").environmentObject(Session())
//    }
//}
