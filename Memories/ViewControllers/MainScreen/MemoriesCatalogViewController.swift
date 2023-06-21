//
//  MemoriesCatalogViewController.swift
//  Memories
//
//  Created by Данил Швец on 06.06.2023.
//

import UIKit
import CoreData

class MemoriesCatalogViewController: UIViewController {
    
    private struct UIConstants {
        static let buttonSize: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 25
        static let buttonPadding: CGFloat = 35
        static let padding: CGFloat = 20
        static let imageSize: CGFloat = 50
    }
    
    private var hintsAreShown = false
    private var numberOfObjectsInDatabase = 0
    private lazy var emptyDatabaseTitleLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    private lazy var emptyDatabaseLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    private lazy var hintForEditMemoryLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    private lazy var imageViewEditMemory: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var hintForDeleteMemoryLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    private lazy var imageViewDeleteMemory: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var viewForArrow = UIView()
    private lazy var addMemoryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addMemoryButtonPressed), for: .touchUpInside)
        return button
    }()
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.buttonSize, weight: .semibold, scale: .small)
    private lazy var dataObjectsIDDictionary = [Int: NSManagedObjectID]()
    private lazy var frc: NSFetchedResultsController<MemoryDatabase> = {
        let fr = MemoryDatabase.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(key: #keyPath(MemoryDatabase.memoryDate), ascending: false)]
        let frc =  NSFetchedResultsController<MemoryDatabase>(fetchRequest: fr, managedObjectContext: databaseManager.mainQueueContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.register(MemoryTableViewCell.self, forCellReuseIdentifier: MemoryTableViewCell.tableViewCellIdentifier)
        return tableView
    }()
    
    private let databaseManager: DataManager = DataManager.shared
    private let databaseName = "MemoryDatabase"
    private var memoryData: MemoryDatabase?
    private var shouldFetchData = false
    private var uploadDataModel = UploadDataModel()
    private var memoryDataModel = MemoryDataModel()
    private var downloadDataModel = DownloadDataModel()
    var userID = ""
    private lazy var firebaseMemoryIDsArray = Set<String>()
    private lazy var coreDataMemoryIDsArray = Set<String>()
    private lazy var imagesArray = [UIImage]()
    private lazy var mainImage = UIImage()
    private lazy var memoryDate = Date()
    private lazy var memoryTitle = ""
    private lazy var memoryID = ""
    private lazy var memories = [[String : AnyObject]]()
    private lazy var currentNumberOfMemoriesInFirebase = 0
    private lazy var counterForDownload = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        userID = UserDefaults.standard.value(forKey: "userID") as! String
        print("userID:\(userID)")
        view.backgroundColor = UIColor(named: "backgroundColor")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.title = "MEMORIES"
        updateTableView()
        numberOfObjectsInDatabase = frc.fetchedObjects?.count ?? 0
//        getNumberOfMemoriesInFirebase()
        updateFromFirebase()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
        configureTableView(fullScreen: true)
        if numberOfObjectsInDatabase < 1 {
            configureEmptyDatabaseTitleLabel()
            configureEmptyDatabaseLabel()
        }
        configureAddMemoryButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.timer?.invalidate()
        }
        counterForDownload = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
        try? frc.performFetch()
        
//        updateFromFirebase()
        
//        if numberOfObjectsInDatabase < 1 {
//            configureEmptyDatabaseTitleLabel()
//            configureEmptyDatabaseLabel()
//        }
        
        saveButtonPressed()
        print("shouldFetchData: \(shouldFetchData)")
        if shouldFetchData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.tableView.reloadData()
            }
            shouldFetchData = false
        }
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.timerMethod), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        if numberOfObjectsInDatabase == 0 {
            emptyDatabaseTitleLabel.removeFromSuperview()
            emptyDatabaseLabel.removeFromSuperview()
        }
        if !hintsAreShown && numberOfObjectsInDatabase > 0 {
            imageViewEditMemory.removeFromSuperview()
            hintForEditMemoryLabel.removeFromSuperview()
            imageViewDeleteMemory.removeFromSuperview()
            hintForDeleteMemoryLabel.removeFromSuperview()
            hintsAreShown = true
        }
    }
    
    func updateTableView() {
        try? frc.performFetch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.tableView.reloadData()
        }
    }
    
