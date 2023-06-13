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
        
        tabBar.tintColor = UIColor(named: "addMemoryButtonColor")
        let vc1 = UINavigationController(rootViewController: MemoriesCatalogViewController())
        let icon1 = UITabBarItem(title: "Memories", image: UIImage(systemName: "photo.on.rectangle.angled"), tag: 0)
        vc1.tabBarItem = icon1
        
        let vc2 = UINavigationController(rootViewController: UserProfileViewController())
        let icon2 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)
        vc2.tabBarItem = icon2
        
        let controllers = [vc1, vc2]
        self.viewControllers = controllers
    }


    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true;
    }
}
