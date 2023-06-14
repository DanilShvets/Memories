//
//  CreatingMemoryViewController.swift
//  Memories
//
//  Created by Данил Швец on 06.06.2023.
//

import UIKit
import PhotosUI
import CoreData

protocol CreatingMemoryViewControllerDelegate: AnyObject {
    func shouldUpdateTable(_ value: Bool)
    func saveButtonPressed()
}

final class CreatingMemoryViewController: UIViewController {
    
    private struct UIConstants {
        static let buttonSize: CGFloat = 30
        static let buttonCornerRadius: CGFloat = 15
        static let buttonPadding: CGFloat = 20
        static let padding: CGFloat = 15
        static let cornerRadius: CGFloat = 20
        static let addAndEditPhotosButtonHeight: CGFloat = 40
        static let pageControllerHeight: CGFloat = 25
        static let textFieldHeight: CGFloat = 50
    }
    
    weak var delegate: CreatingMemoryViewControllerDelegate? = nil
    var isEditingMode = false
    var currentMemoryObjectID = NSManagedObjectID()
    var indexPathForFRC = IndexPath()
    var memoryData: MemoryDatabase?
    private lazy var innerEditingStatus = false
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        return button
    }()
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.buttonSize, weight: .regular, scale: .default)
    private lazy var imagesArray = [UIImage]()
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
    private lazy var addPhotosButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addPhotosButtonPressed), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "addMemoryButtonColor")
        button.setTitle("Add photos", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    private lazy var editPhotosButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(editPhotosButtonPressed), for: .touchUpInside)
        button.setTitle("Delete photo", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    private lazy var memoryTitleTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Enter the title for your memory"
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
//        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.delegate = self
        return textField
    }()
    private lazy var memoryTitleText = ""
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.delegate = self
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        return textField
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
//    private lazy var frc: NSFetchedResultsController<MemoryDatabase> = {
//        let fr = MemoryDatabase.fetchRequest()
//        fr.sortDescriptors = [NSSortDescriptor(key: #keyPath(MemoryDatabase.memoryDate), ascending: false)]
//        let frc =  NSFetchedResultsController<MemoryDatabase>(fetchRequest: fr, managedObjectContext: databaseManager.mainQueueContext, sectionNameKeyPath: nil, cacheName: nil)
//        frc.delegate = self
//        return frc
//    }()
    
    private let databaseManager: DataManager = DataManager.shared
    private let databaseName = "MemoryDatabase"
    private lazy var mainImage = UIImage()
    private lazy var memoryDate = Date()
    private lazy var memoryTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        self.hideKeyboard()
        
//        try? frc.performFetch()
        configureData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCloseButton()
        configureImageView()
        configureCollectionView()
        configurePageControl()
        configureAddAndEditPhotosButton()
        configureMemoryTitleTextField()
        configureDatePicker()
        configureSaveButton()
    }
    
    private func configureData() {
        innerEditingStatus = isEditingMode
        
        if innerEditingStatus {
            let imagesInCoreData = [memoryData!.memoryImage0, memoryData!.memoryImage1, memoryData!.memoryImage2, memoryData!.memoryImage3, memoryData!.memoryImage4, memoryData!.memoryImage5, memoryData!.memoryImage6, memoryData!.memoryImage7, memoryData!.memoryImage8, memoryData!.memoryImage9]
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
            memoryTitleText = memoryData!.memoryTitle ?? ""
            memoryTitleTextField.text = memoryTitleText
//            let memoryDate: String = formatDate(date: memoryData.memoryDate ?? Date())
//            dateTextField.text = memoryDate
            memoryDate = memoryData!.memoryDate ?? Date()
            let memoryDate: String = formatDate(date: memoryDate)
            dateTextField.text = memoryDate
            isEditingMode = false
        }
    }
    
    private func configureCloseButton() {
        let closeButtonImage = UIImage(systemName: "xmark", withConfiguration: largeConfig)
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.tintColor = .systemGray
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.buttonPadding).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.buttonPadding).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: UIConstants.buttonSize).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonSize).isActive = true
        closeButton.clipsToBounds = true
        closeButton.layer.cornerRadius = UIConstants.buttonCornerRadius
    }
    
    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: UIConstants.padding).isActive = true
