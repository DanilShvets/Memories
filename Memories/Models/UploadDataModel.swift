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
        self.ref.child("users").child(uid).setValue(["username": username])
        self.ref.child("usernames").child(username).setValue(["uid": uid])
    }
    
    func sendProfileImageToFirebase(uid: String, photo: Data, completion: @escaping (String) -> ()) {
        let storageRef = storage.reference()
        let profileImageRef = storageRef.child("images/\(uid)/profileImage.jpg")
        
        profileImageRef.putData(photo, metadata: nil) { (metadata, error) in
            if error != nil {
                completion(error!.localizedDescription)
            }
        }
    }
}
