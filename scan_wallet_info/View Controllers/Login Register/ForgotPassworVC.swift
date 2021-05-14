import UIKit
import Firebase

class ForgotPassworVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    var dicValue = [String: Any]()
    //var arrSection = [[String : Any?]]()
    //  @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: emailTextField.frame.height - 2, width: emailTextField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        
        emailTextField.borderStyle = .none
        emailTextField.backgroundColor = .none
        emailTextField.layer.addSublayer(bottomLine)
        
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Check Validation
    func checkInputValidations() -> (Title:String,Message:String)? {
        let str_email = emailTextField.text!
        if str_email.trimed() == "" {
            return ("Email","Please enter email")
        }
        else if !isValidEmail(email: str_email.trimed() ) {
            return ("Email","Please enter a valid email")
        }
        return nil
    }

    //MARK: - Register Method
    func forgotPasword_Action() {
        ShowProgressHud(message: AppMessage.plzWait)
        let email = self.emailTextField.text!

        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            DismissProgressHud()
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
                    showSingleAlert(Title: "", Message: "\(error.localizedDescription)", buttonTitle: AppMessage.Ok, delegate: self) { }
                }
            }
            else {
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.view.makeToast("Reset password email has been successfully sent")
            }
        }
    }

    // MARK: - UITextfield Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let strText = textField.text {
            if let key = textField.accessibilityHint {
                self.dicValue[key] = strText.trimed()
            }
        }
    }

    // MARK: - UIButton Method Action
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if let error = checkInputValidations() {
            //Invalid data
            showSingleAlert(Title: error.Title, Message: error.Message, buttonTitle: AppMessage.Ok, delegate: self) { }
        }
        else {
            self.forgotPasword_Action()
        }
    }
    
   
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let objlogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(objlogin, animated: true)
    }
}
