//
//  Stock.swift
//  ReStock
//
//  Created by Sevan Golnazarian on 3/27/20.
//  Copyright © 2020 Sevan Golnazarian. All rights reserved.
//

import Foundation


struct RequestObject: Decodable {
    let historicalStockList: [StockData]
}

struct StockData: Decodable {
    let symbol: String
    let historical: [HistoricalStockDetails]
}

struct HistoricalStockDetails: Decodable {
    let changePercent: Double
}
