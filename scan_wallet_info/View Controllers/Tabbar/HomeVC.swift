//
//  HomeVC.swift
//  Zhen Demo
//
//  Created by Teddys on 23/05/20.
//  Copyright © 2020 Teddys. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController, UITextFieldDelegate {

    var is_openCell = false
    var strIndx: String? = nil
    var cellHeight: CGFloat = 0.0
    var openCellHeight: CGFloat = 0
    var selectedIndxPath: CGFloat = 0
    var arr_Data = [[String: Any]]()
    @IBOutlet weak var lbl_NoData: UILabel!
    @IBOutlet weak var view_NoData: UIView!
    @IBOutlet weak var tbl_View: UITableView!
    @IBOutlet weak var btn_Add: UIControl!
    private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view_NoData.isHidden = true
        self.getCellHeight()
        
        self.tbl_View.pullTorefresh(#selector(pulltoRefresh), tintcolor: AppColor.blue, self)

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
        
        self.getScannedBusinseeCard(true)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if appDelegate.str_scannedQR_CODE != "" {
            //Scanned QR Code
            print("Scannned QR Code==========>>\(appDelegate.str_scannedQR_CODE)")
            self.getParticular_BusinessCard_fromQRCode(appDelegate.str_scannedQR_CODE)
        }
    }
    
    @objc func pulltoRefresh() {
        self.getScannedBusinseeCard(false)
    }
    
    
    func getParticular_BusinessCard_fromQRCode(_ qr_code: String) {
        
        appDelegate.str_scannedQR_CODE = ""
        ShowProgressHud(message: AppMessage.plzWait)
        DispatchQueue.main.async {
            FirebaseManager.shared.GetParticularBusinessCardsFromFirebaseStorage(scanned_qr_code: qr_code) { (is_added) in
                DismissProgressHud()
                if is_added {
                    self.getScannedBusinseeCard(true)
                }
            }
        }
    }
    
    func getScannedBusinseeCard(_ animate: Bool) {
        
        if animate {
            ShowProgressHud(message: AppMessage.plzWait)
        }
        
        DispatchQueue.main.async {
            FirebaseManager.shared.GetScannedBusinessCardsListFromFirebaseStorage() { (data) in
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - UIButton Action Method
    @IBAction func btn_Add_Action(_ sender: UIControl) {
        let objScan = Story_Main.instantiateViewController(withIdentifier: "ScanVC") as! ScanVC
        self.navigationController?.pushViewController(objScan, animated: true)
    }
}

//MARK: - UITableView Delegate Datasource Method
extension HomeVC: UITableViewDelegate, UITableViewDataSource {

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

}
