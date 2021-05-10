import UIKit
import Firebase
import SDWebImage
import Kingfisher
import AlamofireImage
import FirebaseStorage
import FirebaseDatabase

class ProfileVC: UIViewController, CLLocationManagerDelegate {

    var is_openCell = false
    var strIndx: String? = nil
    var cellHeight: CGFloat = 0.0
    var openCellHeight: CGFloat = 0
    var selectedIndxPath: CGFloat = 0
    var arr_Data = [[String: Any]]()
    var ref: DatabaseReference!
    let locationManager = CLLocationManager()
    @IBOutlet weak var lbl_NoData: UILabel!
    @IBOutlet weak var view_NoData: UIView!
    @IBOutlet weak var tbl_View: UITableView!
    @IBOutlet weak var btn_Add: UIControl!
    private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ref = Database.database().reference()
        self.view_NoData.isHidden = true
        self.getCellHeight()
        
        self.tbl_View.pullTorefresh(#selector(pulltoRefresh), tintcolor: AppColor.blue, self)
        
        self.manageSection(true)
        
        //For Attribute Text
        let newText1 = NSMutableAttributedString.init(string: "No data found")
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.alignment = .center
        paragraphStyle1.lineSpacing = 4
        newText1.addAttribute(NSAttributedString.Key.font,
                              value: UIFont.AppFontRegular(15),
                              range: NSRange.init(location: 0, length: newText1.length))
        newText1.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), range: NSRange.init(location: 0, length: newText1.length))
        newText1.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle1, range: NSRange.init(location: 0, length: newText1.length))
        self.lbl_NoData.attributedText = newText1
    }
    
    @objc func pulltoRefresh() {
        self.manageSection(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if appDelegate.is_myProfileListRefresh {
            appDelegate.is_myProfileListRefresh = false
            self.manageSection(true)
        }
    }
    
    func getCellHeight() {
        var extraMius: CGFloat = 0.0
        let safeAreaInset = appDelegate.window?.safeAreaInsets.top ?? 20
        let safeAreaInset_Bottom = appDelegate.window?.safeAreaInsets.bottom ?? 20
        if safeAreaInset_Bottom != 0.0 {
            extraMius = 60.0
        }
        let safe = safeAreaInset + safeAreaInset_Bottom + (self.tabBarController?.tabBar.frame.height ?? 0) + extraMius
        self.openCellHeight = ((screenHeight - safe)  - self.cellHeight) + 100
    }

    
    //MARK: - UIButton Action Method
    @IBAction func btn_Add_Action(_ sender: UIControl) {
        self.getLocation()
        appDelegate.is_logo_pic_change = false
        appDelegate.is_background_pic_change = false
        appDelegate.is_profile_pic_change = false
        appDelegate.int_CreateBusinessDetail = 0
        appDelegate.create_business_screenFrom = ScreenType.none
        appDelegate.dic_ValueforCreate_BusinessItem.removeAll()
        let objStep = Story_Main.instantiateViewController(withIdentifier: "Create_BusinessCardStepVC") as! Create_BusinessCardStepVC
        self.navigationController?.pushViewController(objStep, animated: true)
    }
}

