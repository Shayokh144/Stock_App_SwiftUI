//
//  StockAPIService.swift
//  LiveStockApp
//
//  Created by Taher on 4/5/23.
//

import Foundation
import Combine

struct StockAPIService {
    
    static func getStockData(for symbol: String) -> AnyPublisher<StockData, Error>{
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&interval=5min&apikey=\(Constants.apiKey)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: StockData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}