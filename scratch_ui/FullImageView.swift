//
//  FullImageView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-29.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore


struct FullImageView: View {
    @EnvironmentObject var session: Session
//    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showing_delete_alert = false
    
    
    func delete () {
        let db = Firestore.firestore().collection("users").document(self.session.userid!)
        db.getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                var photos = (snapshot!.data()!["photos"] as! [String])
                if let index = photos.firstIndex(of: self.session.current_image!) {
                    photos.remove(at: index)
                }
                db.setData(["photos": photos], merge: true)
            }
        }
        presentationMode.wrappedValue.dismiss()

        self.session.count = 0
        self.session.images = [[UIImage]]()
        self.session.images_tracker = [[String]]()
        let dbb = Firestore.firestore().collection("users")
        dbb.document(self.session.userid!).getDocument { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.session.total = (snapshot!.data()!["total"] as? Int)! - 1
                self.session.getAllImg()
            }
        }
        let storage_ref_thumbnail = Storage.storage().reference(withPath: "\(String(describing: self.session.userid))/\(self.session.current_image!)_thumbnail.jpg")
        storage_ref_thumbnail.delete { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        let storage_ref = Storage.storage().reference(withPath: "\(String(describing: self.session.userid))/\(self.session.current_image!).jpg")
        storage_ref.delete { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    
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
