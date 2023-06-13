//
//  UserDataModel.swift
//  Memories
//
//  Created by Данил Швец on 13.06.2023.
//

import Foundation
import FirebaseAuth

final class UserDataModel {
    
    func getUserData() {
        
        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            print(user?.displayName)
        }
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
            }
        }
    }
}
