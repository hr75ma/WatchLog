//
//  ScrollViewDispatcher.swift
//  WatchLog
//
//  Created by Marcus Hörning on 12.07.25.
//

import SwiftUI



struct ScrollViewDispatcher: View {
    @Binding public var logEntryUUIDContainer: LogEntryUUIDContainer

    @EnvironmentObject var viewModel: LogEntryViewModel
    @Environment(DisplayedLogEntryID.self) var displayedLogEntryUUID
    @Environment(\.appStyles) var appStyles
    @Environment(BlurSetting.self) var blurSetting

    @State private var logEntryUUID: UUID = UUID()

    @State var alertDelete = false
    @State var alertNew = false
    @State var alertClear = false

    @State var numberOfEntry: Int = 0

    @State private var showSheet: Bool = false
    @State private var isActive = true
    @State private var watchLogEntry: WatchLogEntry = .init()

    @State private var watchLogBookEntry: WatchLogBookEntry = .init()
    @State private var watchLogBookDay: WatchLogBookDay = .init()

    @State private var refreshID: UUID = UUID()

    @State private var scrollPos: UUID?
    
   let rotation: Angle = .degrees(25)

    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center, spacing: 0) {
                if logEntryUUIDContainer.logEntryBookDay.watchLogBookEntries!.isEmpty {
                    VStack(alignment: .center, spacing: 0) {
                        Image(.placeholder)
                            .resizable()
                            .scaledToFit()
                            .padding(0)
                        Spacer()
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                } else {
                    ForEach(logEntryUUIDContainer.logEntryBookDay.logEntriesSorted.indices, id: \.self) { index in
                        LogBookEntryShowWrapperView(logBookEntryUUID: $logEntryUUIDContainer.logEntryBookDay.logEntriesSorted[index].uuid)
                            .id(logEntryUUIDContainer.logEntryBookDay.logEntriesSorted[index].uuid)
                            .onScrollVisibilityChange(threshold: 0.5) { scrolled in
                                if scrolled {
                                    print("index \(index) - \(logEntryUUIDContainer.logEntryBookDay.logEntriesSorted[index].uuid.uuidString)")
                                    logEntryUUID = logEntryUUIDContainer.logEntryBookDay.logEntriesSorted[index].uuid
                                    numberOfEntry = index + 1
                                }
                            }
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
//                            .visualEffect { content, proxy in
//                              
//                               content
//                                    .rotation3DEffect(
//                                        .init(degrees: rotation(for: proxy)),
//                                        axis: (x: 0, y: 1, z: 0),
//                                        anchor: .center )
//                            }

                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.2)
                                        .scaleEffect(x: 1, y: phase.isIdentity ? 1.0 : 0.9)
                                }
//                            .visualEffect { content, proxy in
//                                let frame = proxy.frame(in: .scrollView)
//                                let scrollViewWidth = proxy.bounds(of: .scrollView)?.width ?? 100                                // the center X of the screen
//                                let centerXScreen = scrollViewWidth / 2
////
////                                // the distance from the center of the screen to the center of the frame
//                                let distanceX = abs(centerXScreen - frame.midX)
////
////                                // the scale factor
//                                let scale = 1.0 - (distanceX / centerXScreen) / 10
//                                let op = 1.0 - (distanceX / centerXScreen)
//                                let distanceFromCenter = abs(distanceX / 2 - frame.midX)
//                               // print(scale)
//                                return content
//                                    .rotation3DEffect(.degrees(-proxy.frame(in: .scrollView).minX) / 40, axis: (x: 0, y: 1, z: 0))
////                                    .scaleEffect(scale)
////                                    //.blur(radius: distanceFromCenter/100)
//                            }
                    }
                    .id(refreshID)
                }
            }
            .scrollTargetLayout()
        }
        .safeAreaInsetForToolbar()
        .scrollPosition(id: $scrollPos, anchor: .top)
        .scrollTargetBehavior(.viewAligned)
        .onTapGesture {
            if numberOfEntry > 0 {
                showSheet = true
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .onAppear {
            Task { @MainActor in
                print("onappear scroll\(logEntryUUIDContainer.logEntryUUID)")
                withAnimation {
                    print("onappear \(logEntryUUIDContainer.logEntryUUID)")
                    Task {
                        let logBookDay = await viewModel.fetchLogBookDay(from: .now)
                        if logBookDay != nil && !logBookDay!.watchLogBookEntries!.isEmpty {
                            logEntryUUIDContainer = .init(logEntryUUID: logBookDay!.logEntriesSorted.last!.uuid, logBookDay: logBookDay!)
                        }
                    }
                    scrollPos = logEntryUUIDContainer.logEntryUUID
                }
            }
        }
        .onChange(of: logEntryUUID) { // fürs scrolling
            Task { @MainActor in
                print("displayedLogEntryUUID: \(displayedLogEntryUUID.id.uuidString)")
                print("gelieferte entryUUID: \(logEntryUUIDContainer.logEntryUUID.uuidString)")
                displayedLogEntryUUID.id = logEntryUUID
                logEntryUUIDContainer.logEntryUUID = logEntryUUID
            }
        }
        .onChange(of: logEntryUUIDContainer.logEntryBookDay.watchLogBookEntries) { _, newValue in
            if newValue!.count == 0 {
                Task {
                    let logBookDay = await viewModel.fetchLogBookDay(from: .now)
                    if logBookDay != nil && !logBookDay!.watchLogBookEntries!.isEmpty {
                        logEntryUUIDContainer = .init(logEntryUUID: logBookDay!.logEntriesSorted.last!.uuid, logBookDay: logBookDay!)
                        scrollPos = logEntryUUIDContainer.logEntryUUID
                    }
                }
            }
        }

        .onChange(of: logEntryUUIDContainer) { oldValue, newValue in
            Task { @MainActor in
                print("gelieferte entryUUID: \(newValue.logEntryUUID.uuidString)")
                if oldValue.logEntryBookDay.uuid != newValue.logEntryBookDay.uuid {
                    logEntryUUID = newValue.logEntryUUID
                    print("onChange new Day: \(newValue.logEntryUUID)")
                    withAnimation {
                        scrollPos = logEntryUUIDContainer.logEntryUUID
                    }
                } else {
                    print("onChange same Day: \(newValue.logEntryUUID)")
                    withAnimation {
                        scrollPos = logEntryUUIDContainer.logEntryUUID
                    }
                }
                if newValue.logEntryBookDay.watchLogBookEntries!.isEmpty {
                    numberOfEntry = 0
                }
            }
        }
        .onChange(of: showSheet) { _, newValue in
            if newValue == false {
                Task {
                    print("back from editing")
                    refreshID = UUID()
                }
            }
        }
        .fullScreenCover(isPresented: $showSheet) {
            NavigationStack {
                LogBookEntryEditWrapperView(logBookEntryUUID: $logEntryUUIDContainer.logEntryUUID)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Eintrag \(numberOfEntry) von \(logEntryUUIDContainer.logEntryBookDay.watchLogBookEntries!.count)")
                    .navigationTitleModifier()
                    .isHidden(numberOfEntry == 0, remove: true)
            }

            ToolbarItemGroup(placement: .primaryAction) {
                MenuButton
                    .isHidden(numberOfEntry == 0, remove: true)
            }
        }
        .toolbarModifier()
    }
}

