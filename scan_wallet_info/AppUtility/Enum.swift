//
//  Enum.swift
//  RedButton
//
//  Created by Zignuts Technolab on 27/03/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import Foundation
import UIKit

struct ValidationExpression {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let password = "(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*])(?=.*[a-z]).{6,}"
    static let characterSpace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ "
    static let numeric = "0123456789"
}

struct staticLengths {
    static let name_chanracted = 50
    static let phoneNo_chanracted = 15
}


struct StaticValues {
    static let Phone_number = "1234567890"
    static let ListingLimit = 30
}

struct Static_Height {
    static let collection_Height = UIScreen.main.bounds.width * 0.44
    static let WithoutData_Height = UIScreen.main.bounds.width * 0.22
}

struct AppMessage {
    static let status = "status"
    static let Ok = "Ok"
    static let login = "login"
    static let Cancel = "Cancel"
    static let userData = "userdata"
    static let uID = "user_id"
    static let plzWait = "Please wait..."
    static let firebase_token = "firebase_token"
    static let device_token = "device_token"
    static let device_tokenData = "device_tokenData"
    static let passworddddd = "password"
}

enum ScreenType {
    case none
    case edit
}

struct APPDateFormates {
    static let shortYYYYMMDD = "YYYY-MM-dd"
    static let shortDDMMYYYY = "dd-MM-YYYY"
    static let serverFormate = "YYYY-MM-dd HH:mm:ss"
    static let longFormate = "dd-MM-YYYY hh:mm a"
}

struct AppColor {
    static let blue = #colorLiteral(red: 0.3215686275, green: 0.7568627451, blue: 1, alpha: 1)
}

enum GradientDirection {
    case Right
    case Left
    case Bottom
    case Top
    case TopLeftToBottomRight
    case TopRightToBottomLeft
    case BottomLeftToTopRight
    case BottomRightToTopLeft
}






