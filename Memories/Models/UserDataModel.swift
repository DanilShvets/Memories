//
//  UserDataModel.swift
//  Memories
//
//  Created by Данил Швец on 13.06.2023.
//

import Foundation
import Firebase

final class UserDataModel {
    
    private var ref: DatabaseReference!
    
    func getUserID(username: String, completionHandler: @escaping (String) -> ()) {
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
        ref.child("usernames/\(username)/uid").getData(completion:  { error, snapshot in
            guard let snapshot = snapshot else { return }
            if snapshot.exists() {
                guard let userId = snapshot.value else { return }
                completionHandler(userId as! String)
            }
        })
    }
    
    func getUsername(uid: String, completionHandler: @escaping (String) -> ()) {
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
        ref.child("users/\(uid)/username").getData(completion:  { error, snapshot in
            guard let snapshot = snapshot else {return}
            if snapshot.exists() {
                guard let username = snapshot.value else { return }
                completionHandler(username as! String)
            }
        })
    }
}
