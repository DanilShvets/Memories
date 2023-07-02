//
//  MemoriesCollectionViewController.swift
//  Memories
//
//  Created by Данил Швец on 19.06.2023.
//

import UIKit

final class MemoriesCollectionViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 15
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let sizeCell = CGSize(width: view.bounds.width / 2, height: view.bounds.width / 2)
        layout.itemSize = sizeCell
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collection.delegate = self
        collection.dataSource = self
        collection.register(MemoryCollectionViewCell.self, forCellWithReuseIdentifier: MemoryCollectionViewCell.cellIdentifier)
        return collection
    }()
    
    private var numberOfCells = 0
    private var memoryIDs = [String]()
    private var memoryDataModel = MemoryDataModel()
    private var downloadDataModel = DownloadDataModel()
    
    var userID = ""
    var username = ""
    
    
    // MARK: - override метод
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        self.title = "@\(username)"
        DispatchQueue.global(qos: .default).async {
            self.memoryDataModel.getMemoryInfo(userID: self.userID) { memories, memoryIDs in
                self.numberOfCells = memories.count
                self.memoryIDs = memoryIDs
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionView()
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
    
}


// MARK: - работа с коллекцией

extension MemoriesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCollectionViewCell.cellIdentifier, for: indexPath) as? MemoryCollectionViewCell else { return .init() }
        
        downloadDataModel.downloadMemoryMainImage(userID: userID, memoryID: memoryIDs[indexPath.row]) { url in
            cell.fillCellWithData(url: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memoryBrowseViewController = MemoryBrowseViewController()
        memoryBrowseViewController.isMyMemory = false
        memoryBrowseViewController.userID = userID
        memoryBrowseViewController.memoryID = memoryIDs[indexPath.row]
        navigationController?.pushViewController(memoryBrowseViewController, animated: true)
        for cell in collectionView.visibleCells {
            cell.isSelected = false
        }
    }
}
