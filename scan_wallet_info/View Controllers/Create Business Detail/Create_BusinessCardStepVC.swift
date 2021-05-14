import UIKit
import FirebaseStorage
import FirebaseDatabase

class Create_BusinessCardStepVC: UIViewController {

    var str_selected_Key = ""
    var ref: DatabaseReference!
    var arr_section = [[String: Any]]()
    var dic_business_Detail = [String: Any]()
    @IBOutlet weak var tbl_View: UITableView!
    @IBOutlet weak var btn_Back: UIControl!
    @IBOutlet weak var constraint_tbl_Bottom: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagePicker.delegate = self
        ref = Database.database().reference()
        self.btn_Back.isHidden = appDelegate.int_CreateBusinessDetail == 0 ? true : false
        
        if appDelegate.create_business_screenFrom == .edit {
            if appDelegate.int_CreateBusinessDetail == 0 {
                self.setupDataforEdit()
            }
            else {
                self.manageSection()
            }
        }
        else {
            self.manageSection()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK:- KEYBOARD METHODS
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userinfo:NSDictionary = (notification.userInfo as NSDictionary?) {
            if let keybordsize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let bottomSafeArea = appDelegate.window?.safeAreaInsets.bottom ?? 0
                self.constraint_tbl_Bottom.constant = (keybordsize.height - bottomSafeArea)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.constraint_tbl_Bottom.constant = 0
        self.view.layoutIfNeeded()
    }

    //MARK: - Check Validation for Step 1
    func checkInputValidationsforStep1() -> (Title:String, Message:String)? {
        let str_name = appDelegate.dic_ValueforCreate_BusinessItem["name"] as? String ?? ""
        let str_company = appDelegate.dic_ValueforCreate_BusinessItem["company"] as? String ?? ""
        let str_position = appDelegate.dic_ValueforCreate_BusinessItem["position"] as? String ?? ""
        if str_name.trimed() == "" {
            return ("","Please enter name")
        }
        else if str_company.trimed() == "" {
            return ("","Please enter company name")
        }
        else if str_position.trimed() == "" {
            return ("","Please enter position")
        }
        return nil
    }
    
    //MARK: - Check Validation for Step 2
    func checkInputValidationsforStep2() -> (Title:String, Message:String)? {
        let str_address = appDelegate.dic_ValueforCreate_BusinessItem["address"] as? String ?? ""
        //let str_city = appDelegate.dic_ValueforCreate_BusinessItem["city"] as? String ?? ""
        //let str_zipcode = appDelegate.dic_ValueforCreate_BusinessItem["zipcode"] as? String ?? ""
        if str_address.trimed() == "" {
            return ("","Please enter address")
        }/*
        else if str_city.trimed() == "" {
            return ("","Please enter city")
        }
        else if str_zipcode.trimed() == "" {
            return ("","Please enter zipcode")
        }*/
        return nil
    }
    
    //MARK: - Check Validation for Step 3
    func checkInputValidationsforStep3() -> (Title:String, Message:String)? {
        let str_email = appDelegate.dic_ValueforCreate_BusinessItem["email"] as? String ?? ""
        let str_city = appDelegate.dic_ValueforCreate_BusinessItem["phone"] as? String ?? ""
        if str_email.trimed() == "" {
            return ("","Please enter email")
        }
        else if !isValidEmail(email: str_email.trimed() ) {
            return ("","Please enter a valid email")
        }
        else if str_city.trimed() == "" {
            return ("","Please enter phone")
        }
        return nil
    }
    
    //MARK: - Check Validation for Step 4
    func checkInputValidationsforStep4() -> (Title:String, Message:String)? {
        let background_pic = appDelegate.dic_ValueforCreate_BusinessItem["background_pic"] as? UIImage
        let logo_pic = appDelegate.dic_ValueforCreate_BusinessItem["logo_pic"] as? UIImage
        if background_pic == nil {
            return ("","Please select background image")
        }
        else if logo_pic == nil {
            return ("","Please select logo image")
        }
        return nil
    }
    
    //MARK: - Check Validation for Step 5
    func checkInputValidationsforStep5() -> (Title:String, Message:String)? {
        let profile_pic = appDelegate.dic_ValueforCreate_BusinessItem["profile_pic"] as? UIImage
        if profile_pic == nil {
            return ("","Please select profile image")
        }
        return nil
    }
    
    
    func next_Action() {
        debugPrint(appDelegate.dic_ValueforCreate_BusinessItem)
        
        if appDelegate.int_CreateBusinessDetail == 0 {
            
            if let error = checkInputValidationsforStep1() {
                //Invalid data
                showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                appDelegate.int_CreateBusinessDetail = appDelegate.int_CreateBusinessDetail + 1
                let objStep = Story_Main.instantiateViewController(withIdentifier: "Create_BusinessCardStepVC") as! Create_BusinessCardStepVC
                self.navigationController?.pushViewController(objStep, animated: true)
            }
            
        }
        else if appDelegate.int_CreateBusinessDetail == 1 {
            
            if let error = checkInputValidationsforStep2() {
                //Invalid data
                showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                
                let str_address = appDelegate.dic_ValueforCreate_BusinessItem["address"] as? String ?? ""
                
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(str_address) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        
                    else {
                        print("INVALID ADDRESS")
                        showSingleAlert(Title: "", Message: "Invalid Address", buttonTitle: AppMessage.Ok, delegate: self) { }
                        return
                    }
                    print(location)
                    appDelegate.longitude = location.coordinate.longitude
                    appDelegate.latitude = location.coordinate.latitude
                    
                    appDelegate.int_CreateBusinessDetail = appDelegate.int_CreateBusinessDetail + 1
                    let objStep = Story_Main.instantiateViewController(withIdentifier: "Create_BusinessCardStepVC") as! Create_BusinessCardStepVC
                    self.navigationController?.pushViewController(objStep, animated: true)
                }
                
                
            }
            
        }
        else if appDelegate.int_CreateBusinessDetail == 2 {
            
            if let error = checkInputValidationsforStep3() {
                //Invalid data
                showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                appDelegate.int_CreateBusinessDetail = appDelegate.int_CreateBusinessDetail + 1
                let objStep = Story_Main.instantiateViewController(withIdentifier: "Create_BusinessCardStepVC") as! Create_BusinessCardStepVC
                self.navigationController?.pushViewController(objStep, animated: true)
            }

        }
        else if appDelegate.int_CreateBusinessDetail == 3 {
            
            if let error = checkInputValidationsforStep4() {
                //Invalid data
                showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                appDelegate.int_CreateBusinessDetail = appDelegate.int_CreateBusinessDetail + 1
                let objStep = Story_Main.instantiateViewController(withIdentifier: "Create_BusinessCardStepVC") as! Create_BusinessCardStepVC
                self.navigationController?.pushViewController(objStep, animated: true)
            }

        }
        else if appDelegate.int_CreateBusinessDetail == 4 {
            
            if let error = checkInputValidationsforStep5() {
                //Invalid data
                showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                
                if (appDelegate.dic_ValueforCreate_BusinessItem["location"] as? Bool) == nil {
                    appDelegate.dic_ValueforCreate_BusinessItem["location"] = true
                }
                
                self.finish_Action()
            }

        }
    }
    
