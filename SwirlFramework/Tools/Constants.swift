//
//  Constants.swift
//  Life Coach
//
//  Created by Atirek Pothiwala on 29/10/18.
//  Copyright © 2018 Dr keironbrown. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
//import GoogleSignIn
//import GoogleAPIClientForREST

class Constants {
    
    //public static let logo_url = "https://ams3.digitaloceanspaces.com/gn-static01/assets/new_homepage/app/GetNatty_InStore_designer.png"
    public static let white_logo = "https://ams3.digitaloceanspaces.com/gn-static01/assets/new_homepage/images/Logo-white.png"
    public static let black_logo = "https://ams3.digitaloceanspaces.com/gn-static01/assets/new_homepage/images/Logo-Black.png"

    public static let noInternet = "No internet connection is available, please try again."
    public static let errorSomething = "Something went wrong, please try again."
    
    public static let jw_cover_url = "https://cdn.jwplayer.com/v2/media/%@/poster.jpg"
    public static let jw_media_url = "https://cdn.jwplayer.com/manifests/%@.m3u8"
    public static let ant_media_url = "rtmp://68.183.80.179/LiveApp/%@"
    public static let ivs_endpoint_url = "rtmps://f956bcbdef39.global-contribute.live-video.net:443/app/"
    public static let ant_media_player = "http://68.183.80.179:5080/LiveApp/streams/"
    
    //public static let web_url = "https://goswirl.in/index.php" //"https://swirlapp.live/index.php" //pleaseremove
    public static let web_url = "https://store.goswirl.live/index.php" //"https://www.getnatty.com"
    
    public static let live_schedule_stream = "/api/Sdkcon/streamListing"
    
   
    
    public static let labelFontDarkColor = UIColor.init(hex: "#323232")
    public static let headerBackgroundColor = UIColor.init(hex: "#f3f3f3")
    
    public static let deviceWidth = UIScreen.main.bounds.size.width
    public static let deviceHeight = UIScreen.main.bounds.size.height
    
    public static let AllPriceRequest = "Price Request"
    public static let AllAudios = "Audios"
    public static let AllBrandInquiries = "Brand Inquiry"
    public static let AllLiveStream = "Live Stream"
    public static let AllShowmes = "Show Me"
    public static let AllAskQue = "Ask Question"
    public static var liveNowTitle = ""
    
    public static var UnknownData = "--"
        
    public static func setUserDetails(json: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "user")
        user.setValue(json, forKey: "user")
        user.synchronize()
    }
    
    public static func checkUserExists()-> Bool {
        let user = UserDefaults.standard
        return user.value(forKey: "user") != nil
    }
    
    public static func setUserCurrency(stringSymbol: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "currency")
        user.setValue(stringSymbol, forKey: "currency")
        user.synchronize()
    }
    
    public static func getUserCurrency() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "currency") as? String {
            return token
        }
        return ""
    }
    
    public static func setLiveStreamStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "liveStreamStatus")
        user.setValue(status, forKey: "liveStreamStatus")
        user.synchronize()
    }
    
    public static func getLiveStreamStatus() -> Bool {
        let user = UserDefaults.standard
        if let fbStatus = user.value(forKey: "liveStreamStatus") as? Bool {
            return fbStatus
        }
        return true
    }
    
    public static func setSwirlStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "swirlStatus")
        user.setValue(status, forKey: "swirlStatus")
        user.synchronize()
    }
    
    public static func getSwirlStatus() -> Bool {
        let user = UserDefaults.standard
        if let fbStatus = user.value(forKey: "swirlStatus") as? Bool {
            return fbStatus
        }
        return true
    }
    
    public static func setVideoCallStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "videoCallStatus")
        user.setValue(status, forKey: "videoCallStatus")
        user.synchronize()
    }
    
    public static func getVideoCallStatus() -> Bool {
        let user = UserDefaults.standard
        if let fbStatus = user.value(forKey: "videoCallStatus") as? Bool {
            return fbStatus
        }
        return true
    }
    
    public static func setLeadsStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "leadsStatus")
        user.setValue(status, forKey: "leadsStatus")
        user.synchronize()
    }
    
    public static func getLeadsStatus() -> Bool {
        let user = UserDefaults.standard
        if let fbStatus = user.value(forKey: "leadsStatus") as? Bool {
            return fbStatus
        }
        return true
    }
    
    public static func setShortVideoTime(time: Int) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "video_time")
        user.setValue(time, forKey: "video_time")
        user.synchronize()
    }
    
    public static func getShortVideoTime() -> Int {
        let tokenDefaults = UserDefaults.standard
        if let timeDuration = tokenDefaults.value(forKey: "video_time") as? Int {
            return timeDuration
        }
        return 0
    }
    
    public static func setNotificationMsg(stringSymbol: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "notification_msg")
        user.setValue(stringSymbol, forKey: "notification_msg")
        user.synchronize()
    }
    
    public static func getNotificationMsg() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "notification_msg") as? String {
            return token
        }
        return ""
    }
    
    public static func setUserCurrencyName(stringSymbol: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "currencyname")
        user.setValue(stringSymbol, forKey: "currencyname")
        user.synchronize()
    }
    
    public static func getUserCurrencyName() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "currencyname") as? String {
            return token
        }
        return ""
    }
    
    public static func setGoLiveStartTime(stringSymbol: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "start_time")
        user.setValue(stringSymbol, forKey: "start_time")
        user.synchronize()
    }
    
    public static func getGoLiveStartTime() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "start_time") as? String {
            return token
        }
        return ""
    }
    
    public static func getUserDetails(key: String) -> String {
        let userDefaults = UserDefaults.standard
        if let json: String = userDefaults.value(forKey: "user") as? String {
            let user = JSON.init(parseJSON: json)
            return user[key].stringValue
        }
        return ""
    }
    
