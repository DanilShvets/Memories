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

final class DownloadDataModel {
    
    private let storage = Storage.storage()
    
    func downloadUserProfileImage(uid: String, completion: @escaping (URL?) -> ()) {
        let pathReference = storage.reference(withPath: "images/\(uid)/")
        let imageRef = pathReference.child("profileImage.jpeg")
        var imageURL: URL?
        imageRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                imageURL = url
                completion(imageURL)
                return
            }
        }
    }
    
    func downloadMemoryMainImage(userID: String, memoryID: String, completion: @escaping (URL?) -> ()) {
        let pathReference = storage.reference(withPath: "memories/\(userID)/\(memoryID)")
        
        let imageRef = pathReference.child("memoryImage0.jpeg")
        var imageURL: URL?
        imageRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                imageURL = url
                completion(imageURL)
                return
            }
        }
    }
    
    func getNumberOfImages(userID: String, memoryID: String, completion: @escaping (Int) -> ()) {
        let pathReference = storage.reference(withPath: "memories/\(userID)/\(memoryID)")
        var numberOfItems = 0
        pathReference.listAll { result, error in
            guard let result = result else { return }
            numberOfItems = result.items.count
            print("numberOfItemsInFolder:\(numberOfItems)")
            completion(numberOfItems)
            return
        }
    }
    
    
    func downloadMemoryImages(userID: String, memoryID: String, numberOfItem: Int, completion: @escaping (URL?) -> ()) {
        let pathReference = storage.reference(withPath: "memories/\(userID)/\(memoryID)")
        
        var imageURL: URL?
        let imageRef = pathReference.child("memoryImage\(numberOfItem).jpeg")
        
        imageRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                imageURL = url
                completion(imageURL)
                return
            }
        }
    }
    
    func downloadMemoryImagesAsImage(userID: String, memoryID: String, numberOfItem: Int, completion: @escaping (UIImage?) -> ()) {
        let pathReference = storage.reference(withPath: "memories/\(userID)/\(memoryID)")
        let imageRef = pathReference.child("memoryImage\(numberOfItem).jpeg")
        
        imageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error {
            } else {
                let image = UIImage(data: data!)
                completion(image)
                return
            }
        }
    }
    
}
