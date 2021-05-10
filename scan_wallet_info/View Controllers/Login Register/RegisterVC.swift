//
//  RegisterVC.swift
//  Zhen Demo
//
//  Created by Teddys on 30/05/20.
//  Copyright © 2020 Teddys. All rights reserved.
//

//import UIKit
//import Firebase
//import FirebaseStorage
//import FirebaseDatabase
//
//class RegisterVC: UIViewController, UITextFieldDelegate {
//
//    var ref: DatabaseReference!
//    var dic_Value = [String: Any]()
//    var arrSection = [[String : Any?]]()
//    @IBOutlet weak var tblView: UITableView!
//    @IBOutlet weak var constraint_tblViewBottom: NSLayoutConstraint!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        self.manageSection()
//        ref = Database.database().reference()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    // MARK:- KEYBOARD METHODS
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let userinfo:NSDictionary = (notification.userInfo as NSDictionary?) {
//            if let keybordsize = (userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                let bottomSafeArea = appDelegate.window?.safeAreaInsets.bottom ?? 0
//                let keyboardHeight = keybordsize.height - bottomSafeArea
//                self.constraint_tblViewBottom.constant = keyboardHeight
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        self.constraint_tblViewBottom.constant = 0
//        self.view.layoutIfNeeded()
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//
//    //MARK: - Check Validation
//    func checkInputValidations() -> (Title:String,Message:String)? {
//        let fName = self.dic_Value["first_name"] as? String
//        let lName = self.dic_Value["last_name"] as? String
//        let email = self.dic_Value["email"] as? String
//        let password = self.dic_Value["password"] as? String
//        if fName?.trimed() == nil || fName?.trimed() == "" {
//            return ("First Name","Please enter first name.")
//        }
//        else if lName?.trimed() == nil || lName?.trimed() == "" {
//            return ("Last Name","Please enter last name.")
//        }
//        else if email?.trimed() == nil || email?.trimed() == "" {
//            return ("Email","Please enter email")
//        }
//        else if !isValidEmail(email: email?.trimed() ?? "") {
//            return ("Email","Please enter a valid email")
//        }
//        else if password?.trimed() == nil || password?.trimed() == "" {
//            return ("Password","Please enter password")
//        }
//
//        return nil
//    }
//
//
//    //MARK: - Register Method
//    func register_Action() {
//        ShowProgressHud(message: AppMessage.plzWait)
//        let email = self.dic_Value["email"] as? String ?? ""
//        let password = self.dic_Value["password"] as? String ?? ""
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error as NSError? {
//                DismissProgressHud()
//                if AuthErrorCode.init(rawValue: error.code) == .emailAlreadyInUse {
//                    showSingleAlert(Title: "", Message: "Email is already exists", buttonTitle: AppMessage.Ok, delegate: self) { }
//                }
//                else if AuthErrorCode.init(rawValue: error.code) == .weakPassword {
//                    showSingleAlert(Title: "", Message: "The password must be 6 characters long or more", buttonTitle: AppMessage.Ok, delegate: self) { }
//                }
//                else if AuthErrorCode.init(rawValue: error.code) == .invalidEmail {
//                    showSingleAlert(Title: "", Message: "Invalid email", buttonTitle: AppMessage.Ok, delegate: self) { }
//                }
//                else {
//                    print("Error: \(error.localizedDescription)")
//                }
//          } else {
//                print("User signs up successfully")
//                let userData = ["login_with": "normal",
//                                "email": self.dic_Value["email"] as? String ?? "",
//                                "firstName": self.dic_Value["first_name"] as? String ?? "",
//                                "lastName": self.dic_Value["last_name"] as? String ?? ""]
//                let newUserInfo = Auth.auth().currentUser
//                if let user = newUserInfo {
//                    self.login_Action()
//                    self.ref.child("users").child(user.uid).updateChildValues(userData)
//                }
//            }
//        }
//    }
//
//    // MARK: - Login
//    func login_Action() {
//        let email = self.dic_Value["email"] as? String ?? ""
//        let password = self.dic_Value["password"] as? String ?? ""
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//            DismissProgressHud()
//            if let error = error as NSError? {
//                if AuthErrorCode.init(rawValue: error.code) == .userNotFound {
//                    showSingleAlert(Title: "", Message: "This email is not register,\nPlease sign up", buttonTitle: AppMessage.Ok, delegate: self) { }
//                }
//                else if AuthErrorCode.init(rawValue: error.code) == .wrongPassword {
//                    showSingleAlert(Title: "", Message: "Password wrong", buttonTitle: AppMessage.Ok, delegate: self) { }
//                }
//                else if AuthErrorCode.init(rawValue: error.code) == .invalidEmail {
//                    showSingleAlert(Title: "", Message: "Invalid email", buttonTitle: AppMessage.Ok, delegate: self) { }
//                }
//                else {
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//            else {
//                print("User signs in successfully")
//                if let curretAuth = Auth.auth().currentUser {
//                    UserDefaults.appSetObject(curretAuth.uid, forKey: AppMessage.uID)
//                    FirebaseManager.shared.GetUserNameEmailFromFirebaseStorage(curretAuth.uid) {
//                        UserDefaults.appSetObject(true, forKey: AppMessage.login)
//                        UserDefaults.appSetObject(password, forKey: AppMessage.passworddddd)
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC")
//                        self.navigationController?.pushViewController(vc!, animated: true)
//                    }
//                }
//            }
//        }
//    }
//
//    // MARK: - UITextfield Delegate Method
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let strText = textField.text {
//            if let key = textField.accessibilityHint {
//                self.dic_Value[key] = strText.trimed()
//            }
//        }
//    }
//
//
//    // MARK: - UIButton Method Action
//    @IBAction func btnAlreadyHaveAccount(_ sender: UIButton) {
//        let objlogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        self.navigationController?.pushViewController(objlogin, animated: true)
//    }
//
//    @objc func goToDashboardScreen() {
//        self.view.endEditing(true)
//        if let error = checkInputValidations() {
//            //Invalid data
//            showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
//        }
//        else {
//            print("Register")
//            self.register_Action()
//        }
//    }
//
//}
//
////MARK: - UITableView Delegate Datasource Method
//extension RegisterVC: UITableViewDelegate, UITableViewDataSource {
//
//    func manageSection() {
//        self.arrSection.removeAll()
//        self.arrSection.append(["key": "header", "title" : "Register", "placeholder" : "", "icon": nil, "identity" : "header"])
//        self.arrSection.append(["key": "first_name", "title" : "First Name", "placeholder" : "First Name", "icon": nil, "identity" : "textField"])
//        self.arrSection.append(["key": "last_name", "title" : "Last Name", "placeholder" : "Last Name", "icon": nil, "identity" : "textField"])
//        self.arrSection.append(["key": "email", "title" : "Email Address", "placeholder" : "Email Address", "icon": nil, "identity" : "textField"])
//        self.arrSection.append(["key": "password", "title" : "Password", "placeholder" : "Password", "icon": nil, "identity" : "textField"])
//        self.arrSection.append(["key": "button", "title" : "Sign Up", "placeholder" : "", "icon": nil, "identity" : "Button"])
//        self.tblView.reloadData()
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.arrSection.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let dic = self.arrSection[indexPath.row]
//        let key = dic["key"] as? String ?? ""
//        let identity = dic["identity"] as? String ?? ""
//        if identity == "header" {
//
//            let cell: RegisterHeaderTableCell = tableView.dequeueReusableCell(withIdentifier: "RegisterHeaderTableCell", for: indexPath) as! RegisterHeaderTableCell
//            cell.selectionStyle = .none
//
//            return cell
//        }
//        else if identity == "Button" {
//
//            let cell: RegisterButtonTableCell = tableView.dequeueReusableCell(withIdentifier: "RegisterButtonTableCell", for: indexPath) as! RegisterButtonTableCell
//            cell.selectionStyle = .none
//            cell.lblTitle.textColor = AppColor.blue
//            cell.btnSignUp.backgroundColor = AppColor.blue
//            cell.btnSignUp.addTarget(self, action: #selector(self.goToDashboardScreen), for: .touchUpInside)
//
//            return cell
//        }
//        else {
//
//            let cell: TextFieldTableCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableCell", for: indexPath) as! TextFieldTableCell
//            cell.selectionStyle = .none
//            cell.txtValue.delegate = self
//            cell.txtValue.accessibilityHint = key
//            cell.txtValue.placeholder = dic["placeholder"] as? String ?? ""
//            cell.txtValue.text = self.dic_Value[key] as? String ?? ""
//            cell.txtValue.isSecureTextEntry = key == "password" ? true : false
//
//            return cell
//
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
//
//
//
////MARK: UITableView Clss
//class RegisterHeaderTableCell: UITableViewCell {
//
//    @IBOutlet weak var view_base: UIView!
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var img_logo: UIImageView!
//}
//
//class TextFieldTableCell: UITableViewCell {
//
//    @IBOutlet weak var view_base: UIView!
//    @IBOutlet weak var txtValue: UITextField!
//}
//
//
//class RegisterButtonTableCell: UITableViewCell {
//
//    @IBOutlet weak var btnSignUp: UIControl!
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var btn_Title: UILabel!
//    @IBOutlet weak var btnAlredysignUp: UIButton!
//}
//


import UIKit
import FirebaseAuth
import Firebase
import JGProgressHUD
import FirebaseStorage
import FirebaseDatabase




class ResgisterVC: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    var dic_Value = [String: Any]()
    var arrSection = [[String : Any?]]()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
        
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
        ref = Database.database().reference()
        checkButton.setImage(UIImage(named:"Assetrwe3"), for: .normal)
        checkButton.setImage(UIImage(named:"Asset534"), for: .selected)
        
        let bottomLine = CALayer()
        let bottomLine1 = CALayer()
        let bottomLine2 = CALayer()
        let bottomLine3 = CALayer()
        let bottomLine4 = CALayer()
        bottomLine.frame = CGRect(x: 0, y: emailTextField.frame.height - 2, width: emailTextField.frame.width, height: 2)
        bottomLine2.frame = CGRect(x: 0, y: passwordTextField.frame.height - 2, width: passwordTextField.frame.width, height: 2)
        bottomLine3.frame = CGRect(x: 0, y: repeatPasswordTextField.frame.height - 2, width: repeatPasswordTextField.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        bottomLine1.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        bottomLine2.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        bottomLine3.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        bottomLine4.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = .none
        
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = .none
        
        repeatPasswordTextField.borderStyle  = .none
        repeatPasswordTextField.backgroundColor = .none
        
        emailTextField.layer.addSublayer(bottomLine)
        passwordTextField.layer.addSublayer(bottomLine2)
        repeatPasswordTextField.layer.addSublayer(bottomLine3)
        
        SignUpButton.isEnabled = false
        emailTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
    }
    
    
    //MARK: - Check Validation
    func checkInputValidations() -> (Title:String,Message:String)? {
        let str_email = self.emailTextField.text ?? ""
        let str_password = self.passwordTextField.text ?? ""
        if str_email.trimed() == "" {
            return ("Email","Please enter email")
        }
        else if !isValidEmail(email: str_email.trimed() ) {
            return ("Email","Please enter a valid email")
        }
        else if str_password.trimed() == "" {
            return ("Password","Please enter password")
        }
        return nil
    }
    
    
    //MARK: - Register Method
    func register_Action(email: String, password: String) {
        ShowProgressHud(message: AppMessage.plzWait)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                DismissProgressHud()
                if AuthErrorCode.init(rawValue: error.code) == .emailAlreadyInUse {
                    showSingleAlert(Title: "", Message: "Email is already exists", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else if AuthErrorCode.init(rawValue: error.code) == .weakPassword {
                    showSingleAlert(Title: "", Message: "The password must be 6 characters long or more", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else if AuthErrorCode.init(rawValue: error.code) == .invalidEmail {
                    showSingleAlert(Title: "", Message: "Invalid email", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else {
                    print("Error: \(error.localizedDescription)")
                }
          } else {
                print("User signs up successfully")
                let userData = ["login_with": "normal",
                                "email": self.dic_Value["email"] as? String ?? "",
                                "firstName": self.dic_Value["first_name"] as? String ?? "",
                                "lastName": self.dic_Value["last_name"] as? String ?? ""]
                let newUserInfo = Auth.auth().currentUser
                if let user = newUserInfo {
                    self.login_Action(email: self.emailTextField.text!, password: self.passwordTextField.text!)
                    self.ref.child("users").child(user.uid).updateChildValues(userData)
                }
            }
        }
    }
    
    // MARK: - Login
    func login_Action(email: String, password: String) {
        ShowProgressHud(message: AppMessage.plzWait)
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError? {
                DismissProgressHud()
                if AuthErrorCode.init(rawValue: error.code) == .userNotFound {
                    showSingleAlert(Title: "", Message: "This email is not register,\nPlease sign up", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else if AuthErrorCode.init(rawValue: error.code) == .wrongPassword {
                    showSingleAlert(Title: "", Message: "Password wrong", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else if AuthErrorCode.init(rawValue: error.code) == .invalidEmail {
                    showSingleAlert(Title: "", Message: "Invalid email", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
                else {
                    print("Error: \(error.localizedDescription)")
                }
            }
            else {
                print("User signs in successfully")
                if let curretAuth = Auth.auth().currentUser {
                    UserDefaults.appSetObject(curretAuth.uid, forKey: AppMessage.uID)
                    FirebaseManager.shared.GetUserNameEmailFromFirebaseStorage(curretAuth.uid) {
                        DismissProgressHud()
                        UserDefaults.appSetObject(true, forKey: AppMessage.login)
                        UserDefaults.appSetObject(password, forKey: AppMessage.passworddddd)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC")
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }
            }
        }
    }

    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty
        else {
            SignUpButton.isEnabled = false
            return
        }
        SignUpButton.isEnabled = true
    }
    
    
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
    
    
    // MARK: - UITextfield Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func showLoadingHUD() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            self.incrementHUD(hud, progress: 0)
        }
    }
    
    func incrementHUD(_ hud: JGProgressHUD, progress previousProgress: Int) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            UIView.animate(withDuration: 0.1, animations: {
                hud.textLabel.text = "Success"
                hud.detailTextLabel.text = nil
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
            })
            
            hud.dismiss(afterDelay: 1.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
        }
        
    }
    
//    //MARK: - Check Validation
//    func checkInputValidations() -> (Title:String,Message:String)? {
//
//        let email = emailTextField.text
//        let password = passwordTextField.text
//        let repeatPasssword = repeatPasswordTextField.text
//
//        if email?.trimed() == nil || email?.trimed() == "" {
//            return ("Email","Please enter email")
//        }
//
//        else if !isValidEmail(email: email?.trimed() ?? "") {
//            return ("Email","Please enter a valid email")
//        }
//
//        else if password?.trimed() == nil || password?.trimed() == "" {
//            return ("Password","Please enter password")
//        }
//
//
//        else if repeatPasssword?.trimed() == nil || repeatPasssword?.trimed() == "" {
//            return ("Password","Please enter password")
//        }
//
//        else if password != repeatPasssword {
//            return ("Password","Password does not match")
//        }
//
//        return nil
//    }
    
    
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                    sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    
                }) { (success) in
                    UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                        sender.isSelected = !sender.isSelected
                        sender.transform = .identity
                    }, completion: nil)
                }
       }
    
//
//    func register() {
//
//        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        // Create the user
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//
//            if let error = error as NSError? {
//
//                if AuthErrorCode.init(rawValue: error.code) == .emailAlreadyInUse {
//
//                    let hud = JGProgressHUD(style: .dark)
//                    hud.vibrancyEnabled = true
//                    hud.textLabel.text = "The email is already in use"
//                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    hud.show(in: self.view)
//                    hud.dismiss(afterDelay: 3.0)
//
//                }
//                else if AuthErrorCode.init(rawValue: error.code) == .weakPassword {
//
//                    let hud = JGProgressHUD(style: .dark)
//                    hud.vibrancyEnabled = true
//                    hud.textLabel.text = "Password must be 6 characters long or more"
//                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    hud.show(in: self.view)
//                    hud.dismiss(afterDelay: 3.0)
//
//                }
//                else if AuthErrorCode.init(rawValue: error.code) == .invalidEmail {
//
//                    let hud = JGProgressHUD(style: .dark)
//                    hud.vibrancyEnabled = true
//                    hud.textLabel.text = "Invalid email"
//                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    hud.show(in: self.view)
//                    hud.dismiss(afterDelay: 3.0)
//
//                }
//                else {
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//
//            else {
//
//                // User was created successfully, now store the first name and last name
//                let db = Firestore.firestore()
//                db.collection("users").addDocument(data: ["email": email, "uid": result!.user.uid ]) { (error) in
//
//                    if error != nil {
//
//                        let hud = JGProgressHUD(style: .dark)
//                        hud.vibrancyEnabled = true
//                        hud.textLabel.text = "An error has occurred, please try again"
//                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                        hud.show(in: self.view)
//                        hud.dismiss(afterDelay: 3.0)
//
//                    }
//                }
//
//                self.showLoadingHUD()
//
//
//            }
//        }
//
//    }
    

    
    @IBAction func SignUpPressed(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if let error = checkInputValidations() {
            
            let hud = JGProgressHUD(style: .dark)
            hud.vibrancyEnabled = true
            hud.textLabel.text = String(error.Message)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 3.0)
            
        }
        else {
            
            self.view.endEditing(true)
            if let error = checkInputValidations() {
                //Invalid data
                showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                print("Register")
                self.register_Action(email: self.emailTextField.text!, password: self.passwordTextField.text!)
            }
            
            
        }
    }
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        let objlogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(objlogin, animated: true)
        
    }
    
    
}


