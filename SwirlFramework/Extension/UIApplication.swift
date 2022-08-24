//
//  UIApplication.swift
//  InStore Console
//
//  Created by A.Live Mind on 02/11/21.
//  Copyright © 2021 GetNatty. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}
