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
        let profileImageRef = storageRef.child("images/\(uid)/profileImage.jpeg")
        
        profileImageRef.putData(photo, metadata: nil) { (metadata, error) in
            if error != nil {
                completion(error!.localizedDescription)
            }
        }
    }
    
    func sendMemoryDataToFirebase(userID: String, memoryID: String, title: String, date: String) {
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
        self.ref.child("memories").child(userID).child(memoryID).setValue(["title": title, "date": date])
//        self.ref.child("memories").child(userID).child(memoryID).setValue(["date": date])
    }
    
    func sendMemoryImagesToFirebase(userID: String, memoryID: String, image: Data, imageName: String, completion: @escaping (String) -> ()) {
        let storageRef = storage.reference()
        let memoryImageRef = storageRef.child("memories/\(userID)/\(memoryID)/\(imageName).jpeg")
        
        memoryImageRef.putData(image, metadata: nil) { (metadata, error) in
            if error != nil {
                completion(error!.localizedDescription)
            }
        }
    }
    
    func deleteMemoryDataFromFirebase(userID: String, memoryID: String) {
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
        self.ref.child("memories").child(userID).child(memoryID).removeValue()
    }
    
    func deleteMemoryImagesFromFirebase(userID: String, memoryID: String, imageName: String, completion: @escaping (String) -> ()) {
        let storageRef = storage.reference()
        let memoryImageRef = storageRef.child("memories/\(userID)/\(memoryID)/\(imageName).jpeg")
        
        memoryImageRef.delete { error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                print("deleted")
            }
        }
    }
}
