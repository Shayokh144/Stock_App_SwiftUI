//
//  HomeViewModel.swift
//  LiveStockApp
//
//  Created by Taher on 25/4/23.
//

import Foundation
import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {

    private var cancelable = Set<AnyCancellable>()
    private let symbols: [String] = ["AAPL", "TSLA", "IBM"]

    @Published var stockDataList = [StockData]()

    init() {
        loadAllSymbols()
    }

    func loadAllSymbols() {
        stockDataList.removeAll()
        symbols.forEach { symbol in
            getStockData(for: symbol)
        }
    }

    func getStockData(for symbol: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&interval=5min&apikey=\(Constants.apKey)")!
        URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: StockData.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            } receiveValue: { [weak self] stockData in
                DispatchQueue.main.async { [weak self] in
                    self?.stockDataList.append(stockData)
                }
            }
            .store(in: &cancelable)
    }
}
