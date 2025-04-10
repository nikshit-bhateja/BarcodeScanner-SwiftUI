//
//  ScannerVC.swift
//  BarcodeScanner
//
//  Created by Nikk Bhateja on 05/04/25.
//

import UIKit
import AVFoundation

final class ScannerVC: UIViewController {
    
    //MARK: Properties
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate?
    
    //MARK: Initializer
    init(scannerDelegate: ScannerVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else{
            scannerDelegate?.didSurface(error: .invalidDeviceType)
            return
        }
        
        previewLayer.frame = view.layer.bounds
    }
    
    
    //MARK: Custom Methods
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            // also pass error from here later
            scannerDelegate?.didSurface(error: .invalidDeviceType)
            return
        }
        var videoInput : AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch{
            scannerDelegate?.didSurface(error: .invalidVideoInput)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }else{
            scannerDelegate?.didSurface(error: .videoInputAddFailed)
            return
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13, .qr, .microQR]
        } else {
            scannerDelegate?.didSurface(error: .canAddVideoOutputFailed)
        }
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        DispatchQueue.global(qos: .background).async{
            self.captureSession.startRunning()
        }
    }
    
    private func restartCaptureSession() {

        captureSession.stopRunning()

        let dispatchGroup = DispatchGroup()

        for input in captureSession.inputs {
            dispatchGroup.enter()
            DispatchQueue.main.async {
                self.captureSession.removeInput(input)
                dispatchGroup.leave()
            }
        }

        for output in captureSession.outputs {
            dispatchGroup.enter()
            DispatchQueue.main.async {
                self.captureSession.removeOutput(output)
                dispatchGroup.leave()
            }
        }

        DispatchQueue.main.async {
            self.previewLayer?.removeFromSuperlayer()
            self.previewLayer = nil
        }

        dispatchGroup.notify(queue: .main) {
            self.setupCaptureSession()
        }
    }

}

extension ScannerVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            return
        }
        
        guard let machineReadableCodeObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let barcodeString = machineReadableCodeObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        captureSession.stopRunning()
        scannerDelegate?.didFind(barcode: barcodeString)
    }
    
}


extension ScannerVC {
    func restartScanner() {
        restartCaptureSession()
    }
}
