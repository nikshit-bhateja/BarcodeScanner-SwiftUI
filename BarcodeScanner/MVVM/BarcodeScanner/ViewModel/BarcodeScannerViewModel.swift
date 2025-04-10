//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Nikk Bhateja on 07/04/25.
//

import SwiftUI

final class BarcodeScannerViewModel: ObservableObject {
    @Published var barcode: String = ""
    @Published var alertItem: AlertItem?
    @Published var restartScanner: Bool = false
    
    // computed properties
    var statusText: String {
        barcode.isEmpty ? "Not Scanned Yet" : barcode
    }
    
    var statucTextColor: Color {
        barcode.isEmpty ? .red : .green
    }
    
    var wiggleIconEffect: Bool {
        !(barcode.isEmpty)
    }
   
}
