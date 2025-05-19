//
//  ContentView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 07.05.25.
//

import SwiftData
import SwiftUI





struct ContentView: View {

  @Environment(\.modelContext) private var modelContext

  @State private var columnVisibility =
    NavigationSplitViewVisibility.detailOnly

  @State private var test: Int = 0

  @State var StandardDate: Date = Date()

  @Query(sort: \WatchLogBookYear.LogDate, order: .forward) var ListYears: [WatchLogBookYear]

  var body: some View {

    NavigationSplitView(columnVisibility: $columnVisibility) {
      List {
        ForEach(ListYears) { years in
          DisclosureGroup(getDateYear(Year: years.LogDate)) {
            ForEach(sortedMonth(years.Children!)) { child in
              DisclosureGroup(getDateMonth(Month: child.LogDate)) {
                ForEach(sortedDay(child.Children!)) { child2 in
                  DisclosureGroup("\(child2.LogDate)") {
                    ForEach(sortedEntries(child2.Children!)) { child3 in
                      Text("\(child3.LogDate.formatted(date: .omitted, time: .standard))")

                    }
                  }
                  .disclosureGroupStyle(MyDisclosureStyle())
                }
              }
              .disclosureGroupStyle(MyDisclosureStyle())
            }
          }
          .disclosureGroupStyle(MyDisclosureStyle())

        }

      }
      .listStyle(.sidebar)
      .scrollContentBackground(.hidden)
      .background(Color.black.edgesIgnoringSafeArea(.all))

    } detail: {

      ContentViewTest()

        .containerRelativeFrame(
          [.horizontal, .vertical],
          alignment: .topLeading
        )
        .padding()
    }
  }

  //    ForEach(ListYears) { years in
  //
  //        DisclosureGroup(getDateYear(Year: years.LogDate)) {
  //            ForEach(years.Children!) { child in
  //                DisclosureGroup(getDateMonth(Month: child.LogDate)) {
  //                    ForEach(child.Children!) { child2 in
  //                        DisclosureGroup("\(child2.LogDate)") {
  //                            ForEach(child2.Children!) { child3 in
  //                                    Text("\(child3.LogDate.formatted(date: .omitted, time: .standard))")
  //
  //                            }
  //                        }
  //                        .disclosureGroupStyle(MyDisclosureStyle())
  //                    }
  //                }
  //                .disclosureGroupStyle(MyDisclosureStyle())
  //            }
  //        }
  //        .disclosureGroupStyle(MyDisclosureStyle())
  //
  //    }

  struct MyDisclosureStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
      VStack {
        Button {
          withAnimation {
            configuration.isExpanded.toggle()
          }
        } label: {
          HStack(alignment: .firstTextBaseline) {
            configuration.label
              .font(Font.custom(LabelFont, size: 40))
            Spacer()
            Text(configuration.isExpanded ? "hide" : "show")
              .foregroundColor(.accentColor)
              .animation(nil, value: configuration.isExpanded)
              .font(Font.custom(LabelFont, size: 20))
          }
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        if configuration.isExpanded {
          configuration.content
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(width: .infinity, alignment: .leading)
            .background(Color.red.edgesIgnoringSafeArea(.all))
            .foregroundStyle(.blue)
            .font(Font.custom(LabelFont, size: 40))
            .border(Color.green, width: 1)

        }
      }
    }
  }
    
    private func sortedEntries(_ LogEntry: [WatchLogBookEntry]) -> [WatchLogBookEntry] {
        return LogEntry.sorted(using: [
            SortDescriptor(\.LogDate, order: .forward)
            ])
        
        }
    
    private func sortedDay(_ LogEntry: [WatchLogBookDay]) -> [WatchLogBookDay] {
        return LogEntry.sorted(using: [
            SortDescriptor(\.LogDate, order: .forward)
            ])
        
        }
    
    private func sortedMonth(_ LogEntry: [WatchLogBookMonth]) -> [WatchLogBookMonth] {
        return LogEntry.sorted(using: [
            SortDescriptor(\.LogDate, order: .forward)
            ])
        
        }

  fileprivate func getDateMonth(Month: Int) -> String {
    var DateComponent = DateComponents()
    DateComponent.year = 1975
    DateComponent.month = Month
    DateComponent.day = 2
    DateComponent.hour = 1
    DateComponent.minute = 0
    DateComponent.second = 0

    let date = Calendar.current.date(from: DateComponent)!
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    return date.formatted(.dateTime.month(.wide))
  }

  fileprivate func getDateYear(Year: Int) -> String {
    var DateComponent = DateComponents()
    DateComponent.year = Year
    DateComponent.month = 8
    DateComponent.day = 2
    DateComponent.hour = 1
    DateComponent.minute = 0
    DateComponent.second = 0

    let date = Calendar.current.date(from: DateComponent)!
    return String(Calendar.current.component(.year, from: date))
  }

}

#Preview {
  let previewData = PreviewData()
    previewData.addExampleData()
  return ContentView()
    .modelContainer(previewData.modelContainer)

}
