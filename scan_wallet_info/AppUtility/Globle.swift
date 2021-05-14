import Foundation
import UIKit
import AVFoundation
import Photos
import os.log
import SVProgressHUD

//MARK:- VARIABLES DECLARATION

let Story_Main = UIStoryboard.init(name:"Main", bundle: nil)

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenScale = screenWidth/320

let Min_Mobile_Number:Int = 9
let Max_Mobile_Number:Int = 15
var topConstraint: CGFloat = 0


//MARK:- METHODS
public func makeCall(number:String)
{
    let url = URL.init(string:"tel://\(number)" )
    if UIApplication.shared.canOpenURL(url!) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }else{
        appDelegate.window?.rootViewController?.view.makeToast("This device unable to make call")
    }
}


//MARK:- USERDEFAULT
func AppSetArchiveObjectToUserDefault(_ params:Any, Key: String ) {
    let data = NSKeyedArchiver.archivedData(withRootObject: params)
    UserDefaults.appSetObject(data, forKey: Key)
}

func AppGetArchievedObjectFromUserDefault(Key:String) -> Any {
    if let data = UserDefaults.appObjectForKey(Key) as? Data {
        if let storedData = NSKeyedUnarchiver.unarchiveObject(with: data){
            return storedData
        }
    }
    return NSNull()
}

//MARK:- PROGRESS HUD
public func ShowProgressHud(message:String) {
    SVProgressHUD.show(withStatus: message)
}

public func DismissProgressHud() {
    SVProgressHUD.dismiss()
}


//MARK: - Get Device Token Data For Notification
func GetUserNameEmail(_ strKey: String) -> String {
    
    var strValue = ""
    
    if UserDefaults.appObjectForKey(AppMessage.userData) != nil {
        let data = UserDefaults.appObjectForKey(AppMessage.userData) as! Data
        if let dicUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any] {
            strValue = dicUser[strKey] as? String ?? ""
        }
    }
    
    return strValue
}

func GetUserID() -> String {
    
    var str_userID = ""
    
    if UserDefaults.appObjectForKey(AppMessage.uID) != nil {
        if let str_user_id = UserDefaults.appObjectForKey(AppMessage.uID) as? String {
            str_userID = str_user_id
        }
    }
    
    return str_userID

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


func randomString(length: Int = 10) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""
    
    for _ in 0..<length {
        let randomValue = arc4random_uniform(UInt32(base.count))
        randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
}

func ConvertedDateforDisplay(_ strDateTime: String) -> String {
    
    var strSchdule = ""
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy hh:mm a"
    if let yourDate = formatter.date(from: strDateTime) {
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd MMM yyyy"
        // again convert your date to string
        strSchdule = formatter.string(from: yourDate)
    }
    
    return strSchdule
}

func ConvertedDateforDisplayFromTimeStamp(_ timestamp: Int) -> Date {

    var strSchduleDate = Date()

    let dateTimeStamp = Date(timeIntervalSince1970:Double(timestamp/1000))  //UTC time  //YOUR currentTimeInMiliseconds METHOD
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.dateStyle = DateFormatter.Style.full
    dateFormatter.timeStyle = DateFormatter.Style.short

    strSchduleDate = dateTimeStamp

    return strSchduleDate
}

func getCurrentUTCDate_Time() -> String{
    let formater = DateFormatter()
    formater.timeZone = TimeZone(identifier: "UTC")
    formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let strDate = formater.string(from: Date())
    
    return strDate
}

func getCurrentDate() -> String {
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd"
    let strDate = formater.string(from: Date())
    return strDate
}

func getYesterdayDate() -> String{
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd"
    let strDate = formater.string(from: Date.yesterday)
    return strDate
}


func getCurrentDate_TimeForChat() -> Date {
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let strDate = formater.string(from: Date())
    let str_Date = formater.date(from: strDate)
    
    return str_Date ?? Date()
}

func getCurrentMillis(date: Date)->Int64{
    return  Int64(date.timeIntervalSince1970 * 1000)
}

//MARK:- UIALERT VIEW
func showSingleAlert(Title:String, Message:String, buttonTitle:String, delegate:UIViewController? = appDelegate.window?.rootViewController, completion:@escaping ()->Void) {
    if let parentVC = delegate{
        let alertConfirm = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let actOk = UIAlertAction(title: buttonTitle, style: .default) { (finish) in
            completion()
        }
        alertConfirm.addAction(actOk)
        parentVC.present(alertConfirm, animated: true, completion: nil)
    }
}

func showGlobalToast(Message:String, delegate:UIViewController? = appDelegate.window?.rootViewController) {
    if let parentVC = delegate {
        parentVC.view.makeToast(Message)
    }
}

//MARK:- JSON METHOD
func jsonToStringFrom(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}

func stringToJson(from jsonString:String) -> Any?{
    let data = jsonString.data(using: .utf8)!
    do {
        let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments)
        return jsonArray
        
    } catch let error as NSError {
        print(error)
    }
    return nil
}


