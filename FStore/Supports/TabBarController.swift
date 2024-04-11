//
//  TabBarController.swift
//  FStore
//
//  Created by Nguyễn Tuấn Dũng on 09/04/2024.
//
import UIKit

class TabBarController: UITabBarController {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = MAIN_COLOR
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor(white: 0.2, alpha: 1)
        
        let homeTableViewController = UINavigationController(rootViewController: HomeTableViewController(style: .grouped))
        homeTableViewController.tabBarItem = UITabBarItem(title: "Trang Chủ", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_selected"))
        homeTableViewController.tabBarItem.tag = 0
        
        let categoryTableViewController = UINavigationController(rootViewController: CategoryTableViewController(style: .grouped))
        categoryTableViewController.tabBarItem = UITabBarItem(title: "Danh Mục", image: #imageLiteral(resourceName: "category"), selectedImage: #imageLiteral(resourceName: "category_selected"))
        categoryTableViewController.tabBarItem.tag = 1

        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem = UITabBarItem(title: "Tìm Kiếm", image: #imageLiteral(resourceName: "search"), selectedImage: #imageLiteral(resourceName: "search"))
        searchViewController.tabBarItem.tag = 2

        let trademarkCollectionViewController = UINavigationController(rootViewController: TrademarkCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        trademarkCollectionViewController.tabBarItem = UITabBarItem(title: "Thương Hiệu", image: #imageLiteral(resourceName: "trademark"), selectedImage: #imageLiteral(resourceName: "trademark_selected"))
        trademarkCollectionViewController.tabBarItem.tag = 3

        let individualTableViewController = UINavigationController(rootViewController: IndividualTableViewController(style: .grouped))
        individualTableViewController.tabBarItem = UITabBarItem(title: "Cá Nhân", image: #imageLiteral(resourceName: "me"), selectedImage: #imageLiteral(resourceName: "me_selected"))
        individualTableViewController.tabBarItem.tag = 4
        
        viewControllers = [homeTableViewController, categoryTableViewController, searchViewController, trademarkCollectionViewController, individualTableViewController]
        
        selectedIndex = 0
        selectedViewController = homeTableViewController
        defaults.set(0, forKey: Keys.tabbarIndex)
        
        // setup shadow for tabbar
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.6
        tabBar.layer.masksToBounds = false
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            defaults.set(0, forKey: Keys.tabbarIndex)
        case 1:
            defaults.set(1, forKey: Keys.tabbarIndex)
        case 3:
            defaults.set(3, forKey: Keys.tabbarIndex)
        case 4:
            defaults.set(4, forKey: Keys.tabbarIndex)
        default:
            tabBar.tintColor = MAIN_COLOR
        }
    }
    
}
