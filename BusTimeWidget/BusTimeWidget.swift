//
//  BusTimeWidget.swift
//  BusTimeWidget
//
//  Created by Matteo Cutroni on 21/11/24.
//

import WidgetKit
import SwiftUI

import Foundation
import SwiftProtobuf

func parsePBFile(url: URL) -> TransitRealtime_FeedMessage? {
    do {
        let data = try Data(contentsOf: url)
        let feedMessage = try TransitRealtime_FeedMessage(serializedBytes: data)
        return feedMessage
    } catch {
        print("Error parsing .pb file: \(error)")
        return nil
    }
}

func findNextArrival(feed: TransitRealtime_FeedMessage, stopID: String) -> String {
    for entity in feed.entity {
        let tripUpdate = entity.tripUpdate
        
        for stopTimeUpdate in tripUpdate.stopTimeUpdate {
            print("Stop Name: \(stopTimeUpdate.stopID)")
            if stopTimeUpdate.stopID == stopID {
                let arrivalTime = stopTimeUpdate.arrival.time
                    let date = Date(timeIntervalSince1970: TimeInterval(arrivalTime))
                    let formatter = DateFormatter()
                    formatter.timeStyle = .short
                    return formatter.string(from: date)
            }
        }
    }
    return "No upcoming arrivals"
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), stopName: "Placeholder Stop", nextBusArrival: "N/A")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), stopName: "Snapshot Stop", nextBusArrival: "N/A")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        if let pbFileURL = Bundle.main.url(forResource: "rome_trip_updates", withExtension: "pb"){
            
            if let feed = parsePBFile(url: pbFileURL) {
                let stopID_85_versoArco = "70395"
                let nextArrival_85_versoArco = findNextArrival(feed: feed, stopID: stopID_85_versoArco)
                
                let entry = SimpleEntry(date: Date(), stopName: "85 verso Arco", nextBusArrival: nextArrival_85_versoArco)
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            } else {
                // Fallback entry in case of error
                let entry = SimpleEntry(date: Date(), stopName: "Main St. Stop", nextBusArrival: "N/A")
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        } else {
            print("Couldn't find the pb file")
        }
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let stopName: String
    let nextBusArrival: String
}


struct BusTimeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Stop: \(entry.stopName)")
                .font(.headline)
            Text("Next Bus: \(entry.nextBusArrival)")
                .font(.body)
        }
        .padding()
    }
}



struct BusTimeWidget: Widget {
    let kind: String = "BusTimeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BusTimeWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BusTimeWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    BusTimeWidget()
} timeline: {
    SimpleEntry(date: .now, stopName: "String", nextBusArrival: "String")
    SimpleEntry(date: .now, stopName: "casa", nextBusArrival: "pipo")
}
