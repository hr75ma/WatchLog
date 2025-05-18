//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//

import SwiftData
import SwiftUI

#Preview{
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}



struct ContentView: View {

  @Environment(\.modelContext) private var modelContext

  @State private var columnVisibility =
    NavigationSplitViewVisibility.detailOnly
    
    @State private var test: Int = 0
    
    @State var StandardDate:Date = Date()
    
    

  @Query(sort: \WatchLogBookYear.LogDate, order: .forward) var ListYears: [WatchLogBookYear]

  var body: some View {

    NavigationSplitView(columnVisibility: $columnVisibility) {
      List {

        ForEach(ListYears) { years in
            
            DisclosureGroup("\(years.LogDate)") {
                ForEach(years.Children!) { child in
                    DisclosureGroup(getDate(Month: child.LogDate)) {
                        ForEach(child.Children!) { child2 in
                            DisclosureGroup("\(child2.LogDate)") {
                                ForEach(child2.Children!) { child3 in
                                    Text("\(child3.LogDate.formatted(date: .omitted, time: .standard))")
                                }
                            }
                        }
                    }
                }
            }
            .foregroundStyle(.blue)
            .font(Font.custom(LabelFont, size: LabelFontHeight))
        }
      }
      .listStyle(.sidebar)
      .headerProminence(.increased)

    } detail: {

      ContentViewTest()

        .containerRelativeFrame(
          [.horizontal, .vertical],
          alignment: .topLeading
        )
        .padding()
    }
  }
    
    fileprivate func getDate(Month: Int) -> String {
        var DateComponent = DateComponents()
        DateComponent.year = 1975
        DateComponent.month = Month
        DateComponent.year = 2
        DateComponent.hour = 1
        DateComponent.minute = 0
        DateComponent.second = 0
        
        
        let date = Calendar.current.date(from: DateComponent)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        //return dateFormatter.string(from: Date())
        return date.formatted(.dateTime.weekday(.wide))
    }

}
