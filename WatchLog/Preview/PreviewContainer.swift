//
//  PreviewContainer.swift
//  WatchLog
//
//  Created by Marcus Hörning on 19.05.25.
//

import Foundation
import SwiftData

struct PreviewData {
    
    func setPreviewDate(viewModel: LogEntryViewModel) {
        
        let currentDate:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        let entries = ["01.03.2023 06:10:10", "01.01.2024 06:10:10", "02.01.2024 16:10:10", "01.02.2024 04:10:10", "01.02.2024 15:10:10", "01.03.2024 18:10:10", "01.03.2024 13:10:10", "02.03.2024 11:10:10", "09.04.2024 06:10:10", "10.04.2024 03:10:10", "01.05.2024 14:10:10", "02.05.2024 19:10:10","01.01.2025 06:10:10", "02.01.2025 16:10:10", "01.02.2025 04:10:10", "01.02.2025 15:10:10", "01.03.2025 18:10:10", "01.03.2025 13:10:10", "02.03.2025 11:10:10", "09.04.2025 06:10:10", "10.04.2025 03:10:10", "01.05.2025 14:10:10", "02.05.2025 19:10:10" ]
        
        
        Task {
            
            for dat in entries {
                let entryObject = WatchLogEntry()
                entryObject.EntryTime = dateFormatter.date(from: dat)!
                entryObject.isLocked = true
                await viewModel.saveLogEntry(LogEntry: entryObject)
                
            }
        }
    }
}
