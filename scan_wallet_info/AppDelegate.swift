//
//  AppDelegate.swift
//  scan_wallet_info
//
//  Created by Teddys on 11/04/21.
//

import UIKit
import Firebase
import GoogleMaps
import SVProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var str_scannedQR_CODE = ""
    var is_logo_pic_change = false
    var is_background_pic_change = false
    var is_profile_pic_change = false
    var create_business_screenFrom = ScreenType.none
    var dic_ValueforCreate_BusinessItem = [String: Any]()
    var int_CreateBusinessDetail = 0
    var is_myProfileListRefresh = false
    var latitude = 0.0
    var longitude = 0.0
    var currentLatitude = 0.0
    var currentLongitude = 0.0
    let googleMapsApiKey = "AIzaSyBUY2VH7-urnQaILzx-4ZvIPTfIR2Y_DSs"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        checkRedirect()
        self.setProgressHud()
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK:- CUSTOM SETUP
    func setProgressHud(){
        //SVProgressHUD.setFont(UIFont.AppFontRegular(14))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    //MARK:- Set RootController
    func checkRedirect() {
        if let isLogin = UserDefaults.appObjectForKey(AppMessage.login) as? Bool {
            if isLogin {
                self.app_setDashBoard()
            }
        }
    }
    
    func app_setDashBoard() {
        //SET DASHBOARD VIEWCONTROLLER TO ROOT
        let dashboard = Story_Main.instantiateViewController(withIdentifier: "TabbarVC")
        let navi = UINavigationController.init(rootViewController: dashboard)
        navi.setNavigationBarHidden(true, animated: false)
        self.animatedAddtoRoot(toView: navi)
    }
//
//    func app_Login_screen() {
//        //SET LOGIN VIEWCONTROLLER TO ROOT
//        let objLogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC")
//        let navi = UINavigationController.init(rootViewController: objLogin)
//        navi.setNavigationBarHidden(true, animated: false)
//        self.animatedAddtoRoot(toView: navi)
//    }
//
//    func app_PhoneVerification_Screen() {
//        //SET LOGIN VIEWCONTROLLER TO ROOT
//        let objLogin = Story_Main.instantiateViewController(withIdentifier: "EnterMobileVC")
//        let navi = UINavigationController.init(rootViewController: objLogin)
//        navi.setNavigationBarHidden(true, animated: false)
//        self.animatedAddtoRoot(toView: navi)
//    }
//
//
    func app_setLogin() {
        //SET LOGIN VIEWCONTROLLER TO ROOT
        let login = Story_Main.instantiateViewController(withIdentifier: "navComtroller")
        self.animatedAddtoRoot(toView: login)
    }
       
    func animatedAddtoRoot(toView:UIViewController) {
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = toView
        }, completion: { completed in
            // maybe do something here
            self.window?.makeKeyAndVisible()
        })
    }
    
    
}


extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}













