//
//  StockWidgetView.swift
//  StocksWidgetExtension
//
//  Created by Taher on 4/5/23.
//

import SwiftUI

// Actual view that will appear as a widget view
struct StocksWidgetEntryView : View {

    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            Text("Small Widget")
        case .systemMedium:
            WidgetView(entry: entry)
        default:
            Text("Default Widget")
        }

    }
}

struct WidgetView : View {

    var entry: Provider.Entry
    var body: some View {
        VStack {
            Text(entry.configuration.symbol ?? "No symbol given")
            Text(entry.stockData?.latestClose ?? "No value given")
            LineChart(values: entry.stockData?.closeValues ?? [])
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.green.opacity(0.7), .green.opacity(0.2),.green.opacity(0.0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 150.0, height: 50.0)
        }
    }
}