//MARK:- FORMATED JSON
func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
    
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    if JSONSerialization.isValidJSONObject(value) {
        do{
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }catch {
            
            print("error")
            //Access error here
        }
    }
    return ""
}

//MARK:- SIMPLE PRINT METHODS
func printFonts() {
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
        debugPrint("------------------------------")
        debugPrint("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        debugPrint("Font Names = [\(names)]")
    }
}

//MARK:- DATE FUNCTIONS
func currentTimeInMiliseconds(currentDate:Date = Date()) -> Int {
    let since1970 = currentDate.timeIntervalSince1970
    return Int(since1970 * 1000)
}

func dateFromMilliseconds(milisecond:Int) -> Date {
    return Date(timeIntervalSince1970: TimeInterval(milisecond)/1000)
}

//MARK: DATE FORMATE
func convertGetFormatedDate(fromDate:String, fromFormate:String, ToFormate:String, timezone:String = "UTC", isreport:Bool = false) -> String{
    let formater = DateFormatter()
    formater.timeZone = TimeZone(identifier: timezone)
    formater.dateFormat = fromFormate
    if let serverDate = formater.date(from: fromDate){
        formater.dateFormat = ToFormate
        if isreport {formater.timeZone = TimeZone.current}
        return formater.string(from: serverDate)
    }
    return fromDate
}
func convertGetDateFromJson(fromDate:String, fromFormate:String, ToFormate:String) -> Date?{
    let formater = DateFormatter()
    formater.timeZone = TimeZone(identifier: "UTC")
    formater.dateFormat = fromFormate
    if let serverDate = formater.date(from: fromDate){
        formater.dateFormat = ToFormate
//        formater.timeZone = TimeZone.current
        let strdate = formater.string(from: serverDate)
        return formater.date(from: strdate)
    }
    return nil
}



func formatedStringFromDate(Date2Formate:Date, strFormate:String, timezone:String = (TimeZone.current.identifier)) -> String {
    let dFormater = DateFormatter()
    dFormater.dateFormat = strFormate
    dFormater.timeZone = TimeZone.init(identifier: timezone)
    return dFormater.string(from: Date2Formate)
}

//MARK:- VALIDATIONS
func isValidEmail(email:String) -> Bool {
    let emailPred = NSPredicate(format:"SELF MATCHES %@", ValidationExpression.email)
    return emailPred.evaluate(with: email)
}
func isValidPassword(password:String) -> Bool {
    return password.count > 5
    //let emailPred = NSPredicate(format:"SELF MATCHES %@", ValidationExpression.password)
    //return emailPred.evaluate(with: password)
}

func isValidValue(_ object:Any? = nil) -> Bool{
    if object == nil{ return false }
    if object as? NSNull != nil{ return false }
    return true
}