    func finish_Action() {
        debugPrint("All Iteams========>>\(appDelegate.dic_ValueforCreate_BusinessItem)")
        
        if appDelegate.create_business_screenFrom == .edit {

            if appDelegate.is_background_pic_change {
                ShowProgressHud(message: AppMessage.plzWait)
                self.uploadBackground_pic()
            }
            else if appDelegate.is_logo_pic_change {
                ShowProgressHud(message: AppMessage.plzWait)
                self.uploadLogo_pic()
            }
            else if appDelegate.is_profile_pic_change {
                ShowProgressHud(message: AppMessage.plzWait)
                self.uploadProfile_pic()
            }
            else {
                ShowProgressHud(message: AppMessage.plzWait)
                self.callAPIforSaveData()
            }

        }
        else {
            //Upload Background Image
            ShowProgressHud(message: AppMessage.plzWait)
            self.uploadBackground_pic()
        }
    }
    
    func uploadBackground_pic() {
        if let back_img = appDelegate.dic_ValueforCreate_BusinessItem["background_pic"] as? UIImage {
            
            //Upload Background Image
            self.ImageUpload_onFirebaseStorage(back_img, keyName: "background_image", FolderName: "background_image") { (is_uploaded) in
                
                if is_uploaded {
                    if appDelegate.create_business_screenFrom == .edit {
                        if appDelegate.is_logo_pic_change {
                            self.uploadLogo_pic()
                        }
                        else if appDelegate.is_profile_pic_change {
                            self.uploadProfile_pic()
                        }
                        else {
                            self.callAPIforSaveData()
                        }
                    }
                    else {
                        self.uploadLogo_pic()
                    }
                    
                }
                else {
                    DismissProgressHud()
                    self.view.makeToast("Something went wrond")
                }
            }
        }
    }
    
