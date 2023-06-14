//
//  DownloadDataModel.swift
//  Memories
//
//  Created by Данил Швец on 14.06.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Firebase
import FirebaseStorage
import Kingfisher

final class DownloadDataModel {
    
    private let storage = Storage.storage()
    
    func downloadUserProfileImage(uid: String, completion: @escaping (URL?) -> ()) {
        let pathReference = storage.reference(withPath: "images/\(uid)/")
        let imageRef = pathReference.child("profileImage.jpg")
        var imageURL: URL?
        imageRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                imageURL = url
                completion(imageURL)
            }
        }
    }
}