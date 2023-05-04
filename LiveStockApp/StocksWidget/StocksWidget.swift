//
//  StocksWidget.swift
//  StocksWidget
//
//  Created by Taher on 28/4/23.
//

import WidgetKit
import SwiftUI
import Intents

struct StocksWidget: Widget {
    let kind: String = "StocksWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            StocksWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("LiveStockApp Widget") // useful if you want to provide multiple widgets
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium]) // increase size of widget
    }
}

struct StocksWidget_Previews: PreviewProvider {
    static var previews: some View {
        StocksWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
