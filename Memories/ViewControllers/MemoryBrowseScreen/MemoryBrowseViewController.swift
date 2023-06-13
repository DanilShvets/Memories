//
//  MemoryBrowseViewController.swift
//  Memories
//
//  Created by Данил Швец on 08.06.2023.
//

import UIKit
import CoreData

final class MemoryBrowseViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 15
        static let cornerRadius: CGFloat = 20
        static let pageControllerHeight: CGFloat = 25
        static let titlesHeight: CGFloat = 50
    }
    
    var currentMemoryObjectID = NSManagedObjectID()
    private let databaseManager: DataManager = DataManager.shared
    private lazy var imagesArray = [UIImage]()
    var memoryData: MemoryDatabase?
    private lazy var memoryDate = Date()
    private lazy var memoryTitle = ""
    
    private lazy var imageView: UIView = {
        let imageView = UIView()
        return imageView
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let sizeCell = CGSize(width: view.bounds.width / 1.5, height: view.bounds.width / 1.5)
        layout.itemSize = sizeCell
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.cellIdentifier)
        return collection
    }()
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.backgroundColor = .lightGray.withAlphaComponent(0.7)
        pageControl.currentPageIndicatorTintColor = UIColor(named: "addMemoryButtonColor")
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    private lazy var memoryTitleLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    private lazy var memoryDateLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        configureData()
        setUpNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureImageView()
        configureCollectionView()
        configurePageControl()
        configureTitleLabel()
        configureDateLabel()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
//            //                self.tabBarController?.tabBar.alpha = 1.0
//            if let tabBarFrame = self.tabBarController?.tabBar.frame {
//                self.tabBarController?.tabBar.frame.origin.y = self.view.bounds.height + tabBarFrame.height
//            }
//        }, completion: { (finished: Bool) -> Void in
//            self.tabBarController?.tabBar.isUserInteractionEnabled = true
//        })
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if self.isMovingFromParent {
//            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
////                self.tabBarController?.tabBar.alpha = 1.0
//                if let tabBarFrame = self.tabBarController?.tabBar.frame {
//                    self.tabBarController?.tabBar.frame.origin.y = self.view.bounds.height - tabBarFrame.height
//                }
//            }, completion: { (finished: Bool) -> Void in
//                self.tabBarController?.tabBar.isUserInteractionEnabled = true
//            })
//        }
//    }
    
    private func setUpNavBar() {
        self.navigationController?.view.tintColor = UIColor(named: "addMemoryButtonColor")
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func configureData() {
        let imagesInCoreData = [memoryData?.memoryImage0, memoryData?.memoryImage1, memoryData?.memoryImage2, memoryData?.memoryImage3, memoryData?.memoryImage4, memoryData?.memoryImage5, memoryData?.memoryImage6, memoryData?.memoryImage7, memoryData?.memoryImage8, memoryData?.memoryImage9]
        var numberOfImages = 0
        imagesInCoreData.forEach { data in
            guard let data = data else {return}
            if data.count != 0 {
                numberOfImages += 1
            }
        }
        for i in 0..<numberOfImages {
            imagesArray.append(UIImage(data: imagesInCoreData[i]!)!)
        }
        let memoryTitle: String = memoryData?.memoryTitle ?? ""
        memoryTitleLabel.text = memoryTitle
        let memoryDate: String = formatDate(date: memoryData?.memoryDate ?? Date())
        memoryDateLabel.text = memoryDate
    }
    
    private func formatDate(date: Date) -> String {
        memoryDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.padding).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.5).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        imageView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: imageView.leftAnchor).isActive = true
    }
    
    private func configurePageControl(){
        imageView.addSubview(pageControl)
        pageControl.numberOfPages = imagesArray.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -UIConstants.padding).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: UIConstants.pageControllerHeight).isActive = true
        pageControl.layer.cornerRadius = UIConstants.pageControllerHeight / 2
        pageControl.clipsToBounds = true
        if imagesArray.count < 2 {
            pageControl.isHidden = true
        }
    }
    
    private func configureTitleLabel() {
        memoryTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(memoryTitleLabel)
        memoryTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        memoryTitleLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: UIConstants.padding).isActive = true
        memoryTitleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        memoryTitleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        memoryTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: UIConstants.titlesHeight).isActive = true
        memoryTitleLabel.font = .boldSystemFont(ofSize: 40.0)
    }
    
    private func configureDateLabel() {
        memoryDateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(memoryDateLabel)
        memoryDateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        memoryDateLabel.topAnchor.constraint(equalTo: memoryTitleLabel.bottomAnchor, constant: UIConstants.padding).isActive = true
        memoryDateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        memoryDateLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        memoryDateLabel.heightAnchor.constraint(equalToConstant: UIConstants.titlesHeight).isActive = true
        memoryDateLabel.font = .systemFont(ofSize: 25.0)
        memoryDateLabel.textColor = .gray
    }
}


extension MemoryBrowseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.isEmpty ? 1 : imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.cellIdentifier, for: indexPath) as? PhotosCollectionViewCell else { return .init() }
        
        if !imagesArray.isEmpty {
            cell.fillCellWith(image: imagesArray[indexPath.row])
        } else {
            cell.fillCellWith(image: UIImage(named: "customCellBackgroundImage"))
        }
        
        return cell
    }
}

extension MemoryBrowseViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosition = scrollView.contentOffset.x / imageView.frame.width
        pageControl.currentPage = Int(scrollPosition)
    }
}
