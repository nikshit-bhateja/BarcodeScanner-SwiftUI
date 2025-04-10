//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Nikk Bhateja on 05/04/25.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannerCode: String
    @Binding var alertItem: AlertItem?
    @Binding var restartScanner: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
        if restartScanner {
            uiViewController.restartScanner()
            
            DispatchQueue.main.async {
                self.restartScanner = false
            }
        }
    }
    
    final class Coordinator: NSObject, ScannerVCDelegate {
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        func didFind(barcode: String) {
            scannerView.scannerCode = barcode
        }
        
        func didSurface(error: CameraError) {
            switch error {
            case .invalidDeviceType:
                scannerView.alertItem = AlertContext.invalidDeviceInput
                
            case .invalidVideoInput:
                scannerView.alertItem = AlertContext.invalidVideoInput
                
            case .videoInputAddFailed:
                scannerView.alertItem = AlertContext.videoInputAddFailed
                
            case .canAddVideoOutputFailed:
                scannerView.alertItem = AlertContext.canAddVideoOutputFailed
                
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScanType
            }
        }
        
        func restartCaptureSession() {
            print("Restart scanner called from Coordinator")
            scannerView.restartScanner = true
        }
    }
}

#Preview {
    ScannerView(scannerCode: .constant(""), alertItem: .constant(AlertContext.invalidDeviceInput), restartScanner: .constant(true))
}