//    public static func getUserDetails() -> Designer? {
//           let userDefaults = UserDefaults.standard
//           if let json: String = userDefaults.value(forKey: "user") as? String {
//            return Mapper<Designer>().map(JSONString: json)
//           }
//           return nil
//       }
    
    public static func clearUserDetails() {
        let user = UserDefaults.standard
        user.removeObject(forKey: "user")
        //user.removeObject(forKey: "token")
    }
    
    public static func setToken(_ token: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "token")
        user.setValue(token, forKey: "token")
        user.synchronize()
    }
    
    public static func getToken() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "token") as? String {
            return token
        }
        return ""
    }
    
    public static func setGmailToken(_ token: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "gmailtoken")
        user.setValue(token, forKey: "gmailtoken")
        user.synchronize()
    }
    
    public static func getGmailToken() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "gmailtoken") as? String {
            return token
        }
        return ""
    }
    
    public static func setDesignerSlugURL(_ token: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "designer_slug_url")
        user.setValue(token, forKey: "designer_slug_url")
        user.synchronize()
    }
    
    public static func getDesignerSlugURL() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "designer_slug_url") as? String {
            return token
        }
        return ""
    }
    
    public static func setSocialFeatureStatus(_ token: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "designer_featured_status")
        user.setValue(token, forKey: "designer_featured_status")
        user.synchronize()
    }
    
    public static func getSocialFeatureStatus() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "designer_featured_status") as? String {
            return token
        }
        return ""
    }
    
    public static func setStreamPlatform(_ token: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "stream_platform")
        user.setValue(token, forKey: "stream_platform")
        user.synchronize()
    }
    
    public static func getStreamPlatform() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "stream_platform") as? String {
            return token
        }
        return ""
    }
    
    public static func setBaseUrlForMogi(_ baseUrl: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "base_url_mogi")
        user.setValue(baseUrl, forKey: "base_url_mogi")
        user.synchronize()
    }
    
    public static func getBaseUrlForMogi() -> String {
        let baseUrlDefaults = UserDefaults.standard
        if let baseUrl = baseUrlDefaults.value(forKey: "base_url_mogi") as? String {
            return baseUrl
        }
        return ""
    }
    
    public static func setStreamIdForMogi(_ token: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "stream_id_mogi")
        user.setValue(token, forKey: "stream_id_mogi")
        user.synchronize()
    }
    
    public static func getStreamIdForMogi() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "stream_id_mogi") as? String {
            return token
        }
        return ""
    }
    
    public static func setFBUserId(_ token: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "fb_user_id")
        user.setValue(token, forKey: "fb_user_id")
        user.synchronize()
    }
    
    public static func getFBUserId() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "fb_user_id") as? String {
            return token
        }
        return ""
    }
    
    public static func setFBVideoId(_ token: String) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "fb_video_id")
        user.setValue(token, forKey: "fb_video_id")
        user.synchronize()
    }
    
    public static func getFBVideoId() -> String {
        let tokenDefaults = UserDefaults.standard
        if let token = tokenDefaults.value(forKey: "fb_video_id") as? String {
            return token
        }
        return ""
    }
    
//    public static func setSelectedProduct(_ arrayOfProduct: [StreamProduct]) {
//        let user = UserDefaults.standard
//        user.removeObject(forKey: "selected_product")
//        user.setValue(arrayOfProduct, forKey: "selected_product")
//        user.synchronize()
//    }
//
//    public static func getSelectedProduct() -> [StreamProduct] {
//        let tokenDefaults = UserDefaults.standard
//        if let arrayOfProduct = tokenDefaults.value(forKey: "selected_product") as? [StreamProduct] {
//            return arrayOfProduct
//        }
//        return []
//    }
    
