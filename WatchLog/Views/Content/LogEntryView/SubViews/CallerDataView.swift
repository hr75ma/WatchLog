//
//  CallerView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 22.05.25.
//
import SwiftUI

struct CallerDataView: View {
    
    @Bindable var LogEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Image(systemName: appStyles.SectionCallerImage)
                .SectionImageStyle(appStyles)
            
            VStack(alignment: .leading, spacing: 5) {
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Telefon")
                        .SectionTextLabel(appStyles)
                    
                    TextField("", text: $LogEntry.CallerNumber)
                        .SectionTextFieldSingleLine(appStyles, isLocked: LogEntry.isLocked)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.numberPad)  // Show number pad
                        .checkOnNumbers(text: $LogEntry.CallerNumber)
                        .limitInputLength(text: $LogEntry.CallerNumber, length: 15)
                        .showClearButton($LogEntry.CallerNumber)
                        .disabled(LogEntry.isLocked)// Allow only numeric characters
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Name")
                        .SectionTextLabel(appStyles)
                    
                    TextField("", text: $LogEntry.CallerName)
                        .SectionTextFieldSingleLine(appStyles, isLocked: LogEntry.isLocked)
                        .textContentType(.name)
                        .autocorrectionDisabled(true)
                        .showClearButton($LogEntry.CallerName)
                        .disabled(LogEntry.isLocked)
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("DOB")
                        .SectionTextLabel(appStyles)
                    
                    DatePicker("", selection: $LogEntry.EntryTime, displayedComponents: [.date])
                        .labelsHidden() // Hides the default label
                        .colorMultiply(.blue)
                                    .font(.system(size: 23, weight: .bold))
                                    .frame(width: 250, height: 80)
                                    .clipped()
                        .datePickerStyle(WheelDatePickerStyle())
                    
                    TextField("", text: $LogEntry.CallerDOB)
                        .SectionTextFieldSingleLine(appStyles, isLocked: LogEntry.isLocked)
                        .textInputAutocapitalization(.characters)
                        .textContentType(.birthdate)
                        .showClearButton($LogEntry.CallerDOB)
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
                        .SectionTextLabel(appStyles)
                        .frame(alignment: .topLeading)
                    
                    TextField("", text: $LogEntry.CallerAdress, axis: .vertical)
                        .SectionTextFieldSingleLine(appStyles, isLocked: LogEntry.isLocked)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(4, reservesSpace: true)
                        .autocorrectionDisabled(true)
                        .showClearButton($LogEntry.CallerAdress)
                        .disabled(LogEntry.isLocked)
                    
                }
                
            }
            
        }
        //.border(.brown)
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
        .overlay(
          Rectangle()
            .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
            .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
          alignment: .bottom
        )
        
    }
}


