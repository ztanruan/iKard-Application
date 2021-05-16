import UIKit
import Firebase

class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    var arr_Selectedimage = [#imageLiteral(resourceName: "icon_home_selected"), #imageLiteral(resourceName: "icon_map_selected"), #imageLiteral(resourceName: "icon_info_selecred"), #imageLiteral(resourceName: "icon_notification_selected")]
    var arr_UnSelectedimage = [#imageLiteral(resourceName: "icon_home_unselecred"), #imageLiteral(resourceName: "icon_map_unselected"), #imageLiteral(resourceName: "icon_info_unselecred"), #imageLiteral(resourceName: "icon_notification_unselected")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(tabBarController.selectedIndex)
        if selectedViewController != nil && viewController != selectedViewController {
            return
        }
        if(tabBarController.selectedIndex == 3){
            tabBarController.tabBar.isHidden = true
            let alert = UIAlertController.init(title: nil, message: "", preferredStyle: UIAlertController.Style.alert)
            
            let attributedMessage = NSMutableAttributedString(string: "Are you sure you want to logout?", attributes: [NSAttributedString.Key.font: UIFont.AppFontMedium(16)])
            alert.setValue(attributedMessage, forKey: "attributedMessage")
            
            let actionCancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                tabBarController.tabBar.isHidden = false
                tabBarController.selectedIndex = 0
            })
            
            let actionOK = UIAlertAction.init(title: "Logout", style: UIAlertAction.Style.destructive, handler: { (action) in
                clearDataOnLogout()
                appDelegate.app_setLogin()
            })
            
            alert.addAction(actionOK)
            alert.addAction(actionCancel)
            appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            for textfield: UIView in (alert.textFields ?? [])! {
                let container: UIView = textfield.superview!
                let effectView: UIView = container.superview!.subviews[0]
                container.backgroundColor = UIColor.clear
                effectView.removeFromSuperview()
            }
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




















