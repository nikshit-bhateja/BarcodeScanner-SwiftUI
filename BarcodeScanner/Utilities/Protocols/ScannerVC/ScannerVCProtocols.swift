//
//  ScannerVCProtocols.swift
//  BarcodeScanner
//
//  Created by Nikk Bhateja on 07/04/25.
//

protocol ScannerVCDelegate: AnyObject {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
    func restartCaptureSession() 
}
