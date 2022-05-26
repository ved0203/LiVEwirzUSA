import UIKit
import SystemConfiguration
import RSLoadingView

var viewControllerInstance: AnyObject!
var badgeCartViewController: AnyObject!
//var indicator: MaterialActivityIndicatorView!

class Global: NSObject {
    class var sharedInstance: Global {
        struct Static {
            static let instance: Global = Global()
        }
        return Static.instance
    }
    
    static func roundRadius(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = (imageView.frame.size.height / 2 + imageView.frame.size.width / 2) / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }
    static func imageviewCircle(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = (imageView.frame.size.height / 2 + imageView.frame.size.width / 2) / 2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }
    static func labelRoundRadius(_ labelView: UILabel) {
        labelView.layer.cornerRadius = (labelView.frame.size.height / 2 + labelView.frame.size.width / 2) / 2
        labelView.layer.masksToBounds = true
        labelView.clipsToBounds = true
    }
    static func buttonCircleRadius(_ button: UIButton) {
        button.layer.cornerRadius = (button.frame.size.height / 2 + button.frame.size.width / 2) / 2
        button.layer.masksToBounds = true
        //button.clipsToBounds = true
    }
    static func buttonCornerRadius(_ sender: AnyObject) {
        let btn: UIButton = (sender as? UIButton)!
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
    }
    
