//
//  AppDelegate.swift
//  Macs Ager
//
//  Created by Loyi on 2019/7/8.
//  Copyright © 2019 Loyiworks. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    //MARK: - Initialize
    var setupWindow = NSWindow()
    var setupWindowAppeared = false
    var menuStatus = false
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // Tags
    let expectedDays = Double(expect)
    
    // Flags
    var titleAppear = timeAppearDefaults
    
    // MARK: - Dafaults
    
    func getUserSettings() {
        if let date = UserDefaults.standard.object(forKey: "userSetDate") as? Date,
            let name = UserDefaults.standard.object(forKey: "userSetName") as? String {
            
            let expected = UserDefaults.standard.integer(forKey: "userSetExpect")
            
            targetDay = date
            setupDeviceName = name
            expect = expected
            setupDone = true
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        getUserSettings()
        
        statusItem.title = ""
        
        // Setup the status bar image
        if let button = statusItem.button {
            let statusbarImage = NSImage(named: NSImage.Name("StatusBarButtonImage"))
            button.image = statusbarImage
        }
        
        if setupDone == true {
            // Create date from components
            constructMenu()
        } else {
            constructInitialiser()
        }
        
        // Setup a timer to keep it updated
        let counting = Timer.scheduledTimer(
            timeInterval: 0.5, target: self, selector: #selector(self.update),
            userInfo: nil, repeats: true
        )
        
        RunLoop.main.add(counting, forMode: .common) // To avoid loop being blocked by menu bar clicks
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //MARK: - Main functions
    
    /// Construct the menu bar on click menu
    func constructMenu() {
        menuStatus = true
        var menu = NSMenu()
        
        let quitItem = menuItemSetup("\(LOCA_quit) \(LOCA_appName)", #selector(NSApplication.terminate(_:)), "", nil)
        
        let years = menuItemSetup(setupDeviceName, nil, "", 50)
        let equi = menuItemSetup(LOCA_equaz, nil, "", 60)
        let dop = menuItemSetup("\(LOCA_dateOfPurchase) \(dateFormatterForDSGNT())", nil, "", 888);
        let reset = menuItemSetup(LOCA_reset, #selector(self.reset), "", nil)
        
        let hid = menuItemSetup(LOCA_hideNum, #selector(self.hideDays), "", 10)
        
        let names  = menuItemSetup("\(LOCA_appName) by Loyiworks", nil, "", nil)
        let vers = menuItemSetup("\(versions())", nil, "", nil)
        
        addSeveralMenuItemToMenu(&menu, [quitItem, .separator(),
                                         names, vers, .separator(),
                                         years, equi, .separator(),
                                         dop, reset, .separator(),
                                         hid])
        
        self.statusItem.menu = menu
    }
    
    /// Construct the setup menu for first time users.
    func constructInitialiser() {
        var menu = NSMenu()
        
        let quitItem = menuItemSetup("\(LOCA_quit) \(LOCA_appName)", #selector(NSApplication.terminate(_:)), "", nil)
        let setupItem = menuItemSetup(LOCA_setup, #selector(callSetup), "", nil)
        
        addSeveralMenuItemToMenu(&menu, [quitItem, .separator(), setupItem])
        
        self.statusItem.menu = menu
    }
    
    @objc func reset() {
        setupDone = false
        callSetup()
    }
    
    @objc func callSetup() {
        if self.setupWindowAppeared == true {
            self.setupWindow.makeKeyAndOrderFront(nil)
        } else {
            let setupView = SetupView()
            
            self.setupWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
                styleMask: [.titled, .closable, .fullSizeContentView],
                backing: .buffered, defer: false)
            
            self.setupWindow.titlebarAppearsTransparent = true
            
            self.setupWindow.center()
            self.setupWindow.setFrameAutosaveName("Setup Window")
            self.setupWindow.contentView = NSHostingView(rootView: setupView)
            self.setupWindow.makeKeyAndOrderFront(nil)
            
            self.setupWindow.delegate = self
            self.setupWindowAppeared = true
        }
    }
    
    /// Switch the hide days option on and off
    @objc func hideDays() {
        titleAppear = statusItem.menu?.item(withTag: 10)?.state == .on ? true : false
        statusItem.menu?.item(withTag: 10)?.state = titleAppear ? .off : .on
    }
    
    /// Update on each cycle
    @objc func update() {
        if setupDone {
            if menuStatus == false { constructMenu() }
            
            let time = (targetDay.timeIntervalSinceNow/86400).abs()
            
            statusItem.title = titleAppear == true ? " \(String(Int(time)))" : ""
            
            let percentage = (Double(Int(time))/expectedDays) * 100
            
            var leftdays = time
            
            let year = Int(leftdays / 365.25)
            leftdays = Double(Int(leftdays) - Int(Double(year) * 365.25))
            let month = Int(leftdays/30.44)
            leftdays = Double(Int(leftdays) - Int(Double(month) * 30.44))
            
            let year_str = year == 1 ? LOCA_year : year >= 2 ? "\(year)\(LOCA_years)" : ""
            let month_str = month == 1 ? LOCA_month : month >= 2 ? "\(month)\(LOCA_months)" : ""
            var day_str = leftdays == 1 ? LOCA_day : leftdays >= 2 ? "\(Int(leftdays))\(LOCA_days)" : LOCA_brandNew
            if month_str.isEmpty == false || year_str.isEmpty == false { day_str = "\(LOCA_and)\(day_str)" }
            
            setItemTitleAt(tag: 50, title: "\(setupDeviceName): \(String(Int(time))) (\(percentage.format(f: ".2"))%)") // Update percentage
            setItemTitleAt(tag: 60, title: "\(LOCA_itz)\(year_str)\(month_str)\(day_str)")   // Update human readable y-m-d representation

            if dopNeedsUpdate {
                setItemTitleAt(tag: 888, title: "\(LOCA_dateOfPurchase) \(dateFormatterForDSGNT())")    // Update Date of Purchase
                dopNeedsUpdate = false
            }

        }
    }
    
    // MARK: - Make Life Easier
    
    func setItemTitleAt(tag: Int, title: String) {
        statusItem.menu?.item(withTag: tag)?.title = title
    }
    
    func addSeveralMenuItemToMenu(_ myMenu: inout NSMenu, _ items: [NSMenuItem]) {
        for i in items {
            myMenu.addItem(i)
        }
    }
    
    func menuItemSetup(_ title: String, _ action: Selector?, _ keyeq: String, _ tag: Int?) -> NSMenuItem {
        let output = NSMenuItem.init(title: title, action: action, keyEquivalent: keyeq)
        if let t = tag { output.tag = t }
        return output
    }
    
    func windowWillClose(_ notification: Notification) {
        setupWindowAppeared = false
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    func abs() -> Double {
        return self < 0 ? self * -1 : self
    }
}

func dateFormatterForDSGNT() -> String {
    let formatter = DateFormatter.init()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter.string(from: targetDay)
}

func versions() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    let build = dictionary["CFBundleVersion"] as! String
    
    return "Ver. \(version).\(build)"
}
