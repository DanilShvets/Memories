//
//  MemoryDataModel.swift
//  Memories
//
//  Created by Данил Швец on 19.06.2023.
//

import Foundation
import Firebase

final class MemoryDataModel {
    
    private var ref: DatabaseReference!
    
    
    func getMemoryInfo(userID: String, completion: @escaping ([[String : AnyObject]], [String]) -> ()) {
        var posts = [[String : AnyObject]]()
        var postIDs = [String]()
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
        let myTopPostsQuery = ref.child("memories/\(userID)").queryOrdered(byChild: "date")
        myTopPostsQuery.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        posts.append(postDict)
                        postIDs.append(key)
                    } else {
                        print("Error")
                        return
                    }
                }
            }
            completion(posts, postIDs)
            return
        })
    }
    
    
    func getMemoryTitle(userID: String, memoryID: String, completionHandler: @escaping (String) -> ()) {
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
        ref.child("memories/\(userID)/\(memoryID)/title").getData(completion:  { error, snapshot in
            guard let snapshot = snapshot else {return}
            if snapshot.exists() {
                guard let title = snapshot.value else { return }
                completionHandler(title as! String)
                return
            }
        })
    }
    
    func getMemoryDate(userID: String, memoryID: String, completionHandler: @escaping (String) -> ()) {
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
        ref.child("memories/\(userID)/\(memoryID)/date").getData(completion:  { error, snapshot in
            guard let snapshot = snapshot else {return}
            if snapshot.exists() {
                guard let date = snapshot.value else { return }
                completionHandler(date as! String)
                return
            }
        })
    }
    
}