    class func getAppDelegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate
    }
    
    class func getDateFromUnixTimeStamp(unixtimeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: unixtimeInterval/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local //Set timezone that you want TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "d MMM, yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    static func textViewBorder(_ textview: UITextView) {
        textview.layer.cornerRadius =  5
        textview.layer.borderWidth = 1
        textview.layer.borderColor = (UIColor.lightGray).cgColor
    }
    
    static func showAlertView(vc : UIViewController, titleString : String , messageString: String) ->()
    {
        let alertView = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "ok", style: .cancel) { (alert) in
            vc.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(alertAction)
        vc.present(alertView, animated: true, completion: nil)
    }
    
    static func viewCircleRadius(_ view: UIView) {
        view.layer.cornerRadius  = (view.frame.size.height / 2 + view.frame.size.width / 2) / 2
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.shadowColor = Global.hexStringToUIColor("#555555").cgColor
        view.layer.shadowOffset = CGSize (width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
    }
    
    static func viewCornerRadius(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.shadowColor = Global.hexStringToUIColor("#555555").cgColor
        view.layer.shadowOffset = CGSize (width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
    }
    
    class func showActivityIndicator (_ view: UIView) {
        let loadingView = RSLoadingView()
        loadingView.mainColor = Global.hexStringToUIColor("#066DFF")
        loadingView.show(on: view)
    }
    
    class func hideActivityIndicator(_ view: UIView) {
        RSLoadingView.hide(from: view)
    }
    
    // MARK : Check Mobile Number
    static func validationMobileNumber(mobileNumber: String) -> (Bool, String) {
        let numberAsInt = Int(mobileNumber)
        let strMobileNum = "\(numberAsInt!)"
        
        let mobLength = strMobileNum.count
        
        if mobLength < 8 || mobLength > 12 {
            return (false, strMobileNum)
        } else {
            return (true, strMobileNum)
        }
    }
    
    class func firstLetter(_ str: String) -> String? {
        guard let firstChar = str.first else {
            return nil
        }
        return String(firstChar)
    }
    
    // MARK: - Creates a UIColor from a Hex string.
    static func hexStringToUIColor (_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count) != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK: Toast View
    static func toastView(messsage : String, view: UIView ) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300,  height : 35))
        toastLabel.backgroundColor = Global.hexStringToUIColor(GlobalConstant.navigationBarColor)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = messsage
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 1.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            
        })
    }
    
    // MARK: - Global alert Methods
    static func showAlertMessageWithOkButtonAndTitle(_ strTitle: String, andMessage strMessage: String ) {
        if objc_getClass("UIAlertController") == nil {
            let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
        } else {
            let alertController: UIAlertController = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
            
            let okay: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okay)
            alertController.view.frame = CGRect(x: GlobalConstant.SCREENWIDTH-30, y: GlobalConstant.SCREENHEIGHT+20, width: 200, height: 200)
            alertController.view.layer.shadowColor = UIColor.black.cgColor
            alertController.view.layer.shadowOpacity = 0.8
            alertController.view.layer.shadowRadius = 5
            alertController.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            alertController.view.layer.masksToBounds = false
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindow.Level.alert + 1
            topWindow.makeKeyAndVisible()
            alertController.view.frame = CGRect(x: GlobalConstant.SCREENWIDTH-30, y: GlobalConstant.SCREENHEIGHT+20, width: 200, height: 200)
            topWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showAlertMessageWithOkButtonAndTitleLogin(_ strTitle: String, andMessage strMessage: String ) {
        if objc_getClass("UIAlertController") == nil {
            let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
        } else {
            let alertController: UIAlertController = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.actionSheet)
            
            let okay: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okay)
            alertController.view.layer.shadowColor = UIColor.black.cgColor
            alertController.view.layer.shadowOpacity = 0.8
            alertController.view.layer.shadowRadius = 5
            alertController.view.layer.shadowOffset = CGSize(width: 0, height: 0)
            alertController.view.layer.masksToBounds = false
            alertController.view.tintColor = Global.hexStringToUIColor(GlobalConstant.navigationBarColor)
            
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindow.Level.alert + 1
            topWindow.makeKeyAndVisible()
            alertController.view.frame = CGRect(x: GlobalConstant.SCREENWIDTH-30, y: GlobalConstant.SCREENHEIGHT+20, width: 200, height: 200)
            topWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Date and Time Methods
    // Function to get current date time of iphone
    static func getCurrentDateTime() -> String {
        let date: Date = Date()
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let unitFlags: NSCalendar.Unit = [.year, .month, .weekday, .day, .hour, .minute, .second]
        let dateComponents: DateComponents = (calendar as NSCalendar).components(unitFlags, from: date)
        let year: Int = dateComponents.year!
        let month: Int = dateComponents.month!
        let day: Int = dateComponents.day!
        let hour: Int = dateComponents.hour!
        let minute: Int = dateComponents.minute!
        let second: Int = dateComponents.second!
        let currentDateTime: String = "\(Int(year))-\(Int(month))-\(Int(day)) \(Int(hour)):\(Int(minute)):\(Int(second))"
        return currentDateTime
    }
    
    static func stringFromNSDate(_ date: Date, dateFormate: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = dateFormate
        let formattedDate: String = dateFormatter.string(from: date)
        return formattedDate
    }
    
    static func nsdateFromString(_ dateString: String, dateFormate: String) -> Date {
        var date: Date?
        if Global.stringExists(dateString) {
            //date formatter for the above string
            let dateFormatterWS: DateFormatter = DateFormatter()
            dateFormatterWS.dateFormat = dateFormate
            date = dateFormatterWS.date(from: dateString)
            return date!
        }
        let returnObject: Date?  = nil
        return returnObject!
    }
    
    static func getDateFromMiliSecond(date: String) -> String {
        if date != "" {
            let dateTimeStamp = NSDate(timeIntervalSince1970:Double(date)!/1000)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
            dateFormatter.dateFormat =  "yyyy-MM-dd, hh:mm a"
            let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
            return strDateSelect
        } else {
            return ""
        }
    }
    
    static func getDateFromMiliSecondTwo (date: String) -> String {
        if date != "" {
            let dateTimeStamp = NSDate(timeIntervalSince1970:Double(date)!/1000)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.dateStyle = DateFormatter.Style.short
            let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
            return strDateSelect
        } else {
            return ""
        }
    }
    
    // converts date format from source to target format
    
    static func convertDateFormat(_ dateString: String, sourceFormate: String, targetFormate: String) -> String {
        if Global.stringExists(dateString) {
            //date formatter for the above string
            let dateFormatterWS: DateFormatter = DateFormatter()
            dateFormatterWS.dateFormat = sourceFormate
            let date: Date = dateFormatterWS.date(from: dateString)!
            //date formatter that you want
            let dateFormatterNew: DateFormatter = DateFormatter()
            dateFormatterNew.dateFormat = targetFormate
            let stringForNewDate: String = dateFormatterNew.string(from: date)
            //NSLog(@"Date %@",stringForNewDate);
            return stringForNewDate
        }
        let returnObject: String?  = ""
        return returnObject!
    }
    
    // MARK: - Start date and End Date Validation
    static func isEndDateIsSmallerThanStartDate(_ checkEndDate: Date, StartDate startDate: Date) -> Bool {
        let enddate: Date = checkEndDate
        let distanceBetweenDates: TimeInterval = enddate.timeIntervalSince(startDate)
        let secondsInMinute: Double = 60
        let secondsBetweenDates: Double = distanceBetweenDates / secondsInMinute
        if secondsBetweenDates == 0 {
            return true
        } else if secondsBetweenDates < 0 {
            return true
        } else {
            return false
        }
    }
    
    static func isEndDateIsSmallerThanCurrent(_ checkEndDate: String) -> Bool {
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let enddate: Date = dateFormat.date(from: checkEndDate)!
        let myString: String = dateFormat.string(from: Date())
        let currentdate: Date = dateFormat.date(from: myString)!
        switch currentdate.compare(enddate) {
        case ComparisonResult.orderedAscending:
            return true
        case ComparisonResult.orderedSame:
            return true
        case ComparisonResult.orderedDescending:
            return false
        }
    }
    
    // MARK: - Diffrence Between Two Dates
    class func dateDiff(_ dateStr: String, DateFormat dateFormate: String) -> String {
        let formate: DateFormatter = DateFormatter()
        formate.timeZone = NSTimeZone.local
        formate.dateFormat = dateFormate
        let now = formate.string(from: NSDate() as Date)
        let startDate = formate.date(from: dateStr)
        let endDate = formate.date(from: now)
        let dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: startDate!, to: endDate!)
        let weeks = dateComponents.weekOfMonth ?? 0
        let days = dateComponents.day ?? 0
        let hours = dateComponents.hour ?? 0
        let min = dateComponents.minute ?? 0
        let sec = dateComponents.second ?? 0
        let month = dateComponents.month ?? 0
        var timeAgo = ""
        if  sec > 0 {
            if sec > 1 {
                timeAgo = "\(sec) Seconds Ago"
            } else {
                timeAgo = "\(sec) Second Ago"
            }
        }
        if  min > 0 {
            if min > 1 {
                timeAgo = "\(min) Minutes Ago"
            } else {
                timeAgo = "\(min) Minute Ago"
            }
        }
        if hours > 0 {
            if hours > 1 {
                timeAgo = "\(hours) Hours Ago"
            } else {
                timeAgo = "\(hours) Hour Ago"
            }
        }
        if days > 0 {
            if days > 1 {
                timeAgo = "\(days) Days Ago"
            } else {
                timeAgo = "\(days) Day Ago"
            }
        }
        if weeks > 0 {
            if weeks > 1 {
                timeAgo = "\(weeks) Weeks Ago"
            } else {
                timeAgo = "\(weeks) Week Ago"
            }
        }
        if month > 0 {
            if month > 1 {
                timeAgo = "\(month) Month Ago"
            } else {
                timeAgo = "\(month) Month Ago"
            }
        }
        return timeAgo
    }
    
    // Time Difference Between Two dates
    static func remaningTime(_ startDate: Date, end endDate: Date) -> String {
        var components: DateComponents?
        var year: Int
        var month: Int
        var days: Int
        var hour: Int
        var minutes: Int
        var durationString: String
        let calendar = NSCalendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute])
        components = calendar.dateComponents(unitFlags, from: startDate, to: endDate)
        year = (components?.year)!
        month = (components?.month)!
        days = (components?.day)!
        hour = (components?.hour)!
        minutes = (components?.minute)!
        if year > 0 {
            if year > 1 {
                durationString = "\(year) Years Ago"
            } else {
                durationString = "\(year) Year Ago"
            }
            return durationString
        }
        if month > 0 {
            if month > 1 {
                durationString = "\(month) Months Ago"
            } else {
                durationString = "\(month) Month Ago"
            }
            return durationString
        }
        if days > 0 {
            if days > 1 {
                durationString = "\(days) Days Ago"
            } else {
                durationString = "\(days) Day Ago"
            }
            return durationString
        }
        if hour > 0 {
            if hour > 1 {
                durationString = "\(hour) Hrs Ago"
            } else {
                durationString = "\(hour) Hr Ago"
            }
            return durationString
        }
        if minutes > 0 {
            if minutes > 1 {
                durationString = "\(minutes) Mins Ago"
            } else {
                durationString = "\(minutes) Min Ago"
            }
            return durationString
        }
        return ""
    }
    // MARK: - Add Dashed Border Button Methods
    class func addDashedBorder(_ dashView: UIView, AndBorderColor borderColor: UIColor, AndRoundRadius radius: Bool) {
        let color = borderColor.cgColor
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = dashView.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 3]
        if radius {
            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        } else {
            shapeLayer.path = UIBezierPath(rect: shapeRect).cgPath
        }
        dashView.layer.addSublayer(shapeLayer)
    }
    
    //MARK: Convert Array To JSON Object
    class func convertArrayToJson(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    // MARK: - Common Back Button Methods
    //Common Back Button for all Views
    class func backButtonClose(_ sender: UIViewController) {
        viewControllerInstance = sender
        let backBtn: UIButton = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let backBtnImage: UIImage = UIImage(named: "ic_exit")!
        backBtn.setImage(backBtnImage, for: UIControl.State())
        backBtn.addTarget(self, action: #selector(Global.goback), for: UIControl.Event.touchUpInside)
        let backButton: UIBarButtonItem = UIBarButtonItem(customView: backBtn)
        ((viewControllerInstance as? UIViewController))!.navigationItem.leftBarButtonItem = backButton
    }
    
    class func backButton(_ sender: UIViewController) {
        viewControllerInstance = sender
        let backBtn: UIButton = UIButton(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let backBtnImage: UIImage = UIImage(named: "back")!
        backBtn.setImage(backBtnImage, for: UIControl.State())
        backBtn.addTarget(self, action: #selector(Global.goback), for: UIControl.Event.touchUpInside)
        let backButton: UIBarButtonItem = UIBarButtonItem(customView: backBtn)
        ((viewControllerInstance as? UIViewController))!.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc class func goback() {
        ((viewControllerInstance as? UIViewController))!.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - Navigation Title Methods
    static func customNavigationWithTitle(_ title: String) -> UILabel {
        let frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 44)
        let label: UILabel = UILabel(frame: frame)
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: "Roboto", size: 16.0)
        label.textAlignment = .center
        //label.textColor = Global.colorFromHexString("#ffffff")
        label.text = title
        return label
    }
    
    // MARK: Gesture Button Methods
    class func endEditingButton(_ sender: UIViewController) {
        viewControllerInstance = sender
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(Global.handleSingleTap))
        tapRecognizer.numberOfTapsRequired = 1
        ((viewControllerInstance as? UIViewController))!.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc class func handleSingleTap() {
        ((viewControllerInstance as? UIViewController))!.view.endEditing(true)
    }
    
    //Get Url from String type parameter
    static func validateUrl (urlString: NSString) -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    // MARK: - Image Scalling Methods
    static func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // Creates a circular outline image.
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // MARK: - String Methods
    /// Trim for String
    static func trim(_ value: String) -> String {
        let value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return value
    }
    
    /*
     static func setTitleAtLeft(_ titleName: String) -> String {
     var view: UIView?
     let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view!.frame.width - 32, height: view.frame.height))
     titleLabel.text = titleName
     titleLabel.textColor = UIColor.white
     titleLabel.font = UIFont(name: "SFUIText-Regular", size: 20)
     navigationItem.titleView = titleLabel
     return titleName
     }*/
    
    // checks whether string value exists or it contains null or null in string
    static func stringExists(_ str: String) -> Bool {
        var strString: String? = str
        if strString == nil {
            return false
        }
        if strString == String(describing: NSNull()) {
            return false
        }
        if strString == "<null>" {
            return false
        }
        if strString == "(null)" {
            return false
        }
        strString = Global.trim(str)
        if str == "" {
            return false
        }
        if strString?.count == 0 {
            return false
        }
        return true
    }
    
    // returns string value after removing null and unwanted characters
    static func getStringValue(_ str: AnyObject) -> String {
        if str is NSNull {
            return ""
        } else if str is String {
            return (str as? String)!
        } else if str is Double || str is Float || str is NSNumber || str is Int {
            return "\(str)"
        } else {
            var strString: String? = str as? String
            if Global.stringExists(strString!) {
                strString = strString!.replacingOccurrences(of: "\t", with: " ")
                strString = Global.trim(strString!)
                if strString == "{}" {
                    strString = ""
                }
                if strString == "()" {
                    strString = ""
                }
                if strString == "null" {
                    strString = ""
                }
                if strString == "<null>" {
                    strString = ""
                }
                return strString!
            }
            return ""
        }
    }
    
    // MARK: - Image Scalling Methods
    class func scale(_ image: UIImage, maxWidth: Int, maxHeight: Int) -> UIImage {
        let imgRef: CGImage? = image.cgImage
        let width: CGFloat = CGFloat(imgRef!.width)
        let height: CGFloat = CGFloat(imgRef!.height)
        if Int(width) <= maxWidth && Int(height) <= maxHeight {
            return image
        }
        let transform = CGAffineTransform.identity
        var bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: height)
        if Int(width) > maxWidth || Int(height) > maxHeight {
            let ratio: CGFloat = width / height
            if ratio > 1 {
                bounds.size.width = CGFloat(maxWidth)
                bounds.size.height = bounds.size.width / ratio
            } else {
                bounds.size.height = CGFloat(maxHeight)
                bounds.size.width = bounds.size.height * ratio
            }
        }
        let scaleRatio: CGFloat = bounds.size.width / width
        UIGraphicsBeginImageContext(bounds.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: scaleRatio, y: -scaleRatio)
        context?.translateBy(x: 0, y: -height)
        context?.concatenate(transform)
        UIGraphicsGetCurrentContext()?.draw(imgRef!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: height))
        let imageCopy: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageCopy!
    }
    
    static func compressImage(_ oldImage: UIImage ) -> UIImage {
        var imageData: Data =  Data(oldImage.pngData()! )
        imageData = oldImage.jpegData(compressionQuality: 0.75)!
        let image = UIImage(data: imageData)
        return image!
    }
    
    // MARK: - Internet Connection Checking Methods
    class func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    // MARK: - Reload Table View data with animation Methods
    class func reloadTableViewDataAnimated(_ tableView: UITableView) {
        UIView.transition(with: tableView, duration: 0.55, options: .transitionCrossDissolve, animations: { () -> Void in
            tableView.reloadData()
        }, completion: nil)
    }
    
    // MARK: - Get text height
    class func heightForView(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height + 50
    }
    
    class func heightForLabel(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height + 10
    }
    
    // For text view
    class func autoresizeTextView(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let textView: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        textView.font = font
        textView.text = text
        textView.sizeToFit()
        if let textNSString: NSString = textView.text as NSString? {
            let rect = textNSString.boundingRect(with: CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: textView.font!],
                                                 context: nil)
            textView.frame = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: textView.frame.size.width, height: rect.height)
        }
        return textView.frame.height
    }
    
    // MARK: Set Left Navigation Title
    static func setLeftNavigationTitle(title : String, width: CGFloat, height: CGFloat) -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "SFUIText-Bold", size: 20)
        return titleLabel
    }
    
    // MARK: SetNavigation Bar Color
    
    static func navigatioinBarClear(vc: UIViewController) {
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        vc.navigationController?.navigationBar.isTranslucent = true
        vc.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    static func setNavBarColor_isTranslucentTruef (vc: UIViewController) {
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        vc.navigationController?.navigationBar.isTranslucent = true
        // vc.navigationController?.view.backgroundColor = color
    }
    
    static func setNavBarColor_isTranslucentTrue (vc: UIViewController, color: UIColor) {
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        vc.navigationController?.navigationBar.isTranslucent = true
        vc.navigationController?.view.backgroundColor = color
    }
    static func setNavBarColor_isTranslucentFalse (vc: UIViewController, color: UIColor) {
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
        vc.navigationController?.navigationBar.isTranslucent = false
        vc.navigationController?.view.backgroundColor = color
    }
    
    // MARK : Check Mobile Number
    class func checkMobileNumber (mobileNumber: String) -> (Bool, String) {
        let numberAsInt = Int(mobileNumber)
        let strMobileNum = "\(numberAsInt!)"
        
        let mobLength = strMobileNum.count
        
        if mobLength < 8 || mobLength > 12 {
            return (false, strMobileNum)
        } else {
            return (true, strMobileNum)
        }
    }
    
    // MARK : Call Number
    class func callNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    // MARK : ValidateEmail
    class func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    class func autoresizeLabel(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        if let textNSString: NSString = label.text as NSString? {
            let rect = textNSString.boundingRect(with: CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: label.font],
                                                 context: nil)
            label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.size.width, height: rect.height)
        }
        return label.frame.height
    }
    
    // MARK: - Valid Email address Methods
    class func validateEmail(_ enteredEmail: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    class func isValidPassword(_ candidate: String) -> Bool {
        let validationExpression = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,30}$"
        return NSPredicate(format: "SELF MATCHES %@", validationExpression).evaluate(with: candidate)
    }
    
    class func containsOnlyLetters(_ candidate: String) -> Bool {
        let validationExpression = "^[A-Za-z]+$"
        return NSPredicate(format: "SELF MATCHES %@", validationExpression).evaluate(with: candidate)
    }
    
    class func isValidPageName (_ candidate: String) -> Bool {
        let validationExpression = "^(?=.*[a-zA-Z])([a-zA-Z0-9_]{1,30})$"
        return NSPredicate(format: "SELF MATCHES %@", validationExpression).evaluate(with: candidate)
    }
    
    class func getCountryCallingCode(countryRegionCode:String)->String{
        
        let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
        let countryDialingCode = prefixCodes[countryRegionCode]
        return countryDialingCode!
    }
    
    static func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
            }
        }
        return ""
    }
    
    class func changeDateFormate(fromFormat : String, toFormat : String, toDate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let date = dateFormatter.date(from: toDate)
        dateFormatter.dateFormat = toFormat
        
        let strFromDate = dateFormatter.string(from: date!)
        return strFromDate
    }
    
    class func getStartAndEndTime(startTime : String, endTime:String) -> String {
        let strTime = self.changeDateFormate(fromFormat:"HH:mm:ss", toFormat:"h:mm a", toDate: (startTime))
        let endTime = self.changeDateFormate(fromFormat:"HH:mm:ss", toFormat:"h:mm a", toDate: (endTime))
        return "\(strTime) to \(endTime)"
    }
    
    class func thousandSeprator(_ str: String) -> String? {
        if str != "" {
            let largeNumber = Int(str)!
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
            
            return formattedNumber!
        }
        return ""
    }
}
