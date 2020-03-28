//
//  StockManager.swift
//  ReStock
//
//  Created by Sevan Golnazarian on 3/27/20.
//  Copyright © 2020 Sevan Golnazarian. All rights reserved.
//

import Foundation

protocol StockManagerDelegate {
    func didUpdateStocks(_ stockManager: StockManager, stock: StockData)
    func didFailWithError(error: Error)
}

class StockManager: ObservableObject {
    
    @Published var covariance: Double = 0.0
    @Published var showCovariance: Bool = false
    
    
    let baseURL =  "https://financialmodelingprep.com/api/v3/historical-price-full/"
    let timeSeries = "?timeseries="
    
    var delegate: StockManagerDelegate?
    
    func fetchStockHistory(stockOne: String, stockTwo: String, sampleSize: Int) {
        let urlString = "\(baseURL)\(stockOne),\(stockTwo)\(timeSeries)\(sampleSize)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data, res, e) in
                if e != nil {
                    return
                }
                if let safeData = data {
                    if let stockInfo = self.parseJSON(safeData) {
//                        let mock1Data = [1.1,1.7,2.1,1.4,0.2]
//                        let mock2Data = [3.0,4.2,4.9,4.1,2.5]
//                        let mock1 = StockModel(symbol: "s", historicalData: mock1Data)
//                        let mock2 = StockModel(symbol: "zm", historicalData: mock2Data)
//                        let stockOneAvgReturns = self.returnDifference(stock: mock1)
//                        let stockTwoAvgReturns = self.returnDifference(stock: mock2)
                        let stockOneAvgReturns = self.returnDifference(stock: stockInfo.0)
                        let stockTwoAvgReturns = self.returnDifference(stock: stockInfo.1)
                        let productSum = zip(stockOneAvgReturns, stockTwoAvgReturns).map{ $0 * $1 }.reduce(0){$0 + $1}
                        let covarianceResult = productSum / (Double(stockOneAvgReturns.count) - 1)
                        print(covarianceResult)
                        DispatchQueue.main.async {
                            self.showCovariance = true
                            self.covariance = covarianceResult
                        }
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ stockData: Data) -> (StockModel, StockModel)? {
        let decoder = JSONDecoder()
        do {
            let requestObject = try decoder.decode(RequestObject.self, from: stockData)
            if requestObject.historicalStockList.count == 2 {
                let stockOneSymbol = requestObject.historicalStockList[0].symbol
                let stockOneDetails: [Double] = requestObject.historicalStockList[0].historical.map{$0.changePercent}
                let stockTwoSymbol = requestObject.historicalStockList[1].symbol
                let stockTwoDetails: [Double] = requestObject.historicalStockList[1].historical.map{$0.changePercent}
                let stockOne = StockModel(symbol: stockOneSymbol, historicalData: stockOneDetails)
                let stockTwo = StockModel(symbol: stockTwoSymbol, historicalData: stockTwoDetails)
                return (stockOne, stockTwo)
            }
            return nil
        } catch {
            print(error)
            //  delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func returnDifference(stock: StockModel) -> [Double] {
        let stock_data = stock
        let sum_of_returns = stock_data.historicalData.reduce(0){ $0 + $1 }
        let average_return = sum_of_returns / Double(stock_data.historicalData.count)
        let return_diff: [Double] = stock_data.historicalData.map { $0 - average_return }
        
        return return_diff
    }
}

