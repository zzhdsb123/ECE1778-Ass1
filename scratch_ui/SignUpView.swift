//
//  SignUpView.swift
//  scratch_ui
//
//  Created by Artorias on 2020-01-15.
//  Copyright © 2020 Artorias. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @State var confirm_password = ""
    @State var username = ""
    @State var bio = ""
    @State var show = false
    @State var error_msg = ""
    @State var picker = false
    @State var image = UIImage()
    @State var selected = false
    @State var show_sheet = false
    @State var camera = false
    @EnvironmentObject var session: Session
    
    func signUp () {
        if self.email == "" || self.password == "" || self.confirm_password == "" || self.username == "" || self.bio == "" {
            self.error_msg = "Please fill in the required field."
            self.show.toggle()
        }
        
        else if self.password != self.confirm_password {
            self.error_msg = "Passwords need to be the same."
            self.show.toggle()
        }
            
        else {
            Auth.auth().createUser(withEmail: self.email, password: self.password) {
                (res, err) in  if err != nil {
                    self.error_msg =  err!.localizedDescription
                    }
                else {
                    let db = Firestore.firestore().collection("users")
                    let email = self.email
                    let key = email
                    db.document(key).setData(["username": self.username, "bio": self.bio])
                    self.session.signIn(email: self.email)
                }
                self.show.toggle()
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                HStack (alignment: .top) {
                    Text("Register")
                    Spacer()
                    Button(action: {
                        self.show_sheet.toggle()
                    }) {
                        Image(systemName: "camera")
                    }
                    
                }
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding()
                .background(Color(red: 158 / 255, green: 158 / 255, blue: 180 / 255))
                .foregroundColor(Color.white)
                
                Spacer()
                    .frame(height: 40)
                
                HStack (alignment: .top) {
                    if self.selected != false {
                        Image(uiImage: image)
                        .resizable()
                        .frame(width: 100,
                             height: 100,
                             alignment: .topLeading)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    }
                    else {
                        Image(systemName: "person")
                        
                        .resizable()
                        
                        .padding()
                        .frame(width: 100,
                            height: 100,
                            alignment: .topLeading)
                        .background(Color.gray)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    }
                    Spacer()
                        .frame(width: 40)
                    Text("Set Display Picture")
                        .foregroundColor(Color.white)
                    Spacer()
                        .frame(width: 60)
                }
                    
                Spacer()
                    .frame(height: 30)
                Group {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                    SecureField("Confirm Password", text: $confirm_password)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                    TextField("A short bio", text: $bio)
                        .padding()
                        .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .padding()
                        .opacity(0.8)
                }
                HStack {
                    Spacer()
                    Button(action: signUp) {
                    Text("SIGN UP")
                        .font(.subheadline)
                        .frame(maxWidth: 100)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                    }
                }
                Spacer()
            }
            .alert(isPresented: $show) {
                Alert(title: Text(self.error_msg))
            }
        }
        .sheet(isPresented: $picker, content: {
            ImagePickerView(isPresented: self.$picker, selectedImage: self.$image, selected: self.$selected, camera: self.$camera)
        })
        .actionSheet(isPresented: $show_sheet, content: {
            ActionSheet(title: Text("Take a picture or select one from the gallery"), buttons: [
                .default(Text("Take a picture"), action: {
                    self.camera.toggle()
                    self.picker.toggle()
                }),
                .default(Text("Select an existing picture"), action: {
                    self.picker.toggle()
                }),
                .cancel()])
        })
        .background(
            Image("background")
                .resizable()
                .frame(width:1400, height: 925)
        )
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    @Binding var selected: Bool
    @Binding var camera: Bool
    
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        if self.camera {
            controller.sourceType = .camera
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
            self.parent.isPresented = false
            self.parent.camera = false
        }
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        //
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
