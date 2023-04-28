//
//  HomeViewModel.swift
//  LiveStockApp
//
//  Created by Taher on 25/4/23.
//

import Foundation
import SwiftUI
import Combine
import CoreData

final class HomeViewModel: ObservableObject {

    private var cancelable = Set<AnyCancellable>()
    private let coreDataContext = PersistenceController.shared.container.viewContext

    @Published var stockDataList = [StockData]()
    @Published var symbol = ""
    @Published var isValidSymbol = false
    @Published var stockEntities = [StockEntity]()

    init() {
        coreDataContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        loadFromCoreData()
        loadAllSymbols()
        validateSymbolField()
    }

    func loadFromCoreData() {
        do {
            stockEntities = try coreDataContext.fetch(StockEntity.fetchRequest())
        } catch {
            print(error)
        }
    }

    func validateSymbolField() {
        $symbol
            .sink { [weak self] newValue in
                self?.isValidSymbol = !newValue.isEmpty
            }
            .store(in: &cancelable)
    }

    func addStock() {
        let newStock = StockEntity(context: coreDataContext)
        newStock.symbol = symbol
        do {
            try coreDataContext.save()
        } catch {
            print(error)
        }
        stockEntities.append(newStock)
        getStockData(for: symbol)
        symbol = ""
    }

    func deleteStock(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }

        stockDataList.remove(at: index)

        let stockToRemove = stockEntities.remove(at: index)
        coreDataContext.delete(stockToRemove)
        do {
            try coreDataContext.save()
        } catch {
            print(error)
        }
    }

    func loadAllSymbols() {
        stockDataList.removeAll()
        stockEntities.forEach { stockEntity in
            getStockData(for: stockEntity.symbol ??  "")
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
