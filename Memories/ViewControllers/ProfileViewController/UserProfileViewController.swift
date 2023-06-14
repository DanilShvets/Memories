//
//  UserProfileViewController.swift
//  Memories
//
//  Created by Данил Швец on 13.06.2023.
//

import UIKit

final class UserProfileViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 30
        static let cornerRadius: CGFloat = 20
        static let buttonHeight: CGFloat = 40
        static let skipButtonWidth: CGFloat = 65
    }
    
    private var profileImage = UIImage(systemName: "person.crop.circle")
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
        button.setTitle("Sign out", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    
    private let downloadDataModel = DownloadDataModel()
    private let authModel = AuthModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        self.title = "PROFILE"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureProfileImageView()
        configureProfileImage()
        configureSignOutButton()
    }
    
    private func configureProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2*UIConstants.padding).isActive = true
//        profileImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
//        profileImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.backgroundColor = .systemGray5
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
//        profileImageView.isUserInteractionEnabled = true
//        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureSignOutButton() {
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signOutButton)
        signOutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.5).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        signOutButton.layer.cornerRadius = UIConstants.cornerRadius
        signOutButton.backgroundColor = UIColor(named: "editButtonColor")?.withAlphaComponent(0.7)
        addShadowTo(myView: signOutButton)
    }
    
    private func addShadowTo(myView: UIView) {
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowPath = UIBezierPath(roundedRect: myView.bounds, cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 5.0
    }
    
    private func configureProfileImage() {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {return}
        downloadDataModel.downloadUserProfileImage(uid: userID) { url in
            self.profileImageView.kf.setImage(with: url)
        }
    }
    
    @objc private func signOutButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.signOutButton.transform = self.signOutButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.signOutButton.transform = self.signOutButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        authModel.signOut { success in
            if success {
                UserDefaults.standard.set(false, forKey: "userLoggedIn")
                UserDefaults.standard.removeObject(forKey: "userID")
                let mainScreenViewController = MainScreenViewController()
                self.navigationController?.pushViewController(mainScreenViewController, animated: true)
            }
        }
    }
}
