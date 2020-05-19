//
//  configuration.swift
//  Macs Ager
//
//  Created by Loyi on 2019/7/9.
//  Copyright © 2019 Loyiworks. All rights reserved.
//

import Foundation

var timezoneGMT: String { TimeZone.current.abbreviation() ?? "GMT+0"}
let timeAppearDefaults = true                       // Whether to show days in menu bar
let expect             = 365 * 4                    // Expected device life in days
var deviceName         = "Mac"                      // Preferred name of your device
var targetDay = Date()

let currentLanguage    = "English"                  // Available language: English, 中文
var setupDone          = false
