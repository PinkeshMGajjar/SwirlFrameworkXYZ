//
//  Utils.swift
//  Get It Done
//
//  Created by ALM on 20/02/17.
//  Copyright © 2017 Get It Done. All rights reserved.
//

import UIKit
import SystemConfiguration
import SDWebImage
import TTGSnackbar
import AVFoundation
import AVKit
import Foundation

class Utils {
    
    static let TAG : String = "API>>"
    
    public static let randomColors = ["#0D469E", "#009285", "#2D7A31", "#404040", "#E14F00", "#B31B1B"]
    
    public static func setGradient(view:UIView, colors:[UIColor]) {
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        layer.colors = [colors[0].cgColor, colors[1].cgColor, colors[2].cgColor]
        layer.locations = [0.0, 0.5, 1.0]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0);
        layer.endPoint = CGPoint(x: 0.0, y: 1.0);
        view.layer.insertSublayer(layer, at: 0)
        
    }
    
    public static func popSnackBar(containerView: UIView, message: String){
        let snackbar = TTGSnackbar.init(message: message, duration: .middle)
        snackbar.animationType = .slideFromTopBackToTop
        snackbar.backgroundColor = UIColor.init(hex: "#323232")
        snackbar.messageTextColor = UIColor.white
        snackbar.containerView = containerView
        snackbar.contentInset = UIEdgeInsets.init(top: 15, left: 20, bottom: 15, right: 20)
        snackbar.messageTextFont = UIFont.systemFont(ofSize: 15)
        snackbar.show()
    }

    public static func popDialog(controller: UIViewController, title: String, message: String, style: UIAlertController.Style, actions : [UIAlertAction], isEdit: Bool = false, completion: (() -> Void)? = nil) {
        
        var alertStyle = style
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alertStyle = .alert
        }
        let dialog = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        if #available(iOS 13.0, *) {
            dialog.overrideUserInterfaceStyle = .light
        }
        if isEdit {
            let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
                             NSAttributedString.Key.foregroundColor: UIColor.white]
            let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                               NSAttributedString.Key.foregroundColor: UIColor.white]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            dialog.setValue(titleAttrString, forKey: "attributedTitle")
            dialog.setValue(messageAttrString, forKey: "attributedMessage")
            dialog.view.tintColor = UIColor.white
            
            if let firstView = dialog.view.subviews.first, let contentView = firstView.subviews.first {
                for subView in contentView.subviews {
                    subView.backgroundColor = getRandomColor()
                }
            }
            
        } else {
            dialog.view.tintColor = UIColor.black
        }
        
        for action in actions {
            dialog.addAction(action)
        }
        
        if title == "Logout From GetNatty"{
            dialog.view.addSubview(UIView())
            dialog.pruneNegativeWidthConstraints()
            controller.present(dialog, animated: false)
        } else{
            controller.present(dialog, animated: true, completion: completion)
        }
    }
   
    public static func popDialog(_ controller: UIViewController, title: String, message: String){
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if #available(iOS 13.0, *) {
            dialog.overrideUserInterfaceStyle = .light
        }
        dialog.addAction(UIAlertAction.init(title: "Continue", style: .destructive) { _ in
            controller.dismiss(animated: true, completion: nil)
        })
        controller.present(dialog, animated: true, completion: nil)
    }
    
    public static func CheckLog(tag:String, value: String){
        #if DEBUG
            print(tag + ">>", value)
        #else
        
        #endif
    }
    
    public static func openBrowser(browseUrl: String) {
        let url = URL(string: browseUrl)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    public static func dialPhoneNumber(phoneNumber: String?) {
        if let number: String = phoneNumber {
            openBrowser(browseUrl: "tel://\(number)")
        }
    }
    
    public static func openWhatsapp(phoneNumber: String?, countryCode: String?) {
        if let number: String = phoneNumber {
            if let ccode: String = countryCode {
                let url = String.init(format: "https://api.whatsapp.com/send?phone=%@%@", ccode, number)
                openBrowser(browseUrl: url)
            } else {
                let url = String.init(format: "https://api.whatsapp.com/send?phone=%@%@", "91", number)
                openBrowser(browseUrl: url)
            }
        }
    }
    
    public static func getVC(vc_identifier: String) -> UIViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vc_identifier)
        if #available(iOS 13.0, *) {
            vc.overrideUserInterfaceStyle = .light
        }
        return vc
    }
   
    public static func getRandomColor(alpha: CGFloat) -> UIColor {
        
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
        
    }
    
    public static func getRandomColor() -> UIColor {
        
        if let color = self.randomColors.randomElement() {
            return UIColor.init(hex: color)
        }
        return getRandomColor(alpha: 1.0)
    }
    
    public static func getFormatDate(date: Date, format: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    public static func getFormatDate(date: String, fromFormat: String, toFormat: String)-> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        if let dateInstance = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = toFormat
            return dateFormatter.string(from: dateInstance)
        }
        
        return date
    }
    
    public static func getDate(date: String, format: String)-> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: date)!
    }
    
    public static func getDateText(date: String) -> String? {
        
        let targetDate = getDate(date: date, format: "yyyy-MM-dd hh:mm:ss")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.date(from: formatter.string(from: Date()))
        
        let difference:Double = targetDate.timeIntervalSince(currentDate!)
        let math: Double = 60 * 60 * 24
        
        let dayValue: Double = difference / math
        let days = Int.init(dayValue)
        
        if days == 0 {
            return "Today";
        } else if days == 1 {
            return "Tomorrow";
        }  else {
            return getFormatDate(date: date, fromFormat: "yyyy-MM-dd hh:mm:ss", toFormat: "dd MMM yyyy");
        }
        
    }
    
    public static func getSymbolForCurrencyCode(code: String) -> String? {
        let result = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == code }
        return result?.currencySymbol
    }
    
    public static func shareItems(controller: UIViewController, items : [Any]){
        let activityViewController = UIActivityViewController.init(activityItems: items, applicationActivities: nil)
        activityViewController.setValue("Active Life Coach", forKey: "Subject")
        activityViewController.popoverPresentationController?.sourceView = controller.view
        controller.present(activityViewController, animated: true, completion: nil)
    }

    public static func getCurrentTime() -> String {
        return String.init(Date.timeIntervalSinceReferenceDate).replacingOccurrences(of: ".", with: "_")
    }
    
    public static func getDirectoryPath() -> NSString {
        let directoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        return directoryPath
    }
    
    public static func createFile(dataPath: String, data: Data?) -> Bool {
        let fileManager = FileManager.default
        return fileManager.createFile(atPath: dataPath, contents: data, attributes: nil)
    }
    
    public static func deleteFile(_ url: URL){
        if FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                Utils.CheckLog(tag: "file", value: "\(error)")
            }
        }
    }
    
    public static func vibrate(){
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    public static func convertToInt(value: String?)-> Int {
        return Int.init(value ?? "0") ?? 0
    }
    
    public static func convertToString(value: String?)-> String {
        return value ?? ""
    }
    
    public static func openVideoPlayer(_ controller: UIViewController, _ videoUrl: URL){
        let player = AVPlayer.init(url: videoUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = controller.view.bounds
        playerViewController.showsPlaybackControls = true
        controller.present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    public static func getCurrencyFormat(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value))!
    }
    
    public static func attachCameraPreview(container: UIView, preview: UIView) {
        // Clear current view, and then attach the new view.
        container.subviews.forEach { $0.removeFromSuperview() }
        preview.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(preview)
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
            preview.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0),
            preview.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            preview.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
        ])
    }
    
    public static func checkAVPermissions(_ result: @escaping (Bool) -> Void) {
        // Make sure we have both audio and video permissions before setting up the broadcast session.
        checkOrGetPermission(for: .video) { granted in
            guard granted else {
                result(false)
                return
            }
            self.checkOrGetPermission(for: .audio) { granted in
                guard granted else {
                    result(false)
                    return
                }
                result(true)
            }
        }
    }
    
    public static func checkOrGetPermission(for mediaType: AVMediaType, _ result: @escaping (Bool) -> Void) {
        func mainThreadResult(_ success: Bool) {
            DispatchQueue.main.async { result(success) }
        }
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized: mainThreadResult(true)
        case .notDetermined: AVCaptureDevice.requestAccess(for: mediaType) { mainThreadResult($0) }
        case .denied, .restricted: mainThreadResult(false)
        @unknown default: mainThreadResult(false)
        }
    }

}

