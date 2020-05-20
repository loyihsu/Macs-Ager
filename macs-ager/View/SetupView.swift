//
//  SetupView.swift
//  Macs Ager
//
//  Created by Loyi Hsu on 2020/5/19.
//  Copyright © 2020 Loyiworks. All rights reserved.
//

import SwiftUI

struct SetupView: View {
    @State var deviceName: String = "Mac"
    @State var time = targetDay
    @State var years: String = "4"
    
    func validateYears() -> Bool {
        return years.filter { $0 == "." }.count < 2
            && years.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).count <= 1
            && years.isEmpty == false
    }
    
    var body: some View {
        VStack{
            Text(LOCA_enterInfo)
            VStack {
                HStack {
                    Text(LOCA_deviceNameLabel)
                    TextField(LOCA_enterHerePlaceholder, text: $deviceName)
                }
                DatePicker(selection: $time, label: { Text(LOCA_startCounting) })
                VStack {
                    Text(LOCA_expectQues)
                    HStack {
                        TextField(LOCA_pluralYear, text: $years)
                            .frame(width: 80)
                        Text(years == "1" ? LOCA_singularYear : LOCA_pluralYear)
                    }
                }
            }
            .padding(.horizontal)

            HStack {
                Button(action: {
                    targetDay = self.time
                    setupDeviceName = self.deviceName
                    expect = Int(Double(self.years)! * 365)

                    UserDefaults.standard.set(self.time, forKey: "userSetDate")
                    UserDefaults.standard.set(self.deviceName, forKey: "userSetName")
                    UserDefaults.standard.set(expect, forKey: "userSetExpect")
                    for window in NSApp.windows {
                        if let view = window.contentView as? NSHostingView<SetupView> {
                            view.window?.orderOut(self)
                        }
                    }

                    dopNeedsUpdate = true
                    setupDone = true
                }) {
                    Text(LOCA_okay)
                }
                .disabled(!validateYears())

                Button(action: {
                    for window in NSApp.windows {
                        if let view = window.contentView as? NSHostingView<SetupView> {
                            view.window?.orderOut(self)
                        }
                    }
                    setupDone = true
                }) {
                    Text(LOCA_cancel)
                }

            }
            .padding(.top, 10.0)
        }
        .frame(width: 360, height: 210, alignment: .center)
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
