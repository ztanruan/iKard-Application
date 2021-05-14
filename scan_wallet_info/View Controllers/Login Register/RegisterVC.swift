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
    
    @objc func DismissKeyboard(){ view.endEditing(true) }
    
    // MARK: - UITextfield Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {}
    
    
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
