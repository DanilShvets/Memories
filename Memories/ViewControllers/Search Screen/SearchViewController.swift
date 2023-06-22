//
//  SearchViewController.swift
//  Memories
//
//  Created by Данил Швец on 18.06.2023.
//

import UIKit
import Kingfisher

final class SearchViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 15
        static let textFieldCornerRadius: CGFloat = 20
        static let textFieldHeight: CGFloat = 55
        static let cellHeight: CGFloat = 150
    }
    
    private lazy var searchTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.font = .systemFont(ofSize: 20)
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.delegate = self
        textField.backgroundColor = UIColor(named: "textFieldBackgroundColor")
        textField.placeholder = "Search by full username..."
        let searchImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchImage.image = UIImage(systemName: "magnifyingglass")
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 55))
        iconContainerView.addSubview(searchImage)
        searchImage.center = iconContainerView.center
        textField.leftView = iconContainerView
        textField.leftViewMode = .always
        searchImage.tintColor = .lightGray
        return textField
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.tableViewCellIdentifier)
        return tableView
    }()
    private let userDataModel = UserDataModel()
    private let downloadDataModel = DownloadDataModel()
    private var userID = ""
    private var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        hideKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureSearchTextField()
    }
    
    private func configureSearchTextField() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.padding).isActive = true
        searchTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight).isActive = true
        searchTextField.layer.cornerRadius = UIConstants.textFieldCornerRadius
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: UIConstants.padding).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text!
        if text != "" {
            configureTableView()
            userDataModel.getUserID(username: text) { result in
                self.userID = result
                self.tableView.reloadData()
            }
        } else {
            username = ""
            userID = ""
            tableView.reloadData()
            tableView.removeFromSuperview()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.tableViewCellIdentifier, for: indexPath) as? UserTableViewCell else {return .init()}
        userDataModel.getUsername(uid: self.userID) { result in
            self.username = result
        }
        downloadDataModel.downloadUserProfileImage(uid: userID) { url in
            cell.fillCellWithData(url: url, title: self.username)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoriesCollectionViewController = MemoriesCollectionViewController()
        memoriesCollectionViewController.userID = userID
        memoriesCollectionViewController.username = username
        navigationController?.pushViewController(memoriesCollectionViewController, animated: true)
        for cell in tableView.visibleCells {
            cell.setSelected(false, animated: true)
        }
    }
}
