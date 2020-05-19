//
//  SetupView.swift
//  Macs Ager
//
//  Created by Loyi Hsu on 2020/5/19.
//  Copyright © 2020 Loyiworks. All rights reserved.
//

import SwiftUI

#warning("Not yet localised.")

struct SetupView: View {
    @State var deviceName: String = "Mac"
    @State var time = Date()
    @State var years: String = "4"
    
    func validateYears() -> Bool {
        return years.filter { $0 == "." }.count < 2
            && years.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).count <= 1
            && years.isEmpty == false
    }
    
    var body: some View {
        VStack{
            Text("Please enter the following information.")
            VStack {
                HStack {
                    Text("Device Name:")
                    TextField("Enter your device name here.", text: $deviceName)
                }
                DatePicker(selection: $time, label: { Text("Start Counting From...") })
                VStack {
                    Text("How long do you expect to use this Mac?")
                    HStack {
                        TextField("Years", text: $years)
                            .frame(width: 80)
                        Text("years")
                    }
                }
            }
            .padding(.horizontal)
            
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
                Text("OK")
            }
            .disabled(!validateYears())
            .padding(.top, 10.0)
        }
        .frame(width: 360, height: 210, alignment: .center)
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        SetupView()
    }
}
