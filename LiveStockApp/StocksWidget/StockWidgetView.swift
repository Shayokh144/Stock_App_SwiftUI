//
//  StockWidgetView.swift
//  StocksWidgetExtension
//
//  Created by Taher on 4/5/23.
//

import SwiftUI

// Actual view that will appear as a widget view
struct StocksWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.date, style: .time)
            Text(entry.configuration.symbol ?? "No symbol given")
        }
    }
}
