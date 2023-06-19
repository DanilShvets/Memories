//
//  MemoryCollectionViewCell.swift
//  Memories
//
//  Created by Данил Швец on 19.06.2023.
//

import UIKit

class MemoryCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "MemoryCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        imageView.widthAnchor.constraint(equalToConstant: bounds.width - 20.0).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
//        imageView.image = UIImage(named: "customCellBackgroundImage")
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
    }
    
    func fillCellWithData(url: URL?) {
        guard let imageUrl = url else { return }
        imageView.kf.setImage(with: imageUrl)
    }
}
