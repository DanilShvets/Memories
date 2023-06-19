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
    private var posts = [[String : AnyObject]]()
    private var postIDs = [String]()
    func getMemoryDate(completion: @escaping ([[String : AnyObject]], [String]) -> ()) {
        ref = Database.database(url: "https://memoriesapp-d9697-default-rtdb.firebaseio.com").reference()
        let myTopPostsQuery = ref.child("usernames/Tester/Memories").queryOrdered(byChild: "Date")
        myTopPostsQuery.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        //                            print(key)
                        //                            print(postDict["Date"]!)
                        
                        self.posts.append(postDict)
                        self.postIDs.append(key)
                    } else {
                        print("Error")
                    }
                }
            }
            completion(self.posts, self.postIDs)
        })
    }
    
}
