//
//  UserProfileViewController.swift
//  Memories
//
//  Created by Данил Швец on 13.06.2023.
//

import UIKit
import PhotosUI
import CoreData

final class UserProfileViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 30
        static let cornerRadius: CGFloat = 20
        static let buttonHeight: CGFloat = 40
        static let skipButtonWidth: CGFloat = 65
    }
    
    private lazy var frc: NSFetchedResultsController<MemoryDatabase> = {
        let fr = MemoryDatabase.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(key: #keyPath(MemoryDatabase.memoryDate), ascending: false)]
        let frc =  NSFetchedResultsController<MemoryDatabase>(fetchRequest: fr, managedObjectContext: databaseManager.mainQueueContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    private var profileImage = UIImage(systemName: "person.crop.circle")
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(changePhotoButtonPressed), for: .touchUpInside)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    private lazy var usernameLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.font = .systemFont(ofSize: 30)
        title.textColor = .gray
        return title
    }()
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
        button.setTitle("Sign out", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    private let databaseManager: DataManager = DataManager.shared
    private let uploadDataModel = UploadDataModel()
    private let downloadDataModel = DownloadDataModel()
    private let authModel = AuthModel()
    var myProfile = false
    var username = ""
    var userID = ""
    
    
    // MARK: - override методы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        self.title = "PROFILE"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureProfileImageView()
        configureProfileImage()
        if myProfile {
            configureSignOutButton()
            configureChangePhotoButton()
        } else {
            configureUsernameLabel()
        }
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.backgroundColor = .systemGray5
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2*UIConstants.padding).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        profileImageView.layer.cornerRadius = UIConstants.cornerRadius
        profileImageView.clipsToBounds = true
    }
    
    private func configureUsernameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        usernameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: UIConstants.padding).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        if username != "" {
            usernameLabel.text = "@\(username)"
        }
        usernameLabel.textAlignment = .center
        usernameLabel.backgroundColor = .clear
    }
    
    private func configureChangePhotoButton() {
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changePhotoButton)
        changePhotoButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: UIConstants.padding).isActive = true
        changePhotoButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        changePhotoButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        changePhotoButton.layer.cornerRadius = UIConstants.cornerRadius
        changePhotoButton.backgroundColor = UIColor(named: "addMemoryButtonColor")?.withAlphaComponent(0.7)
        addShadowTo(myView: changePhotoButton)
        changePhotoButton.setTitle("Change photo", for: .normal)
        changePhotoButton.setImage(UIImage(systemName: "camera"), for: .normal)
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
        if myProfile {
            guard let myProfileImage = UserDefaults.standard.data(forKey: "myProfileImage") else {
                downloadImage()
                saveImage()
                return
            }
            profileImageView.image = UIImage(data: myProfileImage)
        } else {
            downloadImage()
        }
    }
    
    
    // MARK: - Обновление данных
    
    private func downloadImage() {
        if myProfile {
            guard let myUserID = UserDefaults.standard.string(forKey: "userID") else {return}
            downloadDataModel.downloadUserProfileImage(uid: myUserID) { url in
                self.profileImageView.kf.setImage(with: url)
            }
        } else {
            downloadDataModel.downloadUserProfileImage(uid: userID) { url in
                self.profileImageView.kf.setImage(with: url)
            }
        }
        
    }
    
    private func saveImage() {
        UserDefaults.standard.set(profileImageView.image?.jpegData(compressionQuality: 1.0), forKey: "myProfileImage")
    }
    
    private func updateImageInFirebase() {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {return}
        uploadDataModel.sendProfileImageToFirebase(uid: userID, photo: (profileImage?.jpegData(compressionQuality: 1.0))!) { _ in
            let alert = UIAlertController(title: "Alert", message: "No connection. Please try later", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - @objc методы
    
    @objc private func changePhotoButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.changePhotoButton.transform = self.changePhotoButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.changePhotoButton.transform = self.changePhotoButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        var config = PHPickerConfiguration()
        config.filter = .images
        let photoPickerViewController = PHPickerViewController(configuration: config)
        photoPickerViewController.delegate = self
        self.present(photoPickerViewController, animated: true)
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
                self.databaseManager.deleteAllEntities()
                try? self.frc.performFetch()
                UserDefaults.standard.set(false, forKey: "userLoggedIn")
                UserDefaults.standard.removeObject(forKey: "userID")
                UserDefaults.standard.removeObject(forKey: "myProfileImage")
                let mainScreenViewController = MainScreenViewController()
                self.navigationController?.pushViewController(mainScreenViewController, animated: true)
            }
        }
    }
}


// MARK: - Photo picker

extension UserProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.profileImage = image
                        self.profileImageView.image = self.profileImage
                        self.saveImage()
                        self.updateImageInFirebase()
                    }
                }
            }
        }
    }
}

extension UserProfileViewController: NSFetchedResultsControllerDelegate {
}
