//
//  AuthModel.swift
//  Memories
//
//  Created by Данил Швец on 13.06.2023.
//

import Foundation
import FirebaseAuth

final class AuthModel {
    
    func logIn(email: String?, password: String?, complitionError: @escaping (String, String) -> ()) {
        guard let email = email, isValidEmail(email: email) else {
            complitionError("", "Incorrect email format")
            return
        }
        guard let password = password, isValidPassword(password: password) else {
            complitionError("", "The password must be at least 6 characters long and contain only letters, numbers, and signs. or _")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            guard let strongSelf = self else { return }
            if ((authResult?.user) != nil) {
                complitionError(String(authResult!.user.uid), "")
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                UserDefaults.standard.set(authResult!.user.uid, forKey: "userID")
            } else {
                if error != nil {
                    complitionError("", error!.localizedDescription)
                }
            }
        }
    }
    
    func createNewUser(username: String?, email: String?, password: String?, complitionError: @escaping (String, String) -> ()) {
        guard let username = username, isValidUsername(username: username) else {
            complitionError("", "The username must contain at least 3 characters and contain only latin letters and numbers")
            return
        }
        guard let email = email, isValidEmail(email: email) else {
            complitionError("", "Incorrect email format")
            return
        }
        guard let password = password, isValidPassword(password: password) else {
            complitionError("", "The password must be at least 6 characters long and contain only letters, numbers, and signs. or _")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if ((authResult?.user) != nil) {
                complitionError(String(authResult!.user.uid), "")
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                UserDefaults.standard.set(authResult!.user.uid, forKey: "userID")
            } else {
                if error != nil {
                    complitionError("", error!.localizedDescription)
                }
            }
//            if error != nil {
//                complitionError(error!.localizedDescription)
//            }
        }
    }
    
    func signOut(completion: @escaping (Bool) -> ()) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    private func isValidUsername(username: String) -> Bool {
        let user = "[A-Z0-9a-z]{3,100}"
        let userPred = NSPredicate(format:"SELF MATCHES %@", user)
        return userPred.evaluate(with: username)
    }
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    private func isValidPassword(password: String) -> Bool {
        let pass = "[A-Z0-9a-z._]{6,100}"
        let passPred = NSPredicate(format:"SELF MATCHES %@", pass)
        return passPred.evaluate(with: password)
    }
}
