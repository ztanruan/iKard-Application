import Foundation
import UIKit


@IBDesignable
class DesignableView: UIView {
}

extension UIFont {
    
    public class func AppFontRegular(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: fontSize)!
    }
    
    public class func AppFontBold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Bold", size: fontSize)!
    }
    
    public class func AppFontSemiBold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: fontSize)!
    }
    
    public class func AppFontLight(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Light", size: fontSize)!
    }
    
    public class func AppFontExtraBold(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-ExtraBold", size: fontSize)!
    }
    
    public class func AppFontMedium(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: fontSize)!
    }
    
    public class func AppFontExtraLight(_ fontSize: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-ExtraLight", size: fontSize)!
    }
    

}



//MARK:- For PullTo Refresh TableView
extension UITableView {
    
    func pullTorefresh(_ target: Selector, tintcolor: UIColor,_ toView: UIViewController?){
        let refrshControll = UIRefreshControl()
        refrshControll.tintColor = tintcolor
        refrshControll.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
        refrshControll.addTarget(toView!, action: target, for: UIControl.Event.valueChanged)
        self.refreshControl = refrshControll
    }
    
    func closeEndPullRefresh(){
        self.refreshControl?.endRefreshing()
    }
}


//MARK:- For PullTo Refresh TableView
extension UICollectionView {
    
    func pullTorefresh(_ target: Selector, tintcolor: UIColor,_ toView: UIViewController?){
        let refrshControll = UIRefreshControl()
        refrshControll.tintColor = tintcolor
        refrshControll.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
        refrshControll.addTarget(toView!, action: target, for: UIControl.Event.valueChanged)
        self.refreshControl = refrshControll
    }
    
    func closeEndPullRefresh(){
        self.refreshControl?.endRefreshing()
    }
}



//MARK:- Extension_UIColor
extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

//MARK:- UserDefaults
extension UserDefaults {
    
    //MARK:- UserDefault Save / Retrive Data
    static func appSetObject(_ object:Any, forKey:String){
        UserDefaults.standard.set(object, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func appObjectForKey(_ strKey:String) -> Any?{
        let strValue = UserDefaults.standard.value(forKey: strKey)
        return strValue
    }
    
    static func appRemoveObjectForKey(_ strKey:String){
        UserDefaults.standard.removeObject(forKey: strKey)
        UserDefaults.standard.synchronize()
    }
    
}


extension String {

    func isValidMobile() -> Bool {
        let PHONE_REGEX = "^[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidString(value:String?) -> Bool {
         return value == "" || value == nil
    }
    
    func checkAcceptableValidation(AcceptedCharacters:String) -> Bool {
        let cs = NSCharacterSet(charactersIn: AcceptedCharacters).inverted
        let filtered = self.components(separatedBy: cs).joined(separator: "")
        if self != filtered{
            return false
        }
        return true
    }
    
    func byaddingLineHeight(linespacing:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = linespacing  // Whatever line spacing you want in points
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    func trimed() -> String{
       return  self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}


//MARK:- Label FOnt scaling
extension UITextField{
    
    @IBInspectable
    var fontScaling: Bool{
        get{
            return false
        }
        set{
            if newValue == true{
                if screenScale > CGFloat(1){
                    self.font = UIFont.init(name: (self.font?.fontName)!, size: ((self.font?.pointSize)! * screenScale))
                }
            }
        }
    }
}

//MARK:- Label FOnt scaling
extension UILabel{
    
    @IBInspectable
    var fontScaling: Bool{
        get{
            return false
        }
        set{
            if newValue == true{
                if screenScale > CGFloat(1){
                    self.font = UIFont.init(name: self.font.fontName, size: (self.font.pointSize * screenScale))
                }
            }
        }
    }
}

//MARK:- Label FOnt scaling
extension UIButton{
    @IBInspectable
    var fontScaling: Bool{
        get{
            return false
        }
        set{
            if newValue == true{
                if screenScale > CGFloat(1){
                    self.titleLabel?.font = UIFont.init(name: (self.titleLabel?.font.fontName)!, size: ((self.titleLabel?.font.pointSize)! * screenScale))
                }
            }
        }
    }
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var DynamicRound:Bool{
        get{
            return false
        }
        set{
            if newValue == true {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                    self.layer.cornerRadius = self.frame.height / 2
                    self.layer.masksToBounds = true;
                })
            }
        }
        
    }
    
    @IBInspectable var RoundWithShadow: Bool{
        get{
            return false
        }set{
            if newValue == true{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                    self.layer.masksToBounds = false
                    self.layer.borderColor = self.borderColor?.cgColor
                    self.layer.borderWidth = self.borderWidth
                    self.layer.shadowOffset = self.shadowOffset
                    self.layer.cornerRadius = self.bounds.height/2
                    self.layer.shadowColor = self.shadowColor?.cgColor
                    self.layer.shadowRadius = self.shadowRadius
                    self.layer.shadowOpacity = self.shadowOpacity
                    self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
                    let backgroundColor = self.backgroundColor?.cgColor
                    self.backgroundColor = nil
                    self.layer.backgroundColor =  backgroundColor

                })
            }
        }
    }
    
