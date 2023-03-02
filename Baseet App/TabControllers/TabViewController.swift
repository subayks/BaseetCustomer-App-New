//
//  TabViewController.swift
//  Baseet App
//
//  Created by apple on 01/11/22.
//

import UIKit

class TabViewController: UITabBarController,UITabBarControllerDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            guard let items = tabBar.items else { return }
            items[0].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Home", comment: "")
            items[1].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Offers", comment: "")
            items[2].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search", comment: "")
            items[3].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cart", comment: "")
            items[4].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Profile", comment: "")
        }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
           
        } else if(item.tag == 2) {
            
        } else if(item.tag == 3) {
            
        }else{
            
        }
    }
}



