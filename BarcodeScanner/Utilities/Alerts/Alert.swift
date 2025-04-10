//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Nikk Bhateja on 07/04/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext{
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input",
                                       message: "Something went wrong with the camera. We are unable to capture the input",
                                       dismissButton: .default(Text("Ok")))
    
    static let invalidVideoInput = AlertItem(title: "Invalid Video Input",
                                             message: "The video input cannot be created, Please check your device",
                                             dismissButton: .default(Text("Ok")))
    
    static let videoInputAddFailed = AlertItem(title: "Video Input cannot be added To Camera",
                                             message: "The video inout is created but now ready for display, seems like something went wrong with system configuration",
                                             dismissButton: .default(Text("Ok")))
    
    static let canAddVideoOutputFailed = AlertItem(title: "Output of scanner cannot be generated",
                                             message: "The video output cannot be created, Please check your device",
                                             dismissButton: .default(Text("Ok")))
    
    static let invalidScanType = AlertItem(title: "Invalid Scan Type",
                                       message: "The Bardcode you are scaning is invalid, This app scan only ENA-8, EAN-13, QR, MicroQR",
                                       dismissButton: .default(Text("Ok")))
    
    
    
    
  
}