//MARK: - UITableView Delegate Datasource Method
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func manageSection(_ animate: Bool) {
        
        if animate {
            ShowProgressHud(message: AppMessage.plzWait)
        }
        
        DispatchQueue.main.async {
            FirebaseManager.shared.GetMyBusinessCardsListFromFirebaseStorage() { (data) in
                DismissProgressHud()
                if let dataaa = data {
                    self.arr_Data = dataaa
                }
                self.tbl_View.closeEndPullRefresh()
                self.view_NoData.isHidden = self.arr_Data.count == 0 ? false : true
                self.tbl_View.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DemoElongationCell = tableView.dequeueReusableCell(withIdentifier: "DemoElongationCell", for: indexPath) as! DemoElongationCell
        cell.selectionStyle = .none
        cell.view_Img_BG.layer.cornerRadius = 50
        cell.Img_Profile.layer.cornerRadius = 50
        cell.lbl_position_Horizentally.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        cell.lbl_nameText_Horizentally.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        let dic_Detail = self.arr_Data[indexPath.row]
        cell.lbl_city.text = dic_Detail["city"] as? String ?? ""
        cell.lbl_city_detail.text = dic_Detail["city"] as? String ?? ""
        cell.lbl_nameTex.text = dic_Detail["name"] as? String ?? ""
        cell.lbl_position.text = dic_Detail["position"] as? String ?? ""
        cell.lbl_phone.text = dic_Detail["phone"] as? String ?? ""
        cell.lbl_phone_detail.text = dic_Detail["phone"] as? String ?? ""
        cell.lbl_address.text = dic_Detail["address"] as? String ?? ""
        cell.lbl_secondary_phone_detail.text = dic_Detail["secondary_phone"] as? String ?? ""
        cell.lbl_email.text = dic_Detail["email"] as? String ?? ""
        cell.lbl_email_detail.text = dic_Detail["email"] as? String ?? ""
        cell.lbl_companyName.text = dic_Detail["company"] as? String ?? ""
        cell.lbl_position_Horizentally.text = dic_Detail["position"] as? String ?? ""
        cell.lbl_nameText_Horizentally.text = dic_Detail["name"] as? String ?? ""
        
        let str_logImag = dic_Detail["logo_image"] as? String ?? ""
        let str_qr_code = dic_Detail["qr_code"] as? String ?? ""
        let str_background_image = dic_Detail["background_image"] as? String ?? ""
        let str_profile_image = dic_Detail["profile_image"] as? String ?? ""
        cell.img_logo.kf.setImage(with: URL.init(string: str_logImag))
        cell.img_logo_detail.kf.setImage(with: URL.init(string: str_logImag))
        cell.Img_Profile.kf.setImage(with: URL.init(string: str_profile_image))
        cell.Img_Background.kf.setImage(with: URL.init(string: str_background_image))
        
        if let qr_image = generateQRCode(from: str_qr_code) {
            cell.img_qr_code.image = qr_image
            cell.img_qr_code_detail.image = qr_image
        }
        
        
        if strIndx == "\(indexPath.row)" {
            cell.view_Detail.isHidden = false
            cell.constraints_view_Detail.constant = openCellHeight
        }
        else {
            cell.view_Detail.isHidden = true
            cell.constraints_view_Detail.constant = 4
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dic_Detail = self.arr_Data[indexPath.row]
        let iddddddddd = dic_Detail["id"] as? String ?? ""
        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                //Edit Business Detail
                self.getLocation()
                appDelegate.is_logo_pic_change = false
                appDelegate.is_background_pic_change = false
                appDelegate.is_profile_pic_change = false
                appDelegate.int_CreateBusinessDetail = 0
                appDelegate.create_business_screenFrom = ScreenType.edit
                appDelegate.dic_ValueforCreate_BusinessItem.removeAll()
                let objStep = Story_Main.instantiateViewController(withIdentifier: "Create_BusinessCardStepVC") as! Create_BusinessCardStepVC
                objStep.dic_business_Detail = dic_Detail
                self.navigationController?.pushViewController(objStep, animated: true)
            }
            
            completionHandler(true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            
            //Delete Business Detail
            self.deleteConfirmation(iddddddddd, indexPath)
            
            completionHandler(true)
        }
        
        rename.image = #imageLiteral(resourceName: "icon_edit_gray")
        delete.image = #imageLiteral(resourceName: "icon_delete-1")
        rename.backgroundColor = .white
        delete.backgroundColor = .white
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete, rename])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.cellHeightsDictionary[indexPath] {
          return height
        }
        return UITableView.automaticDimension
      }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            if self.cellHeight == 0.0 {
                self.cellHeight = cell.frame.size.height
                self.getCellHeight()
            }
        }
        self.cellHeightsDictionary[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = self.tbl_View.cellForRow(at: indexPath) as! DemoElongationCell
        if self.strIndx == "\(indexPath.row)" {
            self.strIndx = nil
            self.is_openCell = false
            self.tbl_View.beginUpdates()
            self.tbl_View.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.tbl_View.endUpdates()
        }
        else {
            if self.is_openCell {
                self.strIndx = "\(indexPath.row)"
                self.tbl_View.beginUpdates()
                self.tbl_View.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                self.tbl_View.endUpdates()
                
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut) {
                    self.tbl_View.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self.tbl_View.setContentOffset(CGPoint.init(x: 0, y: currentCell.frame.origin.y), animated: false)
                    }
                } completion: { (success) in
                    self.is_openCell = true
                }
            }
            else{
                self.strIndx = "\(indexPath.row)"
                self.tbl_View.beginUpdates()
                self.tbl_View.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                self.tbl_View.endUpdates()
                
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut) {
                    self.tbl_View.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self.tbl_View.setContentOffset(CGPoint.init(x: 0, y: currentCell.frame.origin.y), animated: false)
                    }
                } completion: { (success) in
                    self.is_openCell = true
                    
                }
            }
        }

    }
    
    func deleteConfirmation(_ id: String, _ indexPath: IndexPath) {
        
        let alert = UIAlertController.init(title: nil, message: "", preferredStyle: UIAlertController.Style.alert)
        
        let attributedMessage = NSMutableAttributedString(string: "Are you sure you want to remove?", attributes: [NSAttributedString.Key.font: UIFont.AppFontMedium(16)])
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let actionCancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let actionOK = UIAlertAction.init(title: "Remove", style: UIAlertAction.Style.destructive, handler: { (action) in

            self.tbl_View.beginUpdates()
            self.arr_Data.remove(at: indexPath.row)
            self.tbl_View.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.view_NoData.isHidden = self.arr_Data.count == 0 ? false : true
            self.tbl_View.endUpdates()
            self.ref.child("business_detail").child(GetUserID()).child(id).removeValue()
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
    
    
    // MARK: - GET LOCATION
    func getLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("Profile Screen locations = \(locValue.latitude) \(locValue.longitude)")
        appDelegate.currentLatitude = locValue.latitude
        appDelegate.currentLongitude = locValue.longitude
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Failed Notification")
    }
}


class DemoElongationCell: UITableViewCell {
    
    @IBOutlet weak var view_Img_BG: UIView!
    @IBOutlet weak var Img_Profile: UIImageView!
    @IBOutlet weak var Img_Background: UIImageView!
    @IBOutlet weak var view_Blue_view: UIView!

    @IBOutlet weak var view_Detail: UIView!
    @IBOutlet weak var view_Detail_InnerBG: UIView!
    @IBOutlet weak var constraints_view_Detail: NSLayoutConstraint!

    
    @IBOutlet weak var lbl_position_Horizentally: UILabel!
    @IBOutlet weak var lbl_nameText_Horizentally: UILabel!
    
    
    
    @IBOutlet weak var lbl_nameTex: UILabel!
    @IBOutlet weak var lbl_position: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var img_qr_code: UIImageView!
    
    //Detail View
    @IBOutlet weak var lbl_companyName: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_city_detail: UILabel!
    @IBOutlet weak var lbl_email_detail: UILabel!
    @IBOutlet weak var lbl_phone_detail: UILabel!
    @IBOutlet weak var lbl_secondary_phone_detail: UILabel!
    @IBOutlet weak var img_logo_detail: UIImageView!
    @IBOutlet weak var img_qr_code_detail: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}



