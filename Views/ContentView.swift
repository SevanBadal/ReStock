//
//  ContentView.swift
//  ReStock
//
//  Created by Sevan Golnazarian on 3/27/20.
//  Copyright © 2020 Sevan Golnazarian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    static let timeSeriesValues = [10, 30, 180, 365]
    
    @State var stockOne: String = ""
    @State var stockTwo: String = ""
    @State private var timeSeriesAmount = 0
    
    @ObservedObject var stockManager = StockManager()
    
    var body: some View {
        ZStack {
            VStack {
                Text("Sample Size")
                    .bold()
                    .padding(.top, 50)
                Picker(selection: $timeSeriesAmount, label: Text("Sample Size")) {
                    ForEach(0 ..< Self.timeSeriesValues.count) {
                        Text("\(Self.timeSeriesValues[$0]) Days")
                    }
                }.pickerStyle(SegmentedPickerStyle()).padding()
                CustomInputField(for: $stockOne, title: "Stock One")
                CustomInputField(for: $stockTwo, title: "Stock Two")
                
                Text("Covariance")
                Text("\(stockManager.covariance)")
                
                Spacer()
                
                Button(action: {
                    self.stockManager.fetchStockHistory(stockOne: self.stockOne, stockTwo: self.stockTwo, sampleSize: Self.timeSeriesValues[self.timeSeriesAmount])
                    // self.selection = 1
                }) {
                    Text("Submit")
                        .padding(.bottom, 50)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .light)
            
            ContentView()
                .environment(\.colorScheme, .dark)
        }
    }
}
