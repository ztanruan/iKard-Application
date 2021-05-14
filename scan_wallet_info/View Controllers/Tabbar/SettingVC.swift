import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var btn_logout: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btn_logout.backgroundColor = AppColor.blue
    }
    
    func AlertLogOut() {
        
        let alert = UIAlertController.init(title: nil, message: "", preferredStyle: UIAlertController.Style.alert)
        
        let attributedMessage = NSMutableAttributedString(string: "Are you sure you want to logout?", attributes: [NSAttributedString.Key.font: UIFont.AppFontMedium(16)])
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let actionCancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func btn_Logout(_ sender: UIControl) {
        self.AlertLogOut()
    }

}