//MARK:- Get Distance from One latitude or longitude
func getDistanceBetweenTwoLat_Long(firstLat_long: CLLocationCoordinate2D, secondLat_long: CLLocationCoordinate2D) -> String {
  //First location
  let first_Location = CLLocation(latitude: firstLat_long.latitude, longitude: firstLat_long.longitude)
   
  //Second location
  let second_Location = CLLocation(latitude: secondLat_long.latitude, longitude: secondLat_long.longitude)
   
  //Measuring my distance to my buddy's (in km)
  let distance = first_Location.distance(from: second_Location) / 1000
   
  //Display the result in km
  print(String(format: "Particular distance is %.01f KM", distance))
   
    return "\(Int(distance.rounded()))"
}




//MARK:- Session Helper
func clearDataOnLogout() {
    //Removes persistant login detail from userdefault
    UIApplication.shared.applicationIconBadgeNumber = 0
    UserDefaults.appRemoveObjectForKey(AppMessage.uID)
    UserDefaults.appRemoveObjectForKey(AppMessage.login)
    UserDefaults.appRemoveObjectForKey(AppMessage.userData)
}



func verifyUrl (urlString: String?) -> Bool {
    //Check for nil
    if let urlString = urlString {
        // create NSURL instance
        if let url = URL(string: urlString) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}


func getCountryPhonceCode (_ country : String) -> String {
    var countryDictionary  = ["AF":"93",
                              "AL":"355",
                              "DZ":"213",
                              "AS":"1",
                              "AD":"376",
                              "AO":"244",
                              "AI":"1",
                              "AG":"1",
                              "AR":"54",
                              "AM":"374",
                              "AW":"297",
                              "AU":"61",
                              "AT":"43",
                              "AZ":"994",
                              "BS":"1",
                              "BH":"973",
                              "BD":"880",
                              "BB":"1",
                              "BY":"375",
                              "BE":"32",
                              "BZ":"501",
                              "BJ":"229",
                              "BM":"1",
                              "BT":"975",
                              "BA":"387",
                              "BW":"267",
                              "BR":"55",
                              "IO":"246",
                              "BG":"359",
                              "BF":"226",
                              "BI":"257",
                              "KH":"855",
                              "CM":"237",
                              "CA":"1",
                              "CV":"238",
                              "KY":"345",
                              "CF":"236",
                              "TD":"235",
                              "CL":"56",
                              "CN":"86",
                              "CX":"61",
                              "CO":"57",
                              "KM":"269",
                              "CG":"242",
                              "CK":"682",
                              "CR":"506",
                              "HR":"385",
                              "CU":"53",
                              "CY":"537",
                              "CZ":"420",
                              "DK":"45",
                              "DJ":"253",
                              "DM":"1",
                              "DO":"1",
                              "EC":"593",
                              "EG":"20",
                              "SV":"503",
                              "GQ":"240",
                              "ER":"291",
                              "EE":"372",
                              "ET":"251",
                              "FO":"298",
                              "FJ":"679",
                              "FI":"358",
                              "FR":"33",
                              "GF":"594",
                              "PF":"689",
                              "GA":"241",
                              "GM":"220",
                              "GE":"995",
                              "DE":"49",
                              "GH":"233",
                              "GI":"350",
                              "GR":"30",
                              "GL":"299",
                              "GD":"1",
                              "GP":"590",
                              "GU":"1",
                              "GT":"502",
                              "GN":"224",
                              "GW":"245",
                              "GY":"595",
                              "HT":"509",
                              "HN":"504",
                              "HU":"36",
                              "IS":"354",
                              "IN":"91",
                              "ID":"62",
                              "IQ":"964",
                              "IE":"353",
                              "IL":"972",
                              "IT":"39",
                              "JM":"1",
                              "JP":"81",
                              "JO":"962",
                              "KZ":"77",
                              "KE":"254",
                              "KI":"686",
                              "KW":"965",
                              "KG":"996",
                              "LV":"371",
                              "LB":"961",
                              "LS":"266",
                              "LR":"231",
                              "LI":"423",
                              "LT":"370",
                              "LU":"352",
                              "MG":"261",
                              "MW":"265",
                              "MY":"60",
                              "MV":"960",
                              "ML":"223",
                              "MT":"356",
                              "MH":"692",
                              "MQ":"596",
                              "MR":"222",
                              "MU":"230",
                              "YT":"262",
                              "MX":"52",
                              "MC":"377",
                              "MN":"976",
                              "ME":"382",
                              "MS":"1",
                              "MA":"212",
                              "MM":"95",
                              "NA":"264",
                              "NR":"674",
                              "NP":"977",
                              "NL":"31",
                              "AN":"599",
                              "NC":"687",
                              "NZ":"64",
                              "NI":"505",
                              "NE":"227",
                              "NG":"234",
                              "NU":"683",
                              "NF":"672",
                              "MP":"1",
                              "NO":"47",
                              "OM":"968",
                              "PK":"92",
                              "PW":"680",
                              "PA":"507",
                              "PG":"675",
                              "PY":"595",
                              "PE":"51",
                              "PH":"63",
                              "PL":"48",
                              "PT":"351",
                              "PR":"1",
                              "QA":"974",
                              "RO":"40",
                              "RW":"250",
                              "WS":"685",
                              "SM":"378",
                              "SA":"966",
                              "SN":"221",
                              "RS":"381",
                              "SC":"248",
                              "SL":"232",
                              "SG":"65",
                              "SK":"421",
                              "SI":"386",
                              "SB":"677",
                              "ZA":"27",
                              "GS":"500",
                              "ES":"34",
                              "LK":"94",
                              "SD":"249",
                              "SR":"597",
                              "SZ":"268",
                              "SE":"46",
                              "CH":"41",
                              "TJ":"992",
                              "TH":"66",
                              "TG":"228",
                              "TK":"690",
                              "TO":"676",
                              "TT":"1",
                              "TN":"216",
                              "TR":"90",
                              "TM":"993",
                              "TC":"1",
                              "TV":"688",
                              "UG":"256",
                              "UA":"380",
                              "AE":"971",
                              "GB":"44",
                              "US":"1",
                              "UY":"598",
                              "UZ":"998",
                              "VU":"678",
                              "WF":"681",
                              "YE":"967",
                              "ZM":"260",
                              "ZW":"263",
                              "BO":"591",
                              "BN":"673",
                              "CC":"61",
                              "CD":"243",
                              "CI":"225",
                              "FK":"500",
                              "GG":"44",
                              "VA":"379",
                              "HK":"852",
                              "IR":"98",
                              "IM":"44",
                              "JE":"44",
                              "KP":"850",
                              "KR":"82",
                              "LA":"856",
                              "LY":"218",
                              "MO":"853",
                              "MK":"389",
                              "FM":"691",
                              "MD":"373",
                              "MZ":"258",
                              "PS":"970",
                              "PN":"872",
                              "RE":"262",
                              "RU":"7",
                              "BL":"590",
                              "SH":"290",
                              "KN":"1",
                              "LC":"1",
                              "MF":"590",
                              "PM":"508",
                              "VC":"1",
                              "ST":"239",
                              "SO":"252",
                              "SJ":"47",
                              "SY":"963",
                              "TW":"886",
                              "TZ":"255",
                              "TL":"670",
                              "VE":"58",
                              "VN":"84",
                              "VG":"284",
                              "VI":"340"]
    if countryDictionary[country] != nil {
        return countryDictionary[country]!
    }
        
    else {
        return ""
    }
}




extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}


extension Double {
    func roundToDecimal(_ fractionDigits: Int = 2) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}


extension UITableView {
    func scrollToBottom(){
        DispatchQueue.main.async {
            var roww = self.numberOfRows(inSection:  self.numberOfSections-1)
            if roww != 0 {
                roww = self.numberOfRows(inSection:  self.numberOfSections-1) - 1
            }
            let indexPath = IndexPath(row: roww, section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
