//
//  SignUpViewController.swift
//  Memories
//
//  Created by Данил Швец on 13.06.2023.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    private struct UIConstants {
//        static let titleLabelFontSize: CGFloat = 50
//        static let titleLabelHeight: CGFloat = 60
        static let labelFontSize: CGFloat = 24
        static let labelHeight: CGFloat = 30
        static let loginButtonFontSize: CGFloat = 18
        static let loginButtonSize: CGFloat = 44
        static let loginButtonCornerRadius: CGFloat = 22
        static let padding: CGFloat = 40
        static let customViewPadding: CGFloat = 20
        static let paddingBetweenLabelAndTextfield: CGFloat = 10
        static let textFieldCornerRadius: CGFloat = 20
        static let textFieldHeight: CGFloat = 55
        static let cornerRadius: CGFloat = 20
        static let keyboardMove: CGFloat = 90
    }
    
//    private lazy var titleLabel: UILabel = {
//        let title = UILabel()
//        title.numberOfLines = 0
//        title.textAlignment = .left
//        title.font = .boldSystemFont(ofSize: UIConstants.titleLabelFontSize)
//        return title
//    }()
    private lazy var customView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "loginBackgroundColor")
        return view
    }()
    private lazy var usernameLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .left
        title.font = .systemFont(ofSize: UIConstants.labelFontSize, weight: .semibold)
        return title
    }()
    private lazy var usernameTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.font = .systemFont(ofSize: 20)
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
//        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.delegate = self
        textField.backgroundColor = UIColor(named: "loginTextFields")
        return textField
    }()
    private lazy var emailLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .left
        title.font = .systemFont(ofSize: UIConstants.labelFontSize, weight: .semibold)
        return title
    }()
    private lazy var emailTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.font = .systemFont(ofSize: 20)
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
//        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.delegate = self
        textField.backgroundColor = UIColor(named: "loginTextFields")
        return textField
    }()
    private lazy var passwordLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .left
        title.font = .systemFont(ofSize: UIConstants.labelFontSize, weight: .semibold)
        return title
    }()
    private lazy var passwordTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.font = .systemFont(ofSize: 20)
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .never
        textField.isSecureTextEntry = true
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.delegate = self
        textField.backgroundColor = UIColor(named: "loginTextFields")
        return textField
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
    private let logInModel = AuthModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        self.hideKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationItem.hidesBackButton = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assignBackgroundWith(imageName: "loginBackground")
//        configureTitleLabel()
        configureCustomView()
        configureUsernameLabel()
        configureUsernameTextField()
        configureEmailLabel()
        configureEmailTextField()
        configurePasswordLabel()
        configurePasswordTextField()
        configureSignUpButton()
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
    
    private func setUpNavBar() {
//        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor(named: "addMemoryButtonColor")
//        self.navigationItem.title = "About Us"

        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func configureCustomView() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView)
        customView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2*UIConstants.padding).isActive = true
        customView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        customView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIConstants.cornerRadius).isActive = true
        customView.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    private func configureUsernameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(usernameLabel)
        usernameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: UIConstants.customViewPadding).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: UIConstants.customViewPadding).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -UIConstants.customViewPadding).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight).isActive = true
        usernameLabel.text = "USERNAME"
    }
    
    private func configureUsernameTextField() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(usernameTextField)
        usernameTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: UIConstants.paddingBetweenLabelAndTextfield).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: UIConstants.customViewPadding).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -UIConstants.customViewPadding).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight).isActive = true
        usernameTextField.layer.cornerRadius = UIConstants.textFieldCornerRadius
    }
    
    private func configureEmailLabel() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(emailLabel)
        emailLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: UIConstants.customViewPadding).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: UIConstants.customViewPadding).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -UIConstants.customViewPadding).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight).isActive = true
        emailLabel.text = "EMAIL"
    }
    
    private func configureEmailTextField() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(emailTextField)
        emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: UIConstants.paddingBetweenLabelAndTextfield).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: UIConstants.customViewPadding).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -UIConstants.customViewPadding).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight).isActive = true
        emailTextField.layer.cornerRadius = UIConstants.textFieldCornerRadius
    }
    
    private func configurePasswordLabel() {
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(passwordLabel)
        passwordLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: UIConstants.customViewPadding).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: UIConstants.customViewPadding).isActive = true
        passwordLabel.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -UIConstants.customViewPadding).isActive = true
        passwordLabel.heightAnchor.constraint(equalToConstant: UIConstants.labelHeight).isActive = true
        passwordLabel.text = "PASSWORD"
    }
    
    private func configurePasswordTextField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(passwordTextField)
        passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: UIConstants.paddingBetweenLabelAndTextfield).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: UIConstants.customViewPadding).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -UIConstants.customViewPadding).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight).isActive = true
        passwordTextField.layer.cornerRadius = UIConstants.textFieldCornerRadius
    }
    
    private func configureSignUpButton() {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(signUpButton)
        signUpButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: UIConstants.padding).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: UIConstants.loginButtonSize).isActive = true
        signUpButton.layer.cornerRadius = UIConstants.loginButtonCornerRadius
        addShadowTo(myView: signUpButton)
    }
    
   
    private func addShadowTo(myView: UIView) {
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowPath = UIBezierPath(roundedRect: myView.bounds, cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 5.0
    }
    
    
    @objc func signUpButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.signUpButton.transform = self.signUpButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.signUpButton.transform = self.signUpButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.logInModel.createNewUser(username: self.usernameTextField.text, email: self.emailTextField.text, password: self.passwordTextField.text) { result, error in
                if error == "" {
                    let setProfileImageViewController = SetProfileImageViewController()
                    self.navigationController?.pushViewController(setProfileImageViewController, animated: true)
                    setProfileImageViewController.username = self.usernameTextField.text!
                    setProfileImageViewController.userID = result
                } else {
                    let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension SignUpViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= UIConstants.keyboardMove
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
