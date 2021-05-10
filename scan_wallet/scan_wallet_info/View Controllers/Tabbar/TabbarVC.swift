//
//  TabbarVC.swift
//  Zhen Demo
//
//  Created by Teddys on 23/05/20.
//  Copyright © 2020 Teddys. All rights reserved.
//

import UIKit
import Firebase

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    var arr_Selectedimage = [#imageLiteral(resourceName: "icon_home_selected"), #imageLiteral(resourceName: "icon_map_selected"), #imageLiteral(resourceName: "icon_info_selecred"), #imageLiteral(resourceName: "icon_notification_selected")]
    var arr_UnSelectedimage = [#imageLiteral(resourceName: "icon_home_unselecred"), #imageLiteral(resourceName: "icon_map_unselected"), #imageLiteral(resourceName: "icon_info_unselecred"), #imageLiteral(resourceName: "icon_notification_unselected")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set Image For Bottom Tab
        self.delegate = self
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arr_Selectedimage[i]
                let imageNameForUnselectedState = arr_UnSelectedimage[i]
                let unselectedItemColor = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
                let selectedItemColor = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3784079254, green: 0.8032236099, blue: 1, alpha: 1)]
                
                self.tabBar.items?[i].setTitleTextAttributes(unselectedItemColor, for: .normal)
                self.tabBar.items?[i].setTitleTextAttributes(selectedItemColor, for: .selected)
                self.tabBar.items?[i].selectedImage = imageNameForSelectedState.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = imageNameForUnselectedState.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = arr_Selectedimage[i]
                let imageNameForUnselectedState = arr_UnSelectedimage[i]
                let unselectedItemColor = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
                let selectedItemColor = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3784079254, green: 0.8032236099, blue: 1, alpha: 1)]
                
                self.tabBar.items?[i].setTitleTextAttributes(unselectedItemColor, for: .normal)
                self.tabBar.items?[i].setTitleTextAttributes(selectedItemColor, for: .selected)
                self.tabBar.items?[i].selectedImage = imageNameForSelectedState.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = imageNameForUnselectedState.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(tabBarController.selectedIndex)
        if selectedViewController != nil && viewController != selectedViewController {
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print(tabBarController.selectedIndex)
        if selectedViewController != nil && viewController != selectedViewController {
            UIView.transition(from: (selectedViewController?.view)!, to: viewController.view, duration: 0.2, options: UIView.AnimationOptions.transitionCrossDissolve, completion: { (finished) in
            })
        }
        return true
    }
}




















