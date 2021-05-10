//
//  ForgotPassworVC.swift
//  Zhen Demo
//
//  Created by Teddys on 30/05/20.
//  Copyright © 2020 Teddys. All rights reserved.
//

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
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - Check Validation
    func checkInputValidations() -> (Title:String,Message:String)? {
        let str_email = self.dicValue["email"] as? String ?? ""
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

////MARK: - UITableView Delegate Datasource Method
//extension ForgotPassworVC: UITableViewDelegate, UITableViewDataSource {
//
//    func manageSection() {
//        self.arrSection.removeAll()
//        self.arrSection.append(["key": "header", "title" : "Register", "placeholder" : "", "icon": nil, "identity" : "header"])
//        self.arrSection.append(["key": "email", "title" : "Email Address", "placeholder" : "Email Address", "icon": nil, "identity" : "textField"])
//        self.arrSection.append(["key": "reset_passwor", "title" : "Reset Password", "placeholder" : "", "icon": nil, "identity" : "Button"])
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
//            cell.btn_Title.text = dic["title"] as? String ?? ""
//            cell.btnSignUp.backgroundColor = AppColor.blue
//            cell.btnSignUp.addTarget(self, action: #selector(btn_clkToResetPassword_Action), for: .touchUpInside)
//
//            return cell
//        }
//        else {
//
//            let cell: TextFieldTableCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableCell", for: indexPath) as! TextFieldTableCell
//            cell.selectionStyle = .none
//            cell.txtValue.delegate = self
//            cell.txtValue.accessibilityHint = dic["key"] as? String ?? ""
//            cell.txtValue.placeholder = dic["placeholder"] as? String ?? ""
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
