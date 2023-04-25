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

    private var cancelable = Set<AnyCancellable>();

    func getStockData(for symbol: String) {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&interval=5min&apikey=\(Constants.apKey)")!
    }
}
