//
//  PhotosCollectionViewCell.swift
//  Memories
//
//  Created by Данил Швец on 07.06.2023.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "PhotosCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: bounds.width - 10.0).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
//        imageView.image = UIImage(named: "customCellBackgroundImage")
        addShadowTo(myView: imageView)
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
    }
    
    private func addShadowTo(myView: UIView) {
        myView.clipsToBounds = false
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowPath = UIBezierPath(roundedRect: myView.bounds, cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowOffset = CGSize.zero
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 5.0
    }
    
    func fillCellWith(image: UIImage?) {
        imageView.image = image ?? UIImage(named: "")
    }
    
    func configureDeleteButton() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deleteButton)
        deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 15.0).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15.0).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor).isActive = true
    }
    
    func deleteImage() {
        imageView.image = UIImage(named: "")
    }
    
    @objc func deleteButtonPressed() {
        deleteImage()
    }
}
