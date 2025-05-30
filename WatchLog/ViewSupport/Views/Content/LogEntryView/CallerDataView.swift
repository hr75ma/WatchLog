//
//  CallerView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI

struct CallerDataView: View {
    
    @Bindable var LogEntry: WatchLogEntry
    @EnvironmentObject var GeneralStyles: GeneralStylesLogEntry
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Image(systemName: GeneralStyles.SectionCallerImage)
                .SectionImageStyle(GeneralStyles)
            
            VStack(alignment: .leading, spacing: 5) {
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Telefon")
                        .SectionTextLabel(GeneralStyles)
                    
                    TextField("", text: $LogEntry.CallerNumber)
                        .SectionTextFieldSingleLine(GeneralStyles)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)  // Show number pad
                        .onChange(of: LogEntry.CallerNumber, initial: false) { old, value in
                            LogEntry.CallerNumber = value.filter { $0.isNumber }
                        }
                        .disabled(LogEntry.isLocked)// Allow only numeric characters
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Name")
                        .SectionTextLabel(GeneralStyles)
                    
                    TextField("", text: $LogEntry.CallerName)
                        .SectionTextFieldSingleLine(GeneralStyles)
                        .textContentType(.name)
                        .autocorrectionDisabled(true)
                        .disabled(LogEntry.isLocked)
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("DOB")
                        .SectionTextLabel(GeneralStyles)
                    
                    TextField("", text: $LogEntry.CallerDOB)
                        .SectionTextFieldSingleLine(GeneralStyles)
                        .textInputAutocapitalization(.characters)
                        .textContentType(.birthdate)
                        .disabled(LogEntry.isLocked)
                        .keyboardType(.numberPad)  // Show number pad
                        .onChange(of: LogEntry.CallerDOB, initial: false) { old, value in
                            let trimmedValue = value.trimingLeadingSpaces()
                            if trimmedValue.isNumber {
                                if trimmedValue.count == 8 {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "de_DE_POSIX")
                                    dateFormatter.dateFormat = "ddMMyyyy"
                                    if dateFormatter.date(from: trimmedValue) != nil {
                                        let date = dateFormatter.date(from: trimmedValue)!
                                        let formatDate = DateFormatter()
                                        formatDate.dateFormat = "dd.MM.yyyy"
                                        LogEntry.CallerDOB = formatDate.string(from: date)
                                    } else {
                                        LogEntry.CallerDOB = ""
                                    }
                                } else {
                                    if trimmedValue.count > 8 {
                                        LogEntry.CallerDOB = ""
                                    } else {
                                        LogEntry.CallerDOB = trimmedValue
                                    }
                                }
                            } else {
                                if trimmedValue.isDate {
                                    LogEntry.CallerDOB = trimmedValue
                                } else {
                                    LogEntry.CallerDOB = ""
                                }
                            }
                        }
                }
                
                HStack(alignment: .top, spacing: 0) {
                    Text("Adresse")
                        .SectionTextLabel(GeneralStyles)
                        .frame(alignment: .topLeading)
                    
                    TextField("", text: $LogEntry.CallerAdress, axis: .vertical)
                        .SectionTextFieldSingleLine(GeneralStyles)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(4, reservesSpace: true)
                        .autocorrectionDisabled(true)
                        .disabled(LogEntry.isLocked)
                    
                }
                
            }
            
        }
        //.border(.brown)
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
        .overlay(
          Rectangle()
            .frame(height: GeneralStyles.GeneralInnerFrameBorderWidth)  // Border thickness
            .foregroundColor(GeneralStyles.GeneralInnerFrameColor),  // Border color
          alignment: .bottom
        )
        
    }
}