//    private func getNumberOfMemoriesInFirebase() {
//        DispatchQueue.global(qos: .default).async {
//            self.memoryDataModel.getMemoryInfo(userID: self.userID) { memories, memoryIDs in
//                self.currentNumberOfMemoriesInFirebase = memoryIDs.count
//                print("currentNumberOfMemoriesInFirebase: \(self.currentNumberOfMemoriesInFirebase)")
//            }
//        }
//
//    }
    
    private func updateFromFirebase() {
        frc.fetchedObjects!.forEach { memory in
            coreDataMemoryIDsArray.insert(memory.memoryID!)
        }
        DispatchQueue.global(qos: .background).async {
            var innerSet = Set<String>()
            self.memoryDataModel.getMemoryInfo(userID: self.userID) { memories, memoryIDs in
                memoryIDs.forEach { id in
                    innerSet.insert(id)
//                    self.firebaseMemoryIDsArray.insert(id)
                }
                self.firebaseMemoryIDsArray = innerSet
                self.currentNumberOfMemoriesInFirebase = self.firebaseMemoryIDsArray.count
            }
        }
    }
    
    private func downloadData(counter: Int) {
        if !self.firebaseMemoryIDsArray.isEmpty {
            let innerArray = Array(self.firebaseMemoryIDsArray)
            let item = innerArray[counter]
            
            print("itemID:\(item)")
            print("FirebaseItemID:\(innerArray[counter])")
            print("coreDataMemoryIDsArray:\(self.coreDataMemoryIDsArray)")
            print("firebaseMemoryIDsArray:\(self.firebaseMemoryIDsArray)")
            
            DispatchQueue.global(qos: .background).async {
                if !self.coreDataMemoryIDsArray.contains(item) {
                    self.databaseManager.create(with: self.databaseName) { memory in
                        print("creating memory")
                        guard let memory = memory as? MemoryDatabase else { return }
                        self.saveOrUpdateDataFor(item: item, memory: memory)
                        sleep(2)
                        print("clearing imagesArray")
                        DispatchQueue.main.async {
                            self.imagesArray.removeAll()
                            self.coreDataMemoryIDsArray.insert(item)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    private func configureAddMemoryButton() {
        addMemoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addMemoryButton)
        addMemoryButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.buttonPadding).isActive = true
        addMemoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.buttonPadding).isActive = true
        addMemoryButton.widthAnchor.constraint(equalToConstant: UIConstants.buttonSize).isActive = true
        addMemoryButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonSize).isActive = true
        addMemoryButton.clipsToBounds = true
        addMemoryButton.layer.cornerRadius = UIConstants.buttonCornerRadius
        
        let addMemoryButtonImage = UIImage(systemName: "plus", withConfiguration: largeConfig)
        addMemoryButton.setImage(addMemoryButtonImage, for: .normal)
        addMemoryButton.backgroundColor = UIColor(named: "addMemoryButtonColor")
        addMemoryButton.tintColor = .white
        
        addMemoryButton.layer.masksToBounds = false
        addMemoryButton.layer.cornerRadius = addMemoryButton.frame.height/2
        addMemoryButton.layer.shadowColor = UIColor.gray.cgColor
        addMemoryButton.layer.shadowPath = UIBezierPath(roundedRect: addMemoryButton.bounds, cornerRadius: addMemoryButton.layer.cornerRadius).cgPath
        addMemoryButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        addMemoryButton.layer.shadowOpacity = 0.5
        addMemoryButton.layer.shadowRadius = 7.0
    }
    
    private func configureEmptyDatabaseTitleLabel() {
        emptyDatabaseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyDatabaseTitleLabel)
        emptyDatabaseTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyDatabaseTitleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -2*UIConstants.padding).isActive = true
        emptyDatabaseTitleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        emptyDatabaseTitleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        emptyDatabaseTitleLabel.font = .boldSystemFont(ofSize: 40.0)
        emptyDatabaseTitleLabel.text = "There are no memories"
        emptyDatabaseTitleLabel.layer.zPosition = 10
    }
    
    private func configureEmptyDatabaseLabel() {
        emptyDatabaseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyDatabaseLabel)
        emptyDatabaseLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyDatabaseLabel.topAnchor.constraint(equalTo: emptyDatabaseTitleLabel.bottomAnchor, constant: UIConstants.padding).isActive = true
        emptyDatabaseLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        emptyDatabaseLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        emptyDatabaseLabel.font = .systemFont(ofSize: 28.0)
        emptyDatabaseLabel.textColor = .gray
        emptyDatabaseLabel.text = "Add new one"
        emptyDatabaseLabel.layer.zPosition = 10
    }
    
    private func configureHintForEdit() {
        imageViewEditMemory.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewEditMemory)
        imageViewEditMemory.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        imageViewEditMemory.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2*UIConstants.padding).isActive = true
        imageViewEditMemory.widthAnchor.constraint(equalToConstant: UIConstants.imageSize).isActive = true
        imageViewEditMemory.heightAnchor.constraint(equalTo: imageViewEditMemory.widthAnchor).isActive = true
        imageViewEditMemory.image = UIImage(systemName: "arrow.right.to.line.compact")?.withTintColor(.systemOrange.withAlphaComponent(0.5)).withRenderingMode(.alwaysOriginal)
        imageViewEditMemory.layer.zPosition = 100
        
        hintForEditMemoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintForEditMemoryLabel)
        hintForEditMemoryLabel.centerYAnchor.constraint(equalTo: imageViewEditMemory.centerYAnchor).isActive = true
        hintForEditMemoryLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -2*UIConstants.padding).isActive = true
        hintForEditMemoryLabel.leftAnchor.constraint(equalTo: imageViewEditMemory.rightAnchor, constant: UIConstants.padding).isActive = true
        hintForEditMemoryLabel.text = "Pull the memory card from the left to edit it"
        hintForEditMemoryLabel.font = .systemFont(ofSize: 20.0, weight: .semibold)
        hintForEditMemoryLabel.layer.zPosition = 100
    }
    
    private func configureHintForDelete() {
        hintForDeleteMemoryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hintForDeleteMemoryLabel)
        hintForDeleteMemoryLabel.topAnchor.constraint(equalTo: hintForEditMemoryLabel.bottomAnchor, constant: 2*UIConstants.padding).isActive = true
        hintForDeleteMemoryLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -3*UIConstants.padding - UIConstants.imageSize).isActive = true
        hintForDeleteMemoryLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2*UIConstants.padding).isActive = true
        hintForDeleteMemoryLabel.text = "Pull the memory card from the right to delete it"
        hintForDeleteMemoryLabel.font = .systemFont(ofSize: 20.0, weight: .semibold)
        hintForDeleteMemoryLabel.layer.zPosition = 100
        
        imageViewDeleteMemory.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewDeleteMemory)
        imageViewDeleteMemory.centerYAnchor.constraint(equalTo: hintForDeleteMemoryLabel.centerYAnchor).isActive = true
        imageViewDeleteMemory.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -2*UIConstants.padding).isActive = true
        imageViewDeleteMemory.widthAnchor.constraint(equalToConstant: UIConstants.imageSize).isActive = true
        imageViewDeleteMemory.heightAnchor.constraint(equalTo: imageViewDeleteMemory.widthAnchor).isActive = true
        imageViewDeleteMemory.image = UIImage(systemName: "arrow.left.to.line.compact")?.withTintColor(UIColor(named: "editButtonColor")!).withRenderingMode(.alwaysOriginal)
        imageViewDeleteMemory.layer.zPosition = 100
    }
    
    private func configureViewForArrow() {
        viewForArrow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewForArrow)
        viewForArrow.topAnchor.constraint(equalTo: emptyDatabaseLabel.bottomAnchor, constant: UIConstants.padding).isActive = true
        viewForArrow.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        viewForArrow.rightAnchor.constraint(equalTo: addMemoryButton.leftAnchor, constant: -UIConstants.padding).isActive = true
        viewForArrow.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.buttonPadding).isActive = true
        viewForArrow.backgroundColor = .gray.withAlphaComponent(0.2)
        drawCurvedArrow()
    }
    
    private func drawCurvedArrow() {
        let path = UIBezierPath()
        let arrowLayer = CAShapeLayer()
        let xStart = emptyDatabaseLabel.bounds.midX
        let yStart = viewForArrow.bounds.minY
        let xEnd = viewForArrow.bounds.maxX
        let yEnd = viewForArrow.bounds.maxY - addMemoryButton.bounds.midY
        let cp1 = CGPoint(x: xStart, y: (yEnd + yStart) / 2)
        let cp2 = CGPoint(x: (xEnd + xStart) / 2, y: yEnd)
        path.move(to: CGPoint(x: xStart, y: yStart))
        path.addCurve(to: CGPoint(x: xEnd, y: yEnd), controlPoint1: cp1, controlPoint2: cp2)
        arrowLayer.path = path.cgPath
        arrowLayer.lineWidth = 15.0
        arrowLayer.strokeColor = UIColor.red.cgColor
        arrowLayer.fillColor = UIColor.clear.cgColor
        viewForArrow.layer.addSublayer(arrowLayer)
    }
    
    private func configureTableView(fullScreen: Bool) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        if fullScreen {
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            tableView.heightAnchor.constraint(equalToConstant: 180.0).isActive = true
        }
    }
    
    private func saveOrUpdateDataFor(item: String, memory: MemoryDatabase) {
        self.memoryDataModel.getMemoryTitle(userID: self.userID, memoryID: item, completionHandler: { title in
            memory.memoryTitle = title
        })
        self.memoryDataModel.getMemoryDate(userID: self.userID, memoryID: item) { date in
            memory.memoryDate = self.formatDateFromFirebase(date: date)
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 0) { image in
            memory.memoryImage0 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 1) { image in
            memory.memoryImage1 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 2) { image in
            memory.memoryImage2 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 3) { image in
            memory.memoryImage3 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 4) { image in
            memory.memoryImage4 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 5) { image in
            memory.memoryImage5 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 6) { image in
            memory.memoryImage6 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 7) { image in
            memory.memoryImage7 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 8) { image in
            memory.memoryImage8 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        self.downloadDataModel.downloadMemoryImagesAsImage(userID: self.userID, memoryID: item, numberOfItem: 9) { image in
            memory.memoryImage9 = image?.jpegData(compressionQuality: 1.0) ?? Data()
        }
        memory.memoryID = item
    }
    
    private func formatDateFromFirebase(date: String) -> Date {
        let memoryDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.date(from:memoryDate)!
        return date
    }
    
    @objc func addMemoryButtonPressed() {
        let creatingMemoryViewController = CreatingMemoryViewController()
        creatingMemoryViewController.isEditingMode = false
        creatingMemoryViewController.delegate = self
        creatingMemoryViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(creatingMemoryViewController, animated: true)
    }
    
    @objc private func addTapped() {
        print("Add")
    }
    
    @objc func timerMethod() {
        if firebaseMemoryIDsArray.isEmpty {
            DispatchQueue.main.async {
                self.timer?.invalidate()
            }
            self.counterForDownload = 0
        }
        
        downloadData(counter: counterForDownload)
        DispatchQueue.main.async {
            print(self.counterForDownload)
            self.counterForDownload += 1
            if self.counterForDownload == self.firebaseMemoryIDsArray.count {
                self.timer?.invalidate()
                self.counterForDownload = 0
            }
        }
    }

}

