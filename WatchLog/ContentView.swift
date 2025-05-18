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

  @Query(sort: \WatchLogBookYear.LogDate, order: .forward) var ListYears: [WatchLogBookYear]

  var body: some View {

    NavigationSplitView(columnVisibility: $columnVisibility) {
      List {

        ForEach(ListYears) { years in
          Section(header: Text("\(years.LogDate)")) {
              ForEach(years.Children!) { child in
                  Text("\(child.LogDate)")
                   ForEach(child.Children!) { child2 in
                      Text("\(child2.LogDate)")
                        ForEach(child2.Children!) { child3 in
                           Text("\(child3.LogDate)")
                       }
                  }
                  
                  
              }
          }

        }
      }
      .listStyle(.plain)

    } detail: {

      ContentViewTest()

        .containerRelativeFrame(
          [.horizontal, .vertical],
          alignment: .topLeading
        )
        .padding()
    }
  }

}
