//
//  UserTableViewCell.swift
//  Memories
//
//  Created by Данил Швец on 18.06.2023.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let tableViewCellIdentifier = "UserTableViewCell"
    
    private struct UIConstants {
        static let padding: CGFloat = 10
    }
    
    private lazy var customView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20.0
        view.clipsToBounds = true
        return view
    }()
    private lazy var tableViewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35.0)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "backgroundColor")
        configureCustomView()
        configureTableViewImage()
        configureUsernameLabelLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomView() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = UIColor(named: "tableViewCellBackgroundColor")
        addSubview(customView)
        customView.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.padding).isActive = true
        customView.rightAnchor.constraint(equalTo: rightAnchor, constant: -UIConstants.padding).isActive = true
        customView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UIConstants.padding).isActive = true
        customView.leftAnchor.constraint(equalTo: leftAnchor, constant: UIConstants.padding).isActive = true
    }
    
    private func configureTableViewImage() {
        tableViewImage.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(tableViewImage)
        tableViewImage.backgroundColor = .lightGray.withAlphaComponent(0.3)
        tableViewImage.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: UIConstants.padding).isActive = true
        tableViewImage.topAnchor.constraint(equalTo: customView.topAnchor, constant: UIConstants.padding).isActive = true
        tableViewImage.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -UIConstants.padding).isActive = true
        tableViewImage.widthAnchor.constraint(equalTo: tableViewImage.heightAnchor).isActive = true
        tableViewImage.layer.cornerRadius = 20.0
        tableViewImage.clipsToBounds = true
    }
    
    private func configureUsernameLabelLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(usernameLabel)
        usernameLabel.leftAnchor.constraint(equalTo: tableViewImage.rightAnchor, constant: UIConstants.padding).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -UIConstants.padding).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func fillCellWithData(url: URL?, title: String) {
        guard let imageUrl = url else { return }
        tableViewImage.kf.setImage(with: imageUrl)
        usernameLabel.text = title
    }

}

