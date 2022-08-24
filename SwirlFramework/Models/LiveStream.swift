//
//  LiveStream.swift
//  SwirlFramework
//
//  Created by Pinkesh Gajjar on 23/08/22.
//

import Foundation
import ObjectMapper

struct LiveStream: Mappable {
    
    var stream_id: String?
    var designer_id: String?
    var title : String?
    var cover_img : String?
    var recording_url : String?
    var mogi_accessurl: String?
    var product_ids: String?
    var starting_time: String?
    var ending_time : String?
    var is_schedule : String?
    var stream_platform: String?
    var status : String?
    var is_defer : String?
    var banner_url : String?
    var banner_content_color : String?
    var pin_comment: String?
    var user_profile: String?
    var designer_brand_name : String?
    var subdomain : String?
    var streamURL: String?
    
    init?(map: Map) {
        
        self.stream_id = ""
        self.designer_id = ""
        self.title = ""
        self.cover_img = ""
        self.recording_url = ""
        self.mogi_accessurl = ""
        self.product_ids = ""
        self.starting_time = ""
        self.ending_time = ""
        self.is_schedule = ""
        self.stream_platform = ""
        self.status = ""
        self.is_defer = ""
        self.banner_url = ""
        self.banner_content_color = ""
        self.pin_comment = ""
        self.user_profile = ""
        self.designer_brand_name = ""
        self.subdomain = ""
        self.streamURL = ""
    }
    
    mutating func mapping(map: Map) {
        
        self.stream_id <- map["streram_id"]
        self.designer_id <- map["designer_id"]
        self.title <- map["title"]
        self.cover_img <- map["cover_img"]
        self.recording_url <- map["recording_url"]
        self.mogi_accessurl <- map["mogi_accessurl"]
        self.product_ids <- map["product_ids"]
        self.starting_time <- map["starting_time"]
        self.ending_time <- map["ending_time"]
        self.is_schedule <- map["is_schedule"]
        self.stream_platform <- map["stream_platform"]
        self.status <- map["status"]
        self.is_defer <- map["is_defer"]
        self.banner_url <- map["banner_url"]
        self.banner_content_color <- map["banner_content_color"]
        self.pin_comment <- map["pin_comment"]
        self.user_profile <- map["user_profile"]
        self.designer_brand_name <- map["designer_brand_name"]
        self.subdomain <- map["subdomain"]
        self.streamURL <- map["streamURL"]
    }
}