//        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.padding).isActive = true
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
    
    private func configureAddAndEditPhotosButton() {
        [addPhotosButton, editPhotosButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UIConstants.padding).isActive = true
            button.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.5).isActive = true
            button.heightAnchor.constraint(equalToConstant: UIConstants.addAndEditPhotosButtonHeight).isActive = true
            button.layer.cornerRadius = UIConstants.cornerRadius
            addShadowTo(myView: button)
        }
        
        addPhotosButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        editPhotosButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        
        if imagesArray.isEmpty {
            editPhotosButton.backgroundColor = .systemGray
            editPhotosButton.isUserInteractionEnabled = false
        } else {
            self.editPhotosButton.backgroundColor = UIColor(named: "editButtonColor")?.withAlphaComponent(0.7)
            self.editPhotosButton.isUserInteractionEnabled = true
        }
    }
    
    private func configureMemoryTitleTextField() {
        memoryTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        memoryTitleTextField.backgroundColor = UIColor(named: "textFieldBackgroundColor")
        view.addSubview(memoryTitleTextField)
        memoryTitleTextField.topAnchor.constraint(equalTo: addPhotosButton.bottomAnchor, constant: UIConstants.padding + 5.0).isActive = true
        memoryTitleTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2*UIConstants.padding).isActive = true
        memoryTitleTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -2*UIConstants.padding).isActive = true
        memoryTitleTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight).isActive = true
        memoryTitleTextField.layer.cornerRadius = UIConstants.cornerRadius
        memoryTitleTextField.textAlignment = .center
    }
    
    private func configureDatePicker() {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
//        datePicker.frame.size = CGSize(width: view.bounds.width - 2*UIConstants.padding, height: 250)
        dateTextField.inputView = datePicker
//        dateTextField.inputAccessoryView = createToolBar()
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = memoryDate
        
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.textAlignment = .center
        dateTextField.placeholder = innerEditingStatus ? formatDate(date: memoryDate) : "Event's date"
        dateTextField.backgroundColor = UIColor(named: "textFieldBackgroundColor")
        view.addSubview(dateTextField)
        dateTextField.topAnchor.constraint(equalTo: memoryTitleTextField.bottomAnchor, constant: UIConstants.padding).isActive = true
        dateTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 2*UIConstants.padding).isActive = true
        dateTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -2*UIConstants.padding).isActive = true
        dateTextField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight).isActive = true
        dateTextField.layer.cornerRadius = UIConstants.cornerRadius
    }
    
    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditingDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: true)
        return toolBar
    }
    
    private func configureSaveButton() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.5).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: UIConstants.addAndEditPhotosButtonHeight).isActive = true
        saveButton.layer.cornerRadius = UIConstants.cornerRadius
        saveButton.backgroundColor = UIColor(named: "saveButtonColor")?.withAlphaComponent(0.7)
        addShadowTo(myView: saveButton)
        saveButton.setTitle("Save", for: .normal)
    }
    
    private func formatDate(date: Date) -> String {
        memoryDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func addShadowTo(myView: UIView) {
        myView.layer.masksToBounds = false
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowPath = UIBezierPath(roundedRect: myView.bounds, cornerRadius: myView.layer.cornerRadius).cgPath
        myView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 5.0
    }
    
    @objc func closeViewController() {
        dismiss(animated: true)
//        presentColorPicker()
    }
    
    @objc private func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = formatDate(date: datePicker.date)
        print(formatDate(date: datePicker.date))
    }
    
    @objc private func endEditingDate() {
        dateTextField.endEditing(true)
    }
    
    @objc private func addPhotosButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.addPhotosButton.transform = self.addPhotosButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.addPhotosButton.transform = self.addPhotosButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        if imagesArray.count < 10 {
            var config = PHPickerConfiguration()
            config.selectionLimit = 10 - imagesArray.count
            config.filter = .images
            if #available(iOS 15.0, *) {
                config.selection = .ordered
            } else { }
            let photoPickerViewController = PHPickerViewController(configuration: config)
            photoPickerViewController.delegate = self
            self.present(photoPickerViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "You can add up to 10 photos. Please, remove some photos.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func editPhotosButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.editPhotosButton.transform = self.editPhotosButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.editPhotosButton.transform = self.editPhotosButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        let index = collectionView.indexPathsForVisibleItems
        if !imagesArray.isEmpty {
            for i in index {
                imagesArray.remove(at: i.row)
            }
            if imagesArray.count > 0 {
                collectionView.deleteItems(at: index)
            }
            pageControl.numberOfPages = imagesArray.count
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        if imagesArray.isEmpty {
            editPhotosButton.backgroundColor = .systemGray
            editPhotosButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func saveButtonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.saveButton.transform = self.saveButton.transform.scaledBy(x: 0.85, y: 0.85)
        }
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            self.saveButton.transform = self.saveButton.transform.scaledBy(x: 1.0/0.85, y: 1.0/0.85)
        }
        
        if !imagesArray.isEmpty {
            mainImage = imagesArray[0]
        }
        
        if !imagesArray.isEmpty && memoryTitleTextField.text != "" && dateTextField.text != "" {
            memoryTitleText = memoryTitleTextField.text!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.dismiss(animated: true)
                self.delegate?.shouldUpdateTable(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    if innerEditingStatus {
                        databaseManager.update(objectID: memoryData!.objectID) { memory in
                            guard let memory = memory as? MemoryDatabase else { return }
                            self.saveOrUpdateData(memory: memory)
                            
                        }
                    } else {
                        databaseManager.create(with: databaseName) { memory in
                            guard let memory = memory as? MemoryDatabase else { return }
                            self.saveOrUpdateData(memory: memory)
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "To \(innerEditingStatus ? "edit" : "create new") Memory you should fill TITLE and DATE fields and add at least 1 PHOTO", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func saveOrUpdateData(memory: MemoryDatabase) {
        memory.memoryTitle = memoryTitleText
        memory.memoryDate = memoryDate
        memory.memoryImage0 = !imagesArray.isEmpty ? imagesArray[0].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage1 = imagesArray.count > 1 ? imagesArray[1].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage2 = imagesArray.count > 2 ? imagesArray[2].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage3 = imagesArray.count > 3 ? imagesArray[3].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage4 = imagesArray.count > 4 ? imagesArray[4].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage5 = imagesArray.count > 5 ? imagesArray[5].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage6 = imagesArray.count > 6 ? imagesArray[6].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage7 = imagesArray.count > 7 ? imagesArray[7].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage8 = imagesArray.count > 8 ? imagesArray[8].jpegData(compressionQuality: 1.0) : Data()
        memory.memoryImage9 = imagesArray.count > 9 ? imagesArray[9].jpegData(compressionQuality: 1.0) : Data()
    }
}


extension CreatingMemoryViewController: UIColorPickerViewControllerDelegate {
    func presentColorPicker() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Background Color"
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        colorPicker.popoverPresentationController?.sourceView = closeButton
        self.present(colorPicker, animated: true)
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        closeButton.tintColor = viewController.selectedColor
    }
}

extension CreatingMemoryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.imagesArray.append(image)
                }
                DispatchQueue.main.async {
                    if !self.imagesArray.isEmpty {
                        self.editPhotosButton.backgroundColor = UIColor(named: "editButtonColor")?.withAlphaComponent(0.7)
                        self.editPhotosButton.isUserInteractionEnabled = true
                    }
                    if self.imagesArray.count > 1 {
                        self.pageControl.isHidden = false
                        self.pageControl.numberOfPages = self.imagesArray.count
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension CreatingMemoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

extension CreatingMemoryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPosition = scrollView.contentOffset.x / imageView.frame.width
        pageControl.currentPage = Int(scrollPosition)
    }
}

extension CreatingMemoryViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        memoryTitleText = textField.text ?? ""
        textField.resignFirstResponder()
        print(memoryTitleText)
        memoryTitle = memoryTitleText
        return true
    }

}

extension CreatingMemoryViewController: NSFetchedResultsControllerDelegate {

}
