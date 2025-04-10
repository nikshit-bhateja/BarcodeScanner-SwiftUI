//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Nikk Bhateja on 30/03/25.
//

import SwiftUI

struct BarcodeScannerView: View {
    
    @StateObject var viewModel = BarcodeScannerViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                ScannerView(scannerCode: $viewModel.barcode, alertItem: $viewModel.alertItem, restartScanner: $viewModel.restartScanner)
                    .frame(maxWidth: .infinity,
                           maxHeight: 300)
                
                HStack{
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .symbolEffect(.rotate, value: viewModel.wiggleIconEffect)
                        .frame(width: 25, height: 25)
                    
                    Text("Barcode Scanner")
                        .font(.title)
                        .fontWeight(.medium)
                        .padding(.leading, 10)
                }
                .padding(.vertical, 25)
                
                Text(viewModel.statusText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(viewModel.statucTextColor)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 30)
                
                Button {
                    viewModel.restartScanner = true
                    viewModel.barcode = ""
                } label: {
                    Text("Restart Scanner")
                        .bold()
                        .font(.headline)
                        .frame(width: 200)
                        .padding(10)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .shadow(color: Color(.label).opacity(0.2),
                                radius: 5,
                                x: 0,
                                y: 3)
                        
                }
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: alertItem.dismissButton)
            }
        }
    }
}

#Preview {
    BarcodeScannerView()
}