    func uploadLogo_pic() {
        //Upload Logo Image
        if let logo_img = appDelegate.dic_ValueforCreate_BusinessItem["logo_pic"] as? UIImage {
            
            self.ImageUpload_onFirebaseStorage(logo_img, keyName: "logo_image", FolderName: "logo_image") { (is_uploaded) in
                
                if is_uploaded {
                    if appDelegate.create_business_screenFrom == .edit {
                        if appDelegate.is_profile_pic_change {
                            self.uploadProfile_pic()
                        }
                        else {
                            self.callAPIforSaveData()
                        }
                    }
                    else {
                        self.uploadProfile_pic()
                    }

                }
                else {
                    DismissProgressHud()
                    self.view.makeToast("Something went wrond")
                }
            }
        }
    }
    
    func uploadProfile_pic() {
        //Upload Profile Image
        if let profile_img = appDelegate.dic_ValueforCreate_BusinessItem["profile_pic"] as? UIImage {
            
            self.ImageUpload_onFirebaseStorage(profile_img, keyName: "profile_image", FolderName: "profile_image") { (is_uploaded) in
                
                if is_uploaded {
                    
                    if appDelegate.create_business_screenFrom == .edit {
                        self.callAPIforSaveData()
                    }
                    else {
                        //Save Data
                        self.uploadQRCODEImage()
                    }
                    
                }
                else {
                    DismissProgressHud()
                    self.view.makeToast("Something went wrond")
                }
                
            }
        }
    }
    
    func uploadQRCODEImage() {
        let generated_qr_code = "QR_\(GetUserID())_\(currentTimeInMiliseconds())"

        //Save Data
        appDelegate.dic_ValueforCreate_BusinessItem["qr_code"] = generated_qr_code
        self.callAPIforSaveData()
    }
    
