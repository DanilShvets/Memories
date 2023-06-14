//
//  SetProfileImageViewController.swift
//  Memories
//
//  Created by Данил Швец on 14.06.2023.
//

import UIKit
import PhotosUI

final class SetProfileImageViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 30
        static let cornerRadius: CGFloat = 20
        static let buttonHeight: CGFloat = 40
        static let skipButtonWidth: CGFloat = 65
    }
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.tintColor = .systemGray5
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        return button
    }()
    private var profileImage = UIImage(named: "customCellBackgroundImage")
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addPhotoButtonPressed), for: .touchUpInside)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    private let uploadDataModel = UploadDataModel()
    var username = ""
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureSkipButton()
        configureProfileImageView()
        configureAddPhotoButton()
        configureSaveButton()
    }
    
    private func configureSkipButton() {
//        skipButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(skipButton)
//        skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        skipButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
//        skipButton.widthAnchor.constraint(equalToConstant: UIConstants.skipButtonWidth).isActive = true
//        skipButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray3
    }
    
    private func configureProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2*UIConstants.padding).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .systemGray5
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
//        profileImageView.isUserInteractionEnabled = true
//        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureAddPhotoButton() {
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotoButton)
        addPhotoButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        addPhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: UIConstants.padding).isActive = true
        addPhotoButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.5).isActive = true
        addPhotoButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        addPhotoButton.layer.cornerRadius = UIConstants.cornerRadius
        addPhotoButton.backgroundColor = UIColor(named: "addMemoryButtonColor")?.withAlphaComponent(0.7)
        addShadowTo(myView: addPhotoButton)
        addPhotoButton.setTitle("Add photo", for: .normal)
        addPhotoButton.setImage(UIImage(systemName: "camera"), for: .normal)
    }
    
    private func configureSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.5).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        saveButton.layer.cornerRadius = UIConstants.cornerRadius
        saveButton.backgroundColor = UIColor(named: "saveButtonColor")?.withAlphaComponent(0.7)
        addShadowTo(myView: saveButton)
    }
    
    private func addShadowTo(myView: UIView) {
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowPath = UIBezierPath(roundedRect: myView.bounds, cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 5.0
    }
    
    private func presentMainScreen() {
        uploadDataModel.sendProfileDataToFirebase(uid: userID, username: username)
        uploadDataModel.sendProfileImageToFirebase(uid: userID, photo: (profileImage?.jpegData(compressionQuality: 1.0))!)
        let tabBarController = TabBarController()
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    private func saveImage() {
        
    }
    
    @objc private func addPhotoButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.addPhotoButton.transform = self.addPhotoButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.addPhotoButton.transform = self.addPhotoButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        var config = PHPickerConfiguration()
        config.filter = .images
        let photoPickerViewController = PHPickerViewController(configuration: config)
        photoPickerViewController.delegate = self
        self.present(photoPickerViewController, animated: true)
    }
    
    @objc private func saveButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.saveButton.transform = self.saveButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.saveButton.transform = self.saveButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        presentMainScreen()
    }
    
    @objc private func skipButtonPressed() {
        presentMainScreen()
    }
    
    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        newImageView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        newImageView.addGestureRecognizer(swipeDown)
        
        UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: { self.view.addSubview(newImageView) }, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func dismissFullScreenImage(_ sender: UISwipeGestureRecognizer) {
        let swipeGesture = sender
        switch swipeGesture.direction {
        case .down:
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {sender.view?.removeFromSuperview() }, completion: nil)
        case .up:
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve], animations: {sender.view?.removeFromSuperview() }, completion: nil)
        default:
            break
        }
    }
}

extension SetProfileImageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.profileImage = image
                        self.profileImageView.image = self.profileImage
                        self.saveButton.isHidden = false
                    }
                }
            }
        }
    }
}

