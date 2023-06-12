//
//  LogInViewController.swift
//  Memories
//
//  Created by Данил Швец on 09.06.2023.
//

import UIKit
import AuthenticationServices

final class LogInViewController: UIViewController {
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "addMemoryButtonColor")
        button.setTitle("Add photos", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLogInButton()
    }
    
    private func configureLogInButton() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logInButton)
        logInButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logInButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.2).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logInButton.layer.cornerRadius = 30
        addShadowTo(myView: logInButton)
    }
    
   
    private func addShadowTo(myView: UIView) {
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowPath = UIBezierPath(roundedRect: myView.bounds, cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 5.0
    }
    
    
    @objc func logInButtonPressed() {
        print("Login")
    }
}