//    public static func setGoogleUser(_ googleUser: GIDGoogleUser) {
//        let user = UserDefaults.standard
//        user.removeObject(forKey: "google_user")
//        user.setValue(googleUser, forKey: "google_user")
//        user.synchronize()
//    }
//    
//    public static func getGoogleUser() -> GIDGoogleUser {
//        let tokenDefaults = UserDefaults.standard
//        if let googleUser = tokenDefaults.value(forKey: "google_user") as? GIDGoogleUser {
//            return googleUser
//        }
//        return GIDGoogleUser()
//    }
    
    public static func setSelectedProductId(_ arrayOfProductId: [String]) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "selected_productId")
        user.setValue(arrayOfProductId, forKey: "selected_productId")
        user.synchronize()
    }
    
    public static func getSelectedProductId() -> [String] {
        let tokenDefaults = UserDefaults.standard
        if let arrayOfProductId = tokenDefaults.value(forKey: "selected_productId") as? [String] {
            return arrayOfProductId
        }
        return []
    }
    
    public static func youtubeAllowStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "youtube_status")
        user.setValue(status, forKey: "youtube_status")
        user.synchronize()
    }
    
    public static func isYoutubeAllow() -> Bool {
        let user = UserDefaults.standard
        if let hide_record = user.value(forKey: "youtube_status") as? Bool {
            return hide_record
        }
        return false
    }
    
    public static func setFBLoginStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "fb_login_status")
        user.setValue(status, forKey: "fb_login_status")
        user.synchronize()
    }
    
    public static func getFBLoginStatus() -> Bool {
        let user = UserDefaults.standard
        if let fbStatus = user.value(forKey: "fb_login_status") as? Bool {
            return fbStatus
        }
        return false
    }
    
    public static func setGmailLoginStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "gmail_login_status")
        user.setValue(status, forKey: "gmail_login_status")
        user.synchronize()
    }
    
    public static func getGmailLoginStatus() -> Bool {
        let user = UserDefaults.standard
        if let gmailStatus = user.value(forKey: "gmail_login_status") as? Bool {
            return gmailStatus
        }
        return false
    }
    
    public static func setFBSwitchStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "fb_switch_status")
        user.setValue(status, forKey: "fb_switch_status")
        user.synchronize()
    }
    
    public static func getFBSwitchStatus() -> Bool {
        let user = UserDefaults.standard
        if let hide_record = user.value(forKey: "fb_switch_status") as? Bool {
            return hide_record
        }
        return false
    }
    
    public static func setInstagramStatus(_ status: Bool) {
        let user = UserDefaults.standard
        user.removeObject(forKey: "instagram_status")
        user.setValue(status, forKey: "instagram_status")
        user.synchronize()
    }
    
    public static func getInstagramStatus() -> Bool {
        let user = UserDefaults.standard
        if let hide_record = user.value(forKey: "instagram_status") as? Bool {
            return hide_record
        }
        return false
    }

    public static func hideRecord() {
        let user = UserDefaults.standard
        user.setValue(true, forKey: "hide_record")
        user.synchronize()
    }
    
    public static func isRecordHidden() -> Bool {
        let user = UserDefaults.standard
        if let hide_record = user.value(forKey: "hide_record") as? Bool {
            return hide_record
        }
        return false
    }

    public static func hideGallery() {
        let user = UserDefaults.standard
        user.setValue(true, forKey: "hide_gallery")
        user.synchronize()
    }
    
    public static func isGalleryHidden() -> Bool {
        let user = UserDefaults.standard
        if let hide_gallery = user.value(forKey: "hide_gallery") as? Bool {
            return hide_gallery
        }
        return false
    }
    
    public static func utcToLocal(dateStr: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    public static func utcToLocal2(dateStr: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    public static func setFont(fontType: FontType, size: CGFloat) -> UIFont {
        switch fontType {
            case .Regular:
                return UIFont(name:"GREYCLIFFCF-REGULAR", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
            case .Medium:
                return UIFont(name:"GREYCLIFFCF-MEDIUM", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
            case .Light:
                return UIFont(name:"GREYCLIFFCF-LIGHT", size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
            case .Heavy:
                return UIFont(name:"GREYCLIFFCF-HEAVY", size: size) ?? UIFont.systemFont(ofSize: size, weight: .heavy)
            case .ExtraBold:
                return UIFont(name:"GREYCLIFFCF-EXTRABOLD", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
            case .DemiBold:
                return UIFont(name:"GREYCLIFFCF-DEMIBOLD", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
            case .Bold:
                return UIFont(name:"GREYCLIFFCF-BOLD", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }

    public static func fonts() {
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    
    public static func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return String(text.filter {okayChars.contains($0) })
    }
    
    public static func removeSpecialCharsFromStringWithDot(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890.")
        return String(text.filter {okayChars.contains($0) })
    }
    
    public static func removeSpecialCharsFromPrice(text: String) -> String {
        let okayChars : Set<Character> =
            Set("1234567890.,")
        return String(text.filter {okayChars.contains($0) })
    }
}
