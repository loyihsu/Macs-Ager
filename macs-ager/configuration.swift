//
//  configuration.swift
//  Macs Ager
//
//  Created by Loyi on 2019/7/9.
//  Copyright © 2019 Loyiworks. All rights reserved.
//

import Foundation

var timezoneGMT: String { TimeZone.current.abbreviation() ?? "GMT+0"}
let timeAppearDefaults = true       // Whether to show days in menu bar
var expect = 365 * 4                // Expected device life in days
var setupDeviceName = "Mac"         // Preferred name of your device
var targetDay = Date()

var setupDone = false
var dopNeedsUpdate = false
