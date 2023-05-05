//
//  TimelineProvider.swift
//  StocksWidgetExtension
//
//  Created by Taher on 4/5/23.
//

import Foundation
import WidgetKit
import Intents
import Combine

class Provider: IntentTimelineProvider {
    var cancellable: Set<AnyCancellable> = []

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), stockData: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        createTimelineEntry(date: Date(), configuration: configuration, completion: completion)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        createTimeline(date: Date(), configuration: configuration, completion: completion)
    }


    private func createTimeline(date: Date, configuration: ConfigurationIntent, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        getStockData(for: configuration.symbol ?? "") { stockData in
            let entry = SimpleEntry(date: date, configuration: configuration, stockData: stockData)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }

    private func createTimelineEntry(date: Date, configuration: ConfigurationIntent, completion: @escaping (SimpleEntry) -> ()) {
        getStockData(for: configuration.symbol ?? "") { stockData in
            let entry = SimpleEntry(date: date, configuration: configuration, stockData: stockData)
            completion(entry)
        }
    }

    private func getStockData(for symbol: String, completion: @escaping (StockData) -> ()) {
        StockAPIService.getStockData(for: symbol)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    return
                }
            } receiveValue: { stockData in
                print("widget data:\n \(stockData)")
                DispatchQueue.main.async {
                    completion(stockData)
                }
            }
            .store(in: &cancellable)
    }
}