    func callAPIforSaveData() {
        var str_iddd = appDelegate.dic_ValueforCreate_BusinessItem["id"] as? String ?? ""
        let str_name = appDelegate.dic_ValueforCreate_BusinessItem["name"] as? String ?? ""
        let str_company = appDelegate.dic_ValueforCreate_BusinessItem["company"] as? String ?? ""
        let str_position = appDelegate.dic_ValueforCreate_BusinessItem["position"] as? String ?? ""
        let str_address = appDelegate.dic_ValueforCreate_BusinessItem["address"] as? String ?? ""
        let str_city = appDelegate.dic_ValueforCreate_BusinessItem["city"] as? String ?? ""
        let str_zipcode = appDelegate.dic_ValueforCreate_BusinessItem["zipcode"] as? String ?? ""
        let str_email = appDelegate.dic_ValueforCreate_BusinessItem["email"] as? String ?? ""
        let str_phone = appDelegate.dic_ValueforCreate_BusinessItem["phone"] as? String ?? ""
        let str_secondary_phone = appDelegate.dic_ValueforCreate_BusinessItem["secondary_phone"] as? String ?? ""
        let background_pic = appDelegate.dic_ValueforCreate_BusinessItem["background_image"] as? String ?? ""
        let logo_pic = appDelegate.dic_ValueforCreate_BusinessItem["logo_image"] as? String ?? ""
        let profile_pic = appDelegate.dic_ValueforCreate_BusinessItem["profile_image"] as? String ?? ""
        let is_location = appDelegate.dic_ValueforCreate_BusinessItem["location"] as? Bool ?? false
        let qr_code = appDelegate.dic_ValueforCreate_BusinessItem["qr_code"] as? String ?? ""

        if str_iddd == "" {
            str_iddd = "primary_\(currentTimeInMiliseconds())id"
        }
        
        
        var dic_businessData = ["name": str_name,
                                "company": str_company,
                                "position": str_position,
                                "address": str_address,
                                "city": str_city,
                                "zipcode": str_zipcode,
                                "email": str_email,
                                "phone": str_phone,
                                "secondary_phone": str_secondary_phone,
                                "background_image": background_pic,
                                "logo_image": logo_pic,
                                "profile_image": profile_pic,
                                "qr_code": qr_code,
                                "user_id": GetUserID(),
                                "location" : is_location,
                                "id": str_iddd,
                                "latitude": appDelegate.latitude,
                                "longitude": appDelegate.longitude] as [String : Any]

        if appDelegate.create_business_screenFrom == .edit {
            dic_businessData = ["name": str_name, "company": str_company, "position": str_position,
                                "address": str_address, "city": str_city, "zipcode": str_zipcode,
                                "email": str_email, "phone": str_phone, "secondary_phone": str_secondary_phone,
                                "background_image": background_pic, "logo_image": logo_pic, "profile_image": profile_pic, "location" : is_location,
                                "latitude": appDelegate.latitude, "longitude": appDelegate.longitude] as [String : Any]

            self.ref.child("business_detail").child(GetUserID()).child(str_iddd).updateChildValues(dic_businessData)
        }
        else {
            self.ref.child("business_detail").child(GetUserID()).childByAutoId().updateChildValues(dic_businessData)
        }
        DismissProgressHud()
        appDelegate.int_CreateBusinessDetail = 0
        appDelegate.is_myProfileListRefresh = true
        let viewControllers = self.navigationController!.viewControllers as [UIViewController]
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: TabbarVC.self) {
                self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }

    //MARK: - UIButton Action Method
    @IBAction func btn_Back_Action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Cancel_Action(_ sender: UIButton) {
        appDelegate.int_CreateBusinessDetail = 0
        let viewControllers = self.navigationController!.viewControllers as [UIViewController]
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: TabbarVC.self) {
                self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    
}

//MARK: - UITableView Delegate Datasource Method
extension Create_BusinessCardStepVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func setupDataforEdit() {
        appDelegate.dic_ValueforCreate_BusinessItem = self.dic_business_Detail

        let str_background_imgLink = self.dic_business_Detail["background_image"] as? String ?? ""
        let str_logo_imgLink = self.dic_business_Detail["logo_image"] as? String ?? ""
        let str_profile_imgLink = self.dic_business_Detail["profile_image"] as? String ?? ""
        
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            
                self.imageloading(str_imageLink: str_background_imgLink) { (ImgData, success) in
                    if success {
                        appDelegate.dic_ValueforCreate_BusinessItem["background_pic"] = ImgData
                    }
                }
                
                self.imageloading(str_imageLink: str_logo_imgLink) { (ImgData, success) in
                    if success {
                        appDelegate.dic_ValueforCreate_BusinessItem["logo_pic"] = ImgData
                    }
                }
                
