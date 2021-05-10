//import UIKit
//import Firebase
//import FirebaseStorage
//import FirebaseDatabase
//
//
//class LoginVC: UIViewController, UITextFieldDelegate {
//
//    var ref: DatabaseReference!
//    @IBOutlet weak var txt_email: UITextField!
//    @IBOutlet weak var txt_password: UITextField!
//    @IBOutlet weak var btnForgotpassword: UIButton!
//    @IBOutlet weak var btnLogin: UIControl!
//    @IBOutlet weak var lbl_alreadyLogin: UILabel!
//    @IBOutlet weak var btn_faceid: UIControl!
//    @IBOutlet weak var btn_Continue: UIControl!
//    @IBOutlet weak var img_FaceID: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        self.AttributeTextForSignUp()
//        self.txt_email.delegate = self
//        self.txt_password.delegate = self
//        ref = Database.database().reference()
//        //====================================//
//        //************************************//
//
//        self.btnLogin.backgroundColor = AppColor.blue
//        self.btnForgotpassword.setTitleColor(AppColor.blue, for: UIControl.State.normal)
//        //**********************************************************************************************//
//        //**********************************************************************************************//
//    }
//
//    func AttributeTextForSignUp() {
//        //For Attribute Text
//        let newText = NSMutableAttributedString.init(string: "Don't have an account? SIGN UP")
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        newText.addAttribute(NSAttributedString.Key.font,
//                             value: UIFont.AppFontRegular(15),
//                             range: NSRange.init(location: 0, length: newText.length))
//        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: NSRange.init(location: 0, length: newText.length))
//        newText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSRange.init(location: 0, length: newText.length))
//
//        let textRange = NSString(string: "Don't have an account? SIGN UP")
//        let termrange = textRange.range(of: "SIGN UP")
//
//        newText.addAttribute(NSAttributedString.Key.font, value: UIFont.AppFontRegular(16), range: termrange)
//        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor.blue, range: termrange)
//        self.lbl_alreadyLogin.attributedText = newText
//
//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(TapResponce(_:)))
//        self.lbl_alreadyLogin.isUserInteractionEnabled = true
//        self.lbl_alreadyLogin.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func TapResponce(_ sender: UITapGestureRecognizer) {
//        let signUpRange = ("Don't have an account? SIGN UP" as NSString).range(of: "SIGN UP")
//        if (sender.didTapAttributedTextInLabel(label: self.lbl_alreadyLogin, inRange: signUpRange)) {
//            let objRegister = Story_Main.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
//            self.navigationController?.pushViewController(objRegister, animated: true)
//            return
//        }
//    }
//
//
//
//    //MARK: - Check Validation
//    func checkInputValidations() -> (Title:String,Message:String)? {
//        let str_email = self.txt_email.text ?? ""
//        let str_password = self.txt_password.text ?? ""
//        if str_email.trimed() == "" {
//            return ("Email","Please enter email")
//        }
//        else if !isValidEmail(email: str_email.trimed() ) {
//            return ("Email","Please enter a valid email")
//        }
//        else if str_password.trimed() == "" {
//            return ("Password","Please enter password")
//        }
//        return nil
//    }
//
//
//    // MARK: - Login
//    func login_Action(email: String, password: String) {
//        ShowProgressHud(message: AppMessage.plzWait)
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//            if let error = error as NSError? {
//                DismissProgressHud()
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
//                        DismissProgressHud()
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
//
//
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
//    // MARK: - UITextfield Delegate Method
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//
//    // MARK: - UIButton Method Action
//    @IBAction func btn_Login_Action(_ sender: UIControl) {
//
//        if let error = checkInputValidations() {
//            //Invalid data
//            showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
//        }
//        else {
//            print("Login With Email and Password")
//            let str_email = self.txt_email.text ?? ""
//            let str_password = self.txt_password.text ?? ""
//            self.login_Action(email: str_email, password: str_password)
//        }
//    }
//
//    @IBAction func btnForgotPassword_Action(_ sender: UIControl) {
//        let objForgotPass = Story_Main.instantiateViewController(withIdentifier: "ForgotPassworVC") as! ForgotPassworVC
//        self.navigationController?.pushViewController(objForgotPass, animated: true)
//    }
//
//}

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD

class LoginVC: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var email_TextField: UITextField!
    @IBOutlet weak var password_TextField: UITextField!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let tap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
//        view.addGestureRecognizer(tap)
//
//        let bottomLine = CALayer()
//        let bottomLine1 = CALayer()
//        bottomLine.frame = CGRect(x: 0, y: password_TextField.frame.height - 2, width: password_TextField.frame.width, height: 2)
//        bottomLine1.frame = CGRect(x: 0, y: email_TextField.frame.height - 2, width: email_TextField.frame.width, height: 2)
//        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
//        bottomLine1.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
//
//        email_TextField.borderStyle = .none
//        email_TextField.backgroundColor = .none
//
//        password_TextField.borderStyle = .none
//        password_TextField.backgroundColor = .none
//
//        email_TextField.layer.addSublayer(bottomLine1)
//        password_TextField.layer.addSublayer(bottomLine)
//
//
//    }
//
//
//    // MARK: - UITextfield Delegate Method
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    @objc func DismissKeyboard(){
//        view.endEditing(true)
//    }
//
//    //MARK: - Check Textfields Information
//
//    func checkInputValidations() -> (Title:String,Message:String)? {
//
//        let str_email = self.email_TextField.text ?? ""
//        let str_password = self.password_TextField.text ?? ""
//        if str_email.trimed() == "" {
//            return ("Email","Please enter email")
//        }
//        else if !isValidEmail(email: str_email.trimed() ) {
//            return ("Email","Please enter a valid email")
//        }
//        else if str_password.trimed() == "" {
//            return ("Password","Please enter password")
//        }
//        return nil
//    }
//
//
//
//    func showLoadingHUD() {
//
//        let hud = JGProgressHUD(style: .dark)
//        hud.vibrancyEnabled = true
//        hud.textLabel.text = "Loading"
//        hud.show(in: self.view)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
//            self.incrementHUD(hud, progress: 0)
//        }
//    }
//
//    func incrementHUD(_ hud: JGProgressHUD, progress previousProgress: Int) {
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
//            UIView.animate(withDuration: 0.1, animations: {
//                hud.textLabel.text = "Success"
//                hud.detailTextLabel.text = nil
//                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
//            })
//
//            hud.dismiss(afterDelay: 1.0)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//
//
//            }
//        }
//
//    }
//
//
//    // MARK: - Login
//    func login (email: String, password: String) {
//
//        let email = email_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let password = password_TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//            if let error = error as NSError? {
//                if AuthErrorCode.init(rawValue: error.code) == .userNotFound {
//
//                    let hud = JGProgressHUD(style: .dark)
//                    hud.vibrancyEnabled = true
//                    hud.textLabel.text = "Account does not exits"
//                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    hud.show(in: self.view)
//                    hud.dismiss(afterDelay: 3.0)
//                }
//                else if AuthErrorCode.init(rawValue: error.code) == .wrongPassword {
//
//
//                    let hud = JGProgressHUD(style: .dark)
//                    hud.vibrancyEnabled = true
//                    hud.textLabel.text = "Incorrect password"
//                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    hud.show(in: self.view)
//                    hud.dismiss(afterDelay: 3.0)
//
//                }
//                else if AuthErrorCode.init(rawValue: error.code) == .invalidEmail {
//
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
//            else {
//
//                print("User signs in successfully")
//                self.showLoadingHUD()
//                if let curretAuth = Auth.auth().currentUser {
//                    UserDefaults.appSetObject(curretAuth.uid, forKey: AppMessage.uID)
//                    FirebaseManager.shared.GetUserNameEmailFromFirebaseStorage(curretAuth.uid) {
//                        UserDefaults.appSetObject(true, forKey: AppMessage.login)
//                        UserDefaults.appSetObject(password, forKey: AppMessage.passworddddd)
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC")
//                        self.navigationController?.pushViewController(vc!, animated: true)
//                    }
//                }
//
//
//            }
//        }
//    }
//
//
//
   
//
//
//}
//



    override func viewDidLoad() {
        super.viewDidLoad()
        
             
        
                let bottomLine = CALayer()
                let bottomLine1 = CALayer()
                bottomLine.frame = CGRect(x: 0, y: password_TextField.frame.height - 2, width: password_TextField.frame.width, height: 2)
                bottomLine1.frame = CGRect(x: 0, y: email_TextField.frame.height - 2, width: email_TextField.frame.width, height: 2)
                bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
                bottomLine1.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
                email_TextField.borderStyle = .none
                email_TextField.backgroundColor = .none
        
                password_TextField.borderStyle = .none
                password_TextField.backgroundColor = .none
        
                email_TextField.layer.addSublayer(bottomLine1)
                password_TextField.layer.addSublayer(bottomLine)
        
        
        
        // Do any additional setup after loading the view.
        //self.AttributeTextForSignUp()
        self.email_TextField.delegate = self
        self.password_TextField.delegate = self
        ref = Database.database().reference()
        //====================================//
        //************************************//

       // self.loginButton.backgroundColor = AppColor.blue
        //self.forgotPasswordButton.setTitleColor(AppColor.blue, for: UIControl.State.normal)
        //**********************************************************************************************//
        //**********************************************************************************************//
    }
    
//    func AttributeTextForSignUp() {
//        //For Attribute Text
//        let newText = NSMutableAttributedString.init(string: "Don't have an account? SIGN UP")
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .center
//        newText.addAttribute(NSAttributedString.Key.font,
//                             value: UIFont.AppFontRegular(15),
//                             range: NSRange.init(location: 0, length: newText.length))
//        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: NSRange.init(location: 0, length: newText.length))
//        newText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSRange.init(location: 0, length: newText.length))
//
//        let textRange = NSString(string: "Don't have an account? SIGN UP")
//        let termrange = textRange.range(of: "SIGN UP")
////
//        newText.addAttribute(NSAttributedString.Key.font, value: UIFont.AppFontRegular(16), range: termrange)
//        newText.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor.blue, range: termrange)
//        self.lbl_alreadyLogin.attributedText = newText

//        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(TapResponce(_:)))
//        self.lbl_alreadyLogin.isUserInteractionEnabled = true
//        self.lbl_alreadyLogin.addGestureRecognizer(tapGesture)
//    }

//    @objc func TapResponce(_ sender: UITapGestureRecognizer) {
//        let signUpRange = ("Don't have an account? SIGN UP" as NSString).range(of: "SIGN UP")
//        if (sender.didTapAttributedTextInLabel(label: self.lbl_alreadyLogin, inRange: signUpRange)) {
//            let objRegister = Story_Main.instantiateViewController(withIdentifier: "RegisterVC") as! registrationVC
//            self.navigationController?.pushViewController(objRegister, animated: true)
//            return
//        }
   // }
    
    
    
    //MARK: - Check Validation
    func checkInputValidations() -> (Title:String,Message:String)? {
        
        let str_email = self.email_TextField.text ?? ""
        let str_password = self.password_TextField.text ?? ""
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

                        
                        
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
//                        vc.modalPresentationStyle = .fullScreen
//                        self.present(vc, animated: true, completion: nil)
                        
                        
                        print("i am here")
                    }
                }
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
    
    // MARK: - UITextfield Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

        
        @IBAction func signInButtonPressed(_ sender: Any) {

            if let error = checkInputValidations() {
                //Invalid data
                showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
            }
            else {
                print("Login With Email and Password")
                let str_email = self.email_TextField.text ?? ""
                let str_password = self.password_TextField.text ?? ""
                self.login_Action(email: str_email, password: str_password)
            }
        }

        
        @IBAction func joinNowButtonPressed(_ sender: Any) {
            let objRegister = Story_Main.instantiateViewController(withIdentifier: "RegisterVC") as! ResgisterVC
            self.navigationController?.pushViewController(objRegister, animated: true)
            print("hjfkjds")
            return
          
        }


        
        @IBAction func forgotPasswordPressed(_ sender: Any) {
            let objForgotPass = Story_Main.instantiateViewController(withIdentifier: "ForgotPassworVC") as! ForgotPassworVC
            self.navigationController?.pushViewController(objForgotPass, animated: true)

        }

    }
        
        
        
    
