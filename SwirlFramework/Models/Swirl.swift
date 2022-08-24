//
//  Swirl.swift
//  GetNatty
//
//  Created by pinkesh gajjar on 01/12/20.
//

import Foundation

struct SwirlsData{
    var arrayOfSwirl: [Swirl] = []
}

extension SwirlsData {
    
    init(jsonData: NSDictionary) {
        let dataDict = jsonData["datass"] as? Dictionary<String, Any> ?? Dictionary<String, Any>()
        print("From Dict: ", dataDict["currencynamess"] as? String ?? "")
//        let videoDictArray = dataDict["all_video"] as! NSArray
//        for singleDict in videoDictArray{
//            let singleDict = Swirl(jsonDataDict: singleDict as! NSDictionary)
//            self.arrayOfSwirl.append(singleDict)
//        }
    }
}

struct Swirl {
    var swirlId: Int
    var brandName: String
    var designerName: String
    var userProfile: String
    var serverUrl: String
}

extension Swirl{
    
    init() {
        self.swirlId = 0
        self.brandName = ""
        self.designerName = ""
        self.userProfile = ""
        self.serverUrl = ""
    }
    
    init(jsonDataDict: NSDictionary) {
        self.swirlId = 0
        self.brandName = ""
        self.designerName = ""
        self.userProfile = ""
        self.serverUrl = ""
        
        self.brandName = (jsonDataDict.object(forKey: "brand_name") as? String) ?? ""
        self.designerName = (jsonDataDict.object(forKey: "designer_name") as? String) ?? ""
        self.userProfile = (jsonDataDict.object(forKey: "user_profile") as? String) ?? ""
        self.serverUrl = (jsonDataDict.object(forKey: "server_url") as? String) ?? ""
    }
    
}