                self.imageloading(str_imageLink: str_profile_imgLink) { (ImgData, success) in
                    if success {
                        appDelegate.dic_ValueforCreate_BusinessItem["profile_pic"] = ImgData
                    }
                }
            
        })
        
        //DispatchQueue.global().sync {
            
        //}

        self.manageSection()
    }
    
    func manageSection() {
        self.arr_section.removeAll()
        
        var str_Key1 = ""
        var str_Key2 = ""
        var str_Key3 = ""
        var str_Titleee1 = ""
        var str_Titleee2 = ""
        var str_Titleee3 = ""
        if appDelegate.int_CreateBusinessDetail == 0 {
            str_Key1 = "name"
            str_Key2 = "company"
            str_Key3 = "position"
            str_Titleee1 = "Name:"
            str_Titleee2 = "Company:"
            str_Titleee3 = "Position:"
            self.arr_section.append(["key": "header", "title": "TELL US LITTLE BIT MORE\nABOUT YOURSELF", "image": #imageLiteral(resourceName: "icon_1"), "identity": "image_header"])
            self.arr_section.append(["key": str_Key1, "title": str_Titleee1, "identity": "text_field"])
            self.arr_section.append(["key": str_Key2, "title": str_Titleee2, "identity": "text_field"])
            self.arr_section.append(["key": str_Key3, "title": str_Titleee3, "identity": "text_field"])
        }
        else if appDelegate.int_CreateBusinessDetail == 1 {
            str_Key1 = "address"
            //str_Key2 = "city"
            //str_Key3 = "zipcode"
            str_Titleee1 = "Address:"
            //str_Titleee2 = "City:"
            //str_Titleee3 = "Zipcode:"
            self.arr_section.append(["key": "header", "title": "TELL US ABOUT YOUR COMPANY", "image": #imageLiteral(resourceName: "icon_2"), "identity": "image_header"])
            self.arr_section.append(["key": str_Key1, "title": str_Titleee1, "identity": "address_text_field"])
            
        }
        else if appDelegate.int_CreateBusinessDetail == 2 {
            str_Key1 = "email"
            str_Key2 = "phone"
            str_Key3 = "secondary_phone"
            str_Titleee1 = "Email address:"
            str_Titleee2 = "Phone:"
            str_Titleee3 = "Secondary phone:"
            self.arr_section.append(["key": "header", "title": "HOW CAN YOUR CUSTOMER\nCONTACT YOU", "image": #imageLiteral(resourceName: "icon_2"), "identity": "image_header"])
            self.arr_section.append(["key": str_Key1, "title": str_Titleee1, "identity": "text_field"])
            self.arr_section.append(["key": str_Key2, "title": str_Titleee2, "identity": "text_field"])
            self.arr_section.append(["key": str_Key3, "title": str_Titleee3, "identity": "text_field"])
        }
        
        if appDelegate.int_CreateBusinessDetail == 3 {
            self.arr_section.removeAll()
            self.arr_section.append(["key": "header", "title": "CUSTOMIZE YOUR BUSINESS\nCARD DESIGN", "image": #imageLiteral(resourceName: "icon_4"), "identity": "image_header"])

            self.arr_section.append(["key": "background_pic", "title": "Background image", "image": #imageLiteral(resourceName: "icon_image"), "identity": "image_selection"])
            self.arr_section.append(["key": "logo_pic", "title": "Logo image", "image": #imageLiteral(resourceName: "icon_image"), "identity": "image_selection"])
        }
        else if appDelegate.int_CreateBusinessDetail == 4 {
            self.arr_section.removeAll()
            self.arr_section.append(["key": "header", "title": "HOW CAN YOUR CUSTOMER\nCONTACT YOU", "image": #imageLiteral(resourceName: "icon_5"), "identity": "image_header"])

            self.arr_section.append(["key": "profile_pic", "title": "Profile image", "image": #imageLiteral(resourceName: "icon_image"), "identity": "image_selection"])
            self.arr_section.append(["key": "location", "title": "Enable location", "identity": "location"])
        }
        
        let str_ButtonText = appDelegate.int_CreateBusinessDetail == 4 ? "FINISH" : "NEXT"
        self.arr_section.append(["key": "button", "title": str_ButtonText, "identity": "next_button"])
        self.tbl_View.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionDetail = self.arr_section[indexPath.row]
        let key = sectionDetail["key"] as? String ?? ""
        let identity = sectionDetail["identity"] as? String ?? ""
        
        if identity == "image_header" {
            let cell: Header_TableCell = tableView.dequeueReusableCell(withIdentifier: "Header_TableCell") as! Header_TableCell
            cell.selectionStyle = .none
            
            if let img = sectionDetail["image"] as? UIImage {
                cell.img_Header.image = img
            }
            
            cell.lbl_Title.text = sectionDetail["title"] as? String ?? ""
            
            return cell
        }
        else if identity == "next_button" {
            let cell: NextButtonTableCell = tableView.dequeueReusableCell(withIdentifier: "NextButtonTableCell") as! NextButtonTableCell
            cell.selectionStyle = .none
            cell.btn_Tititle.text = sectionDetail["title"] as? String ?? ""
            
            //Next Button Click Ecent
            cell.didTappedOnNextButton = {(sender) in
                self.view.endEditing(true)
                self.next_Action()
            }
            
            return cell
        }
        else if identity == "image_selection" {
            let cell: SelectImageTableCell = tableView.dequeueReusableCell(withIdentifier: "SelectImageTableCell") as! SelectImageTableCell
            cell.selectionStyle = .none
            cell.img_mainImage.image = nil
            cell.img_mainImage.contentMode = .scaleAspectFill
            cell.lbl_title.text = sectionDetail["title"] as? String ?? ""
            cell.lbl_title.textAlignment = key == "profile_pic" ? .left : .center
            
            if let selected_image = appDelegate.dic_ValueforCreate_BusinessItem[key] as? UIImage {
                cell.img_plaeholder.isHidden = true
                cell.img_mainImage.image = selected_image
            }
            else {
                cell.img_mainImage.image = nil
                cell.img_plaeholder.isHidden = false
            }
            
            //Image Pick Button Click Event
            cell.didTappedOnCellForImagePicker = {(sender) in
                self.view.endEditing(true)
                self.str_selected_Key = key
                self.openImagePicker()
            }
            
            return cell
        }
        else if identity == "location" {
            let cell: LocationTableCell = tableView.dequeueReusableCell(withIdentifier: "LocationTableCell") as! LocationTableCell
            cell.selectionStyle = .none
            cell.lbl_title.text = sectionDetail["title"] as? String ?? ""
            cell.btn_enable.addTarget(self, action: #selector(btn_switch_action(_:)), for: UIControl.Event.valueChanged)
            
            return cell
        }
        else {
            
            let cell: TextFildTableCell = tableView.dequeueReusableCell(withIdentifier: "TextFildTableCell") as! TextFildTableCell
            cell.selectionStyle = .none
            cell.txt_fild.delegate = self
            cell.txt_fild.accessibilityHint = key
            cell.txt_fild.text = appDelegate.dic_ValueforCreate_BusinessItem[key] as? String ?? ""
            cell.lbl_Title.text = sectionDetail["title"] as? String ?? ""
            
            if key == "zipcode" {
                cell.txt_fild.addDoneToolbar()
                cell.txt_fild.keyboardType = .numberPad
            }
            else if key == "email" {
                cell.txt_fild.keyboardType = .emailAddress
            }
            else if key == "phone" || key == "secondary_phone" {
                cell.txt_fild.addDoneToolbar()
                cell.txt_fild.keyboardType = .phonePad
            }
            else {
                cell.txt_fild.keyboardType = .default
                cell.txt_fild.autocapitalizationType = .sentences
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func btn_switch_action(_ sender: UISwitch) {
        if sender.isOn {
            appDelegate.dic_ValueforCreate_BusinessItem["location"] = true
        }
        else {
            appDelegate.dic_ValueforCreate_BusinessItem["location"] = false
        }
    }
    
    
    //MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let str_text = textField.text {
            if let strkey = textField.accessibilityHint {
                appDelegate.dic_ValueforCreate_BusinessItem[strkey] = str_text
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  let strID = textField.accessibilityHint {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if strID == "name" || strID == "company" || strID == "position" || strID == "address" || strID == "city" || strID == "email" {
                return newString.length <= 50
            }
            else if strID == "zipcode" {
                let ACCEPTABLE_NUMBERS = "1234567890"
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_NUMBERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if string != filtered{
                    return false
                }
                return newString.length <= 6
            }
            else if strID == "phone" || strID == "secondary_phone" {
                let ACCEPTABLE_NUMBERS = "1234567890"
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_NUMBERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if string != filtered{
                    return false
                }
                return newString.length <= 15
            }
        }
        return true
    }
}

//MARK: - UIImagePicker View Delegate Datasource method

extension Create_BusinessCardStepVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func openImagePicker() {
        
        let imageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            
            imageAlert.dismiss(animated: true, completion: nil)
        })
        
        let Capture = UIAlertAction.init(title: "Take Photo", style: .destructive, handler: { (action) in
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.cameraDevice = .rear
                self.imagePicker.showsCameraControls = true
                self.imagePicker.allowsEditing = true
            }
            else {
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = true
            }
            appDelegate.window?.rootViewController?.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let chosefromlib = UIAlertAction.init(title: "Choose Photo", style: .default, handler: { (action) in

            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true

            appDelegate.window?.rootViewController?.present(self.imagePicker, animated: true, completion: nil)
            
        })
        
        imageAlert.addAction(Capture)
        imageAlert.addAction(chosefromlib)
        imageAlert.addAction(cancel)
        
        if let presenter = imageAlert.popoverPresentationController {
            presenter.sourceView = self.tbl_View
            presenter.sourceRect = self.tbl_View.frame
        }
        appDelegate.window?.rootViewController?.present(imageAlert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let PickedImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                appDelegate.dic_ValueforCreate_BusinessItem[self.str_selected_Key] = PickedImage
                
                if self.str_selected_Key == "background_pic" {
                    appDelegate.is_background_pic_change = true
                    
                }
                else if self.str_selected_Key == "logo_pic" {
                    appDelegate.is_logo_pic_change = true
                    
                }
                else if self.str_selected_Key == "profile_pic" {
                    appDelegate.is_profile_pic_change = true
                    
                }

                self.tbl_View.reloadData()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.str_selected_Key = ""
        }
    }
    
    
}



//MARK: - API CALL
extension Create_BusinessCardStepVC {
    //MARK: Upload image
    func ImageUpload_onFirebaseStorage(_ img: UIImage, keyName: String, FolderName: String, completion:@escaping (Bool)->Void) {
        if let uploadImgData = img.jpegData(compressionQuality: 0.5) {
            let storageRef = Storage.storage().reference().child(FolderName).child("\(randomString())_\(keyName).png")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            storageRef.putData(uploadImgData, metadata: metadata) { [weak self] (metadata, error) in
                DispatchQueue.main.async {
                    
                    if let error = error {
                        print("Error uploading: \(error)")
                        completion(false)
                        return
                    }
                    guard self != nil else {
                        completion(false)
                        return }
                    storageRef.downloadURL(completion: { (url, error) in
                        DispatchQueue.main.async {
                            if let strImgurl = url?.absoluteString {
                                debugPrint("Upload Image URL======>>\(url?.absoluteString ?? "")")
                                appDelegate.dic_ValueforCreate_BusinessItem[keyName] = strImgurl
                                completion(true)
                            }
                            else {
                                completion(false)
                            }
                        }
                    })
                }
            }
        }
        else {
            completion(false)
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    
    //MARK: - Image Loading
    func imageloading(str_imageLink: String, completion: @escaping ((Any?, Bool) -> Void)) {
        var arr_Img: Any?
        if let strImg = str_imageLink as? String {
            let imageUrl = URL(string: strImg)!
            do {
                let imageData = try Data(contentsOf: imageUrl)
                let img_Task = UIImage(data: imageData) ?? #imageLiteral(resourceName: "icon_image")
                arr_Img = img_Task
            }
            catch {
            }
        }
        
        completion(arr_Img, true)
    }
}