extension UIImageView {
    
    public func loadImage(imageUrl : String?, placeHolder : String, isCache : Bool, contentMode: UIView.ContentMode = .scaleAspectFit) {
        if let urlString = imageUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let image_url = URL.init(string: urlString) {
            loadImage(imageUrl: image_url, placeHolder: placeHolder, isCache: isCache, contentMode: contentMode)
        } else {
            self.image = UIImage.init(named: placeHolder)
        }
    }
    
    public func loadImage(imageUrl : URL?, placeHolder : String, isCache : Bool, contentMode: UIView.ContentMode = .scaleAspectFit) {
        if !isCache {
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk()
        }
        self.contentMode = contentMode
        self.layer.masksToBounds = true
        self.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: placeHolder))
    }
}

extension UIImage {
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
    
}

extension Data {
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension String {
    
    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func getHtml() -> NSAttributedString {
        
        guard let data = data(using: .utf8) else {
            return NSAttributedString()
        }
        
        do {

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding : String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt;" +
                "color: #\(color.hex());" +
                "font-family: \(family ?? "Helvetica");" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options:
                [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToAttributedString: NSAttributedString? {
        return Data(utf8).htmlToAttributedString
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var withoutSpecialCharacters: String {
        return self.components(separatedBy: CharacterSet.symbols).joined(separator: "")
    }
    
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
}

extension UIView {
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, color: UIColor, thickness: CGFloat, spacing: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.borderWidth = thickness
        
        let doubleSpace = spacing * 2
        
        var borderFrame = CGRect.init()
        switch side {
        case .Left:
            borderFrame = CGRect(x: frame.minX, y: frame.minY + spacing, width: thickness, height: frame.height - doubleSpace)
            break
        case .Right:
            borderFrame = CGRect(x: frame.maxX, y: frame.minY + spacing, width: thickness, height: frame.height - doubleSpace)
            break
        case .Top:
            borderFrame = CGRect(x: frame.minX + spacing, y: frame.minY, width: frame.width - doubleSpace, height: thickness)
            break
        case .Bottom:
            borderFrame = CGRect(x: frame.minX + spacing, y: frame.maxY, width: frame.width - doubleSpace, height: thickness)
            break
        }
        
//        let borderView = UIView.init(frame: borderFrame)
//        borderView.backgroundColor = color
//        self.addSubview(borderView)
        
        border.frame = borderFrame
        layer.addSublayer(border)
    }
    
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

public extension UIColor {
    
    convenience init(hex string: String) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
    }
    
    func hex(hashPrefix: Bool = true) -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let prefix = hashPrefix ? "#" : ""
        
        return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func displayPermissionError() {
        let alert = UIAlertController(title: "Permission Error",
                                      message: "This app does not have access to either the microphone or camera permissions. Please go into system settings and enable thees permissions for this app.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func displayErrorAlert(_ error: Error, _ msg: String) {
        // Display the error if something went wrong.
        // This is mainly for debugging. Human-readable error descriptions are provided for
        // `IVSBroadcastError`s, but they may not be especially useful for the end user.
        let alert = UIAlertController(title: "Error \(msg) (Code: \((error as NSError).code))",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

public extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}
