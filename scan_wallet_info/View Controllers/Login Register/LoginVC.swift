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
        self.email_TextField.delegate = self
        self.password_TextField.delegate = self
        ref = Database.database().reference()
    }
    
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
                    }
                }
            }
        }
    }

    // MARK: - Navigation
    // MARK: - UITextfield Delegate Method
    
    func textFieldDidBeginEditing(_ textField: UITextField) { }
    
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
        
        
        
    
