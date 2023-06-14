//
//  TabBarController.swift
//  Memories
//
//  Created by Данил Швец on 13.06.2023.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MEMORIES"
        
        tabBar.tintColor = UIColor(named: "addMemoryButtonColor")
//        let vc1 = UINavigationController(rootViewController: MemoriesCatalogViewController())
        let vc1 = MemoriesCatalogViewController()
        let icon1 = UITabBarItem(title: "MEMORIES", image: UIImage(systemName: "photo.on.rectangle.angled"), tag: 0)
        vc1.tabBarItem = icon1
        
//        let vc2 = UINavigationController(rootViewController: UserProfileViewController())
        let vc2 = UserProfileViewController()
        let icon2 = UITabBarItem(title: "PROFILE", image: UIImage(systemName: "person.crop.circle"), tag: 1)
        vc2.tabBarItem = icon2
        
        let controllers = [vc1, vc2]
        self.viewControllers = controllers
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.navigationItem.hidesBackButton = true
//    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