extension MemoriesCatalogViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoryTableViewCell.tableViewCellIdentifier, for: indexPath) as? MemoryTableViewCell else {return .init()}
        memoryData = frc.object(at: indexPath)
        let mainImage: Data = memoryData?.memoryImage0 ?? Data()
        let memoryTitle: String = memoryData?.memoryTitle ?? ""
        cell.fillCellWithData(image: mainImage, title: memoryTitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memoryBrowseViewController = MemoryBrowseViewController()
        memoryBrowseViewController.memoryData = frc.object(at: indexPath)
        memoryBrowseViewController.isMyMemory = true
//        memoryBrowseViewController.title = "MEMORY"
        navigationController?.pushViewController(memoryBrowseViewController, animated: true)
        for cell in tableView.visibleCells {
            cell.setSelected(false, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            
            let deletedMemoryID = self.frc.object(at: indexPath).memoryID!
            self.databaseManager.delete(with: self.frc.object(at: indexPath).objectID)
            
            self.coreDataMemoryIDsArray.removeAll()
            self.firebaseMemoryIDsArray.removeAll()
            
            DispatchQueue.global().async {
                self.uploadDataModel.deleteMemoryDataFromFirebase(userID: self.userID, memoryID: deletedMemoryID)
                for i in 0...9 {
                    self.uploadDataModel.deleteMemoryImagesFromFirebase(userID: self.userID, memoryID: deletedMemoryID, imageName: "memoryImage\(i)") { error in
                    }
                }
            }
            print("Before dispatch")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                self.updateFromFirebase()
////                self.coreDataMemoryIDsArray.remove(deletedMemoryID)
////                self.firebaseMemoryIDsArray.remove(deletedMemoryID)
////                print("delete memory with ID: \(deletedMemoryID)")
//                print("After dispatch")
//                print("coreDataMemoryIDsArray:\(self.coreDataMemoryIDsArray)")
//                print("firebaseMemoryIDsArray:\(self.firebaseMemoryIDsArray)")
//                if self.counterForDownload > 0 {
//                    self.counterForDownload = 0
//                }
//                DispatchQueue.main.async {
//                    self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.timerMethod), userInfo: nil, repeats: true)
//                }
//            }
        }
        deleteAction.backgroundColor = .systemRed.withAlphaComponent(0.5)
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(UIColor(named: "editButtonColor")!)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
//            self.getNumberOfMemoriesInFirebase()
//            self.updateFromFirebase()
            let editMemoryViewController = CreatingMemoryViewController()
            editMemoryViewController.delegate = self
            editMemoryViewController.isEditingMode = true
            editMemoryViewController.memoryData = self.frc.object(at: indexPath)
            editMemoryViewController.title = "EDIT"
            editMemoryViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.present(editMemoryViewController, animated: true)
            handler(true)
        }
        editAction.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        editAction.image = UIImage(systemName: "ellipsis.circle")?.withTintColor(UIColor(named: "editButtonColor")!)
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension MemoriesCatalogViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let rowAnimation = UITableView.RowAnimation.middle
        numberOfObjectsInDatabase = frc.fetchedObjects?.count ?? 0
        print(numberOfObjectsInDatabase)
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: UITableView.RowAnimation.left)
                self.coreDataMemoryIDsArray.insert(self.frc.object(at: newIndexPath).memoryID!)
                print("Created object with ObjectID: \(frc.object(at: newIndexPath).objectID)")
            }
            if numberOfObjectsInDatabase == 1 {
                emptyDatabaseLabel.removeFromSuperview()
                emptyDatabaseTitleLabel.removeFromSuperview()
                if !hintsAreShown {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.configureHintForEdit()
                        self.configureHintForDelete()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                        self.imageViewEditMemory.removeFromSuperview()
                        self.hintForEditMemoryLabel.removeFromSuperview()
                        self.imageViewDeleteMemory.removeFromSuperview()
                        self.hintForDeleteMemoryLabel.removeFromSuperview()
                        self.hintsAreShown = true
                    }
                }
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                DispatchQueue.main.async {
                    self.timer?.invalidate()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.updateFromFirebase()
                    print("After dispatch")
                    print("coreDataMemoryIDsArray:\(self.coreDataMemoryIDsArray)")
                    print("firebaseMemoryIDsArray:\(self.firebaseMemoryIDsArray)")
                    if self.counterForDownload > 0 {
                        self.counterForDownload = 0
                    }
                    DispatchQueue.main.async {
                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.timerMethod), userInfo: nil, repeats: true)
                    }
                }
            }
            if numberOfObjectsInDatabase == 0 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    self.tableView.removeFromSuperview()
//                }
                if !hintsAreShown {
                    imageViewEditMemory.removeFromSuperview()
                    hintForEditMemoryLabel.removeFromSuperview()
                    imageViewDeleteMemory.removeFromSuperview()
                    hintForDeleteMemoryLabel.removeFromSuperview()
                    hintsAreShown = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    self.imageViewEditMemory.removeFromSuperview()
//                    self.hintForEditMemoryLabel.removeFromSuperview()
//                    self.imageViewDeleteMemory.removeFromSuperview()
//                    self.hintForDeleteMemoryLabel.removeFromSuperview()
                    self.configureEmptyDatabaseTitleLabel()
                    self.configureEmptyDatabaseLabel()
                }
            }
            
        case .move:
            if let oldIndexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: rowAnimation)
            }
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


extension MemoriesCatalogViewController: CreatingMemoryViewControllerDelegate {
    func saveButtonPressed() {
    }
    
    func shouldUpdateTable(_ value: Bool) {
        shouldFetchData = value
    }
}