    @IBInspectable var cornerradiusWithShadow: Bool{
        get{
            return false
        }set{
            if newValue == true{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
                    self.layer.masksToBounds = false
                    self.layer.borderColor = self.borderColor?.cgColor
                    self.layer.borderWidth = self.borderWidth
                    self.layer.shadowOffset = self.shadowOffset
                    self.layer.cornerRadius = self.cornerRadius
                    self.layer.shadowColor = self.shadowColor?.cgColor
                    self.layer.shadowRadius = self.shadowRadius
                    self.layer.shadowOpacity = self.shadowOpacity
                    self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
                    let backgroundColor = self.backgroundColor?.cgColor
                    self.backgroundColor = nil
                    self.layer.backgroundColor =  backgroundColor
                })
            }
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
}
extension UIFont{
    func fontWith(name:String, size:CGFloat) -> UIFont{
        return (UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size))
    }
}
extension UITextField{
    
    func addDoneToolbar(TintColor:UIColor = AppColor.blue, selector:Selector? = nil, targate:Any? = nil)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done))
        
        if let selctr = selector{
            done = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: targate, action: selctr)
        }
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.tintColor = TintColor
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func done() {
        self.endEditing(true)
    }
}

extension UITextView{
    func addDoneToolbar(TintColor:UIColor = AppColor.blue)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.tintColor = TintColor
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func done() {
        self.endEditing(true)
    }
    
    
    
    func addDoneToolbarwithClearButton(TintColor:UIColor = AppColor.blue)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done))
        let clear: UIBarButtonItem  = UIBarButtonItem(title: "Clear", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.clearText))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        items.append(clear)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.tintColor = TintColor
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func clearText() {
        self.text = ""
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    func rounded(on amount: Int, _ component: Calendar.Component) -> Date {
        let cal = Calendar.current
        let value = cal.component(component, from: self)
        
        // Compute nearest multiple of amount:
        let roundedValue = lrint(Double(value) / Double(amount)) * amount
        let newDate = cal.date(byAdding: component, value: roundedValue - value, to: self)!
        
        return newDate.floorAllComponents(before: component)
    }
    
    func floorAllComponents(before component: Calendar.Component) -> Date {
        // All components to round ordered by length
        let components = [Calendar.Component.year, .month, .day, .hour, .minute, .second, .nanosecond]
        
        guard let index = components.firstIndex(of: component) else {
            fatalError("Wrong component")
        }
        
        let cal = Calendar.current
        var date = self
        
        components.suffix(from: index + 1).forEach { roundComponent in
            let value = cal.component(roundComponent, from: date) * -1
            date = cal.date(byAdding: roundComponent, value: value, to: date)!
        }
        
        return date
    }
   
}

extension DateFormatter {
    convenience init(dateStyle: Style) {
        self.init()
        self.dateStyle = dateStyle
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}



extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}


extension String {
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}


extension UISearchBar {
    
