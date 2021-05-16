import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var btn_logout: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.btn_logout.backgroundColor = AppColor.blue
    }
    
    func AlertLogOut() {
        

    }
    
    
    @IBAction func btn_Logout(_ sender: UIControl) {
        self.AlertLogOut()
    }

}
