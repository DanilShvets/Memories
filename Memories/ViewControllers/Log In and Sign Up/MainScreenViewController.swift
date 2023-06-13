//
//  MainScreenViewController.swift
//  Memories
//
//  Created by Данил Швец on 12.06.2023.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    private struct UIConstants {
        static let titleLabelFontSize: CGFloat = 50
        static let titleLabelHeight: CGFloat = 60
        static let labelFontSize: CGFloat = 24
        static let labelHeight: CGFloat = 30
        static let loginButtonFontSize: CGFloat = 25
        static let loginButtonSize: CGFloat = 56
        static let loginButtonCornerRadius: CGFloat = 28
        static let padding: CGFloat = 40
    }
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .left
        title.font = .boldSystemFont(ofSize: UIConstants.titleLabelFontSize)
        return title
    }()
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "loginButtonColor")
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor(red: 0.13, green: 0.21, blue: 0.33, alpha: 1.00), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: UIConstants.loginButtonFontSize)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 0.13, green: 0.21, blue: 0.33, alpha: 1.00), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: UIConstants.loginButtonFontSize)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignBackgroundWith(imageName: "mainScreenBackground")
        configureTitleLabel()
        configureSignUpButton()
        configureLogInButton()
    }
    
    private func assignBackgroundWith(imageName: String){
        let background = UIImage(named: imageName)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.padding/2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: UIConstants.titleLabelHeight).isActive = true
        titleLabel.text = "MEMORIES"
    }
    
    private func configureSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.5).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: UIConstants.loginButtonSize).isActive = true
        signUpButton.layer.cornerRadius = UIConstants.loginButtonCornerRadius
//        addShadowTo(myView: signUpButton)
    }
    
    private func configureLogInButton() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logInButton)
        logInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -UIConstants.padding).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.5).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: UIConstants.loginButtonSize).isActive = true
        logInButton.layer.cornerRadius = UIConstants.loginButtonCornerRadius
//        addShadowTo(myView: logInButton)
    }
    
    private func addShadowTo(myView: UIView) {
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor(named: "loginButtonColor")?.cgColor
        myView.layer.shadowPath = UIBezierPath(roundedRect: myView.bounds, cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 5.0
    }
    
    @objc func logInButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.logInButton.transform = self.logInButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.logInButton.transform = self.logInButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let logInViewController = LogInViewController()
            self.navigationController?.pushViewController(logInViewController, animated: true)
        }
    }
    
    @objc func signUpButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.signUpButton.transform = self.signUpButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.signUpButton.transform = self.signUpButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let signUpViewController = SignUpViewController()
            self.navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
}