    func change(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            
            if let textField = view as? UITextField {
                textField.font = textFont
            }
        }
    }
    
    func setWhitebackground_color() {
        if #available(iOS 13.0, *) {
           self.searchTextField.backgroundColor = .white
        }
    }
    
}


extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) years ago"   }
        if months(from: date)  > 0 { return "\(months(from: date)) Months ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) week ago"   }
        if days(from: date)    > 0 { return "\(days(from: date)) days ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hrs ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) mins ago" }
        if seconds(from: date) > 0 { return "Just now" } //\(seconds(from: date)) secs ago
        return ""
    }
    
    
    
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "Just Now"
    }
    
}



//MARK:- Terms Lable Tap

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,y:(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y:locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
    //    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
    //        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    //        let layoutManager = NSLayoutManager()
    //        let textContainer = NSTextContainer(size: CGSize.zero)
    //        let textStorage = NSTextStorage(attributedString: label.attributedText!)
    //
    //        // Configure layoutManager and textStorage
    //        layoutManager.addTextContainer(textContainer)
    //        textStorage.addLayoutManager(layoutManager)
    //
    //        // Configure textContainer
    //        textContainer.lineFragmentPadding = 0.0
    //        textContainer.lineBreakMode = label.lineBreakMode
    //        textContainer.maximumNumberOfLines = label.numberOfLines
    //        let labelSize = label.bounds.size
    //        textContainer.size = labelSize
    //        // Find the tapped character location and compare it to the specified range
    //        let locationOfTouchInLabel = self.location(in: label)
    //        let textBoundingBox = layoutManager.usedRect(for: textContainer)
    //
    //        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,y:(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
    //        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,
    //                                                     y:locationOfTouchInLabel.y - textContainerOffset.y);
    //        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    //        return NSLocationInRange(indexOfCharacter, targetRange)
    //    }
    
    
    
    
    func didTapAttributedTextInTextView(txtView: UITextView, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: txtView.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        let labelSize = txtView.bounds.size
        textContainer.size = labelSize
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: txtView)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,y:(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y:locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}


extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}


extension UIDevice {
    var isSimulator: Bool {
        #if IOS_SIMULATOR
        return true
        #else
        return false
        #endif
    }
    

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}


extension UINavigationController{
  func addCrossDesolveAnimation(time:CFTimeInterval) {
    let transition = CATransition()
    transition.duration = time
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    transition.type = CATransitionType.fade
    self.view.layer.add(transition, forKey: nil)
  }
}


extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}


extension UIButton {
    
    func setGradientBackground(colors:[UIColor], direction: GradientDirection){
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, direction: direction)
        self.setBackgroundImage(gradientLayer.creatGradientImage(), for: UIControl.State.normal)
    }
}

extension UIControl {
    
    func setGradientBackgroundinUIVIEW(colors:[UIColor], direction: GradientDirection){
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, direction: direction)
        self.backgroundColor = UIColor(patternImage: gradientLayer.creatGradientImage()!)
    }
}




extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor], direction: GradientDirection) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
      //  locations = [0.0, 0.55]
//        startPoint = CGPoint(x: 1.0, y: 0.5)
//        endPoint = CGPoint(x: 0.0, y: 0.5)
        
        switch direction {
        case .Right:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
        case .Left:
            startPoint = CGPoint(x: 1.0, y: 0.5)
            endPoint = CGPoint(x: 0.0, y: 0.5)
        case .Bottom:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
        case .Top:
            startPoint = CGPoint(x: 0.5, y: 1.0)
            endPoint = CGPoint(x: 0.5, y: 0.0)
        case .TopLeftToBottomRight:
            startPoint = CGPoint(x: 0.0, y: 0.0)
            endPoint = CGPoint(x: 1.0, y: 1.0)
        case .TopRightToBottomLeft:
            startPoint = CGPoint(x: 1.0, y: 0.0)
            endPoint = CGPoint(x: 0.0, y: 1.0)
        case .BottomLeftToTopRight:
            startPoint = CGPoint(x: 0.0, y: 1.0)
            endPoint = CGPoint(x: 1.0, y: 0.0)
        default:
            startPoint = CGPoint(x: 1.0, y: 1.0)
            endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
