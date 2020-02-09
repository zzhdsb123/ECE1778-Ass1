//
//  ImagePickerView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-02-08.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    @Binding var selected: Bool
    @Binding var camera: Bool
    typealias UIViewControllerType = UIImagePickerController
    @EnvironmentObject var session: Session
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        if self.camera {
            controller.sourceType = .camera
        }
        else {
            controller.sourceType = .photoLibrary
        }
        return controller
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePickerView
        init (parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                print(selectedImage)
                self.parent.selectedImage = selectedImage
                self.parent.selected = true
            }
//            self.parent.isPresented = false
//            self.parent.camera = false
        }
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        //
    }
}