extension ScrollViewDispatcher {
    

    
    nonisolated private func rotation(for proxy: GeometryProxy) -> CGFloat {
        let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
        let progresss = midX / scrollViewWidth
        let fixProgress = max(min(progresss, 1), 0)
        
        let degree = fixProgress * (rotation.degrees * 2)
        
        return Double(rotation.degrees - degree)
    }
    
    
    func opacityAmount(for proxy: GeometryProxy) -> Double {
        let scrollViewWidth = proxy.bounds(of: .scrollView)?.width ?? 100
        let ourCenter = proxy.frame(in: .scrollView).midX
        let distanceFromCenter = abs(scrollViewWidth / 2 - ourCenter)
        return Double(distanceFromCenter) / 100
    }

    var MenuButton: some View {
        Menu {
            if numberOfEntry > 0 {
                Button {
                    showSheet = true
                    blurSetting.isBlur = false
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.edit)
                }

                Divider()

                Button(role: .destructive) {
                    blurSetting.isBlur = true
                    alertDelete.toggle()
                } label: {
                    NavigationMenuLabelView(menuItemType: MenuType.delete)
                }
            }
        } label: {
            NavigationToolbarItemImage(toolbarItemType: .menu, appStyles: appStyles)
        }
        .alert("Log Löschen?", isPresented: $alertDelete) {
            Button(
                "Löschen", role: .destructive,
                action: {
                    Task {
                        if await viewModel.isDeletedEntryInDisplayedDay(logEntryUUID: displayedLogEntryUUID.id, logEntryDayUUI: logEntryUUIDContainer.logEntryBookDay.uuid) {
                            logEntryUUIDContainer = await viewModel.calculateShownAndDeleteLogEntry(logEntryUUID: logEntryUUID, logEntryDayUUI: logEntryUUIDContainer.logEntryBookDay.uuid)
                        } else {
                            await viewModel.deleteLogEntry(logEntryUUID: logEntryUUID)
                        }
                        blurSetting.isBlur = false
                    }

                })
            cancelAlertButton()
        }
    }

    private func newEntry() {
        Task {
            blurSetting.isBlur = false
//            let logBookDay = await viewModel.fetchLogBookDayOrEmptyDay(from: .now)
//            let watchLogBookEntry = WatchLogBookEntry()
//            logBookDay!.addLogEntry(watchLogBookEntry)
//            logEntryUUIDContainer = .init(logEntryUUID: watchLogBookEntry.uuid, logBookDay: logBookDay!)

            // displayedLogEntryUUID.id = logEntryUUIDContainer.logEntryUUID
        }
    }

    fileprivate func cancelAlertButton() -> Button<Text> {
        return Button(
            "Abbrechen", role: .cancel,
            action: {
                blurSetting.isBlur = false
            })
    }
}
