//
//  UploadDataModel.swift
//  Memories
//
//  Created by Данил Швец on 13.06.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Firebase
import FirebaseStorage

final class UploadDataModel {
    
    private var ref: DatabaseReference!
    private let storage = Storage.storage()
    
    func sendProfileDataToFirebase(uid: String, username: String) {
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
//        self.ref.child("users").child("uid").setValue(["username": username])
        self.ref.child("users").child(uid).setValue(["username": username])
//        self.ref.child("users").child("user").setValue()
    }
    
    func sendProfileImageToFirebase(uid: String, photo: Data) {
        let storageRef = storage.reference()
        let profileImageRef = storageRef.child("images/\(uid)/profileImage.jpg")
        
//        let uploadTask = profileImageRef.putData(photo, metadata: nil) { (metadata, error) in
        profileImageRef.putData(photo, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                return
//            }
            
//            let size = metadata.size
//            profileImageRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                    return
//                }
//            }
        }
    }
}
