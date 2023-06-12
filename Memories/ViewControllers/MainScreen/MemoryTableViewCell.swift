//
//  MemoryTableViewCell.swift
//  Memories
//
//  Created by Данил Швец on 08.06.2023.
//

import UIKit

class MemoryTableViewCell: UITableViewCell {
    
    static let tableViewCellIdentifier = "MemoryTableViewCell"
    
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
    private lazy var memoryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35.0)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCustomView()
        configureTableViewImage()
        configureMemoryTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        configureTableViewImage()
//        configureMemoryTitleLabel()
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    private func configureCustomView() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.backgroundColor = UIColor(named: "tableViewCellBackgroundColor")
        addSubview(customView)
        customView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        customView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        customView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        customView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
    }
    
    private func configureTableViewImage() {
        tableViewImage.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(tableViewImage)
        tableViewImage.backgroundColor = .lightGray.withAlphaComponent(0.3)
        tableViewImage.leftAnchor.constraint(equalTo: customView.leftAnchor, constant: 10).isActive = true
        tableViewImage.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10).isActive = true
        tableViewImage.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -10).isActive = true
        tableViewImage.widthAnchor.constraint(equalTo: tableViewImage.heightAnchor).isActive = true
        tableViewImage.layer.cornerRadius = 20.0
        tableViewImage.clipsToBounds = true
    }
    
    private func configureMemoryTitleLabel() {
        memoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(memoryTitleLabel)
        memoryTitleLabel.leftAnchor.constraint(equalTo: tableViewImage.rightAnchor, constant: 10).isActive = true
        memoryTitleLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10).isActive = true
        memoryTitleLabel.rightAnchor.constraint(equalTo: customView.rightAnchor, constant: -10).isActive = true
        memoryTitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func fillCellWithData(image: Data, title: String) {
        tableViewImage.image = UIImage(data: image)
        memoryTitleLabel.text = title
    }

}
