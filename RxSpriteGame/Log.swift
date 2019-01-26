//
//  Log.swift
//  RxSpriteGame
//
//  Created by Maxim Volgin on 25/01/2019.
//  Copyright © 2019 Maxim Volgin. All rights reserved.
//

import Foundation

import Foundation
import os.log

struct Log {
    fileprivate static let subsystem: String = Bundle.main.bundleIdentifier ?? ""
    
    static let gk = OSLog(subsystem: subsystem, category: "GK")
    static let sk = OSLog(subsystem: subsystem, category: "SK")
    
}

