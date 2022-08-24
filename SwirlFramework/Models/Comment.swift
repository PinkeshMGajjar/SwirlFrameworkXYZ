//
//  Comment.swift
//  InStore Console
//
//  Created by Pinkesh Gajjar on 22/07/22.
//  Copyright © 2022 GetNatty. All rights reserved.
//

import Foundation

struct Comment : Equatable {
    
    // If any change or update in Comment struct its also effect on Delete comment data (like flag is commented)
    var cover_img : String?
    var created_time: Int?
    //var flag: String?
    var from: String?
    var is_designer: Bool?
    var is_designer_seen: Bool?
    var message: String?
    var name: String?
    var profile: String?
    var title: String?
    var type: String?
    var user_phone: String?
    
    init() {
        self.cover_img = ""
        self.created_time = 0
        //self.flag = ""
        self.from = ""
        self.is_designer = false
        self.is_designer_seen = false
        self.message = ""
        self.name = ""
        self.profile = ""
        self.title = ""
        self.type = ""
        self.user_phone = ""
    }
}
