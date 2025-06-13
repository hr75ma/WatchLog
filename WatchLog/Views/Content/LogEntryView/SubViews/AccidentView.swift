////
////  AccidentView.swift
////  WatchLog
////
////  Created by Marcus Hörning on 22.05.25.
////
//import SwiftUI
//
//struct AccidentSelectionView: View {
//  @Bindable var LogEntry: WatchLogEntry
//  @Environment(\.appStyles) var appStyles
//
//  @State private var isAccidentHidden: Bool = true
//
//  var body: some View {
//    HStack(alignment: .top, spacing: 0) {
//      Image(systemName: appStyles.SectionAccidentImage)
//        .SectionImageStyle(appStyles)
//
//      VStack(alignment: .leading, spacing: 5) {
//
//        HStack(alignment: .center, spacing: 0) {
//
//          Text("Verkehrsunfall")
//            .SectionTextLabelForToggle(appStyles)
//
//          Toggle("", isOn: $LogEntry.isAccient)
//            .labelsHidden()
//            .toggleStyle(
//              ToggleStyleImage(
//                isOnImage: appStyles.AccidentImageisLocked,
//                isOffImage: appStyles.AccidentImageisUnLocked,
//                isOnColorPrimary: appStyles.AccidentColorIsLockedPrimary,
//                isOnColorSecondary: appStyles.AccidentColorIsLockedSecondary,
//                isOffColorPrimary: appStyles.AccidentColorIsUnLockedPrimary,
//                isOffColorSecondary: appStyles.AccidentColorIsUnLockedSecondary,
//                isLocked: LogEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
//              )
//            )
//            .frame(height: appStyles.LabelFontSize2, alignment: .center)
//            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//            .disabled(LogEntry.isLocked)
//          Spacer()
//
//        }
//        .onAppear {
//          withAnimation {
//            print("animation onappear")
//            isAccidentHidden = LogEntry.isAccient
//          }
//        }
//        .onChange(of: LogEntry.isAccient) { oldValue, newValue in
//          withAnimation {
//            print("animation onchange")
//            isAccidentHidden = newValue
//              if newValue {
//                  //LogEntry.processTypeShort = ProcessTypeShort.VU
//              } else {
//                  //LogEntry.processTypeShort = ProcessTypeShort.UNKNOWN
//              }
//          }
//        }
//        .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 10))
//
//          if isAccidentHidden {
//              VStack(alignment: .leading, spacing: 5) {
//                  HStack(alignment: .center, spacing: 0) {
//                      Text("Kennzeichen ON01")
//                          .SectionTextLabelSecond(appStyles)
//                          .frame(width: 215, height: appStyles.TextFieldHeight2, alignment: .topLeading)
//                      
//                      TextField("", text: $LogEntry.AccientLicensePlate01)
//                          .SectionTextFieldSingleLineSecond(appStyles, isLocked: LogEntry.isLocked)
//                          .limitInputLength(text: $LogEntry.AccientLicensePlate01, length: 10)
//                          .showClearButton($LogEntry.AccientLicensePlate01)
//                          .disabled(LogEntry.isLocked)
//                      
//                  }
//                  //.transition(.opacity)
//                  //.animation(.easeInOut(duration: 1), value: isAccientHidden)
//                  //.isHidden(!LogEntry.isAccient, remove: true)
//                  
//                  
//                  HStack(alignment: .center, spacing: 0) {
//                      Text("Kennzeichen ON02")
//                          .SectionTextLabelSecond(appStyles)
//                          .frame(width: 215, height: appStyles.TextFieldHeight2, alignment: .topLeading)
//                      
//                      TextField("", text: $LogEntry.AccientLicensePlate02)
//                          .SectionTextFieldSingleLineSecond(appStyles, isLocked: LogEntry.isLocked)
//                          .limitInputLength(text: $LogEntry.AccientLicensePlate02, length: 10)
//                          .showClearButton($LogEntry.AccientLicensePlate02)
//                          .disabled(LogEntry.isLocked)
//                      
//                  }
//                  .isHidden(!LogEntry.isAccient, remove: true)
//                  Spacer()
//                  
//                  HStack(alignment: .center, spacing: 0) {
//                      Text("Verletzte")
//                          .SectionTextLabelSecond(appStyles)
//                          .fixedSize(horizontal: true, vertical: true)
//                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
//                      
//                      Toggle("", isOn: $LogEntry.AccientInjured)
//                          .labelsHidden()
//                          .toggleStyle(
//                            ToggleStyleImage(
//                                isOnImage: appStyles.AccidentImageisLocked,
//                                isOffImage: appStyles.AccidentImageisUnLocked,
//                                isOnColorPrimary: appStyles.AccidentColorIsLockedPrimary,
//                                isOnColorSecondary: appStyles.AccidentColorIsLockedSecondary,
//                                isOffColorPrimary: appStyles.AccidentColorIsUnLockedPrimary,
//                                isOffColorSecondary: appStyles.AccidentColorIsUnLockedSecondary,
//                                isLocked: LogEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
//                            )
//                          )
//                          .frame(height: appStyles.TextFieldHeight2, alignment: .center)
//                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                          .disabled(LogEntry.isLocked)
//                      
//                      Spacer()
//                      
//                      Text("Verkehrsunfallflucht")
//                          .SectionTextLabelSecond(appStyles)
//                          .fixedSize(horizontal: true, vertical: true)
//                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
//                      
//                      Toggle("", isOn: $LogEntry.AccientHitAndRun)
//                          .labelsHidden()
//                          .toggleStyle(
//                            ToggleStyleImage(
//                                isOnImage: appStyles.AccidentImageisLocked,
//                                isOffImage: appStyles.AccidentImageisUnLocked,
//                                isOnColorPrimary: appStyles.AccidentColorIsLockedPrimary,
//                                isOnColorSecondary: appStyles.AccidentColorIsLockedSecondary,
//                                isOffColorPrimary: appStyles.AccidentColorIsUnLockedPrimary,
//                                isOffColorSecondary: appStyles.AccidentColorIsUnLockedSecondary,
//                                isLocked: LogEntry.isLocked, isLockedColor: appStyles.ToogleIsLockedColor
//                            )
//                          )
//                          .frame(height: appStyles.TextFieldHeight2, alignment: .center)
//                          .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                          .disabled(LogEntry.isLocked)
//                  }
//                  
//                  //        .isHidden(!LogEntry.isAccient, remove: true)
//              }
//              .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//              //.transition(.scale.animation(.easeInOut(duration: 3)))
//              .animation(.easeInOut(duration: 0.1), value: isAccidentHidden)
//              
//          }
//              
//      }
//
//    }
//
//    //.border(.brown)
//    .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
//    .overlay(
//      Rectangle()
//        .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
//        .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
//      alignment: .bottom
//    )
//  }
//}
//
////extension Text {
////
////  fileprivate func SectionTextLabelSecond(_ appStyles: StylesLogEntry) -> some View {
////    self
////      .font(Font.custom(appStyles.LabelFont, size: appStyles.TextFieldHeight2))
////      .foregroundStyle(appStyles.GeneralTextColor)
////      .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
////      .multilineTextAlignment(.leading)
////      .lineLimit(1)
////      .fixedSize(horizontal: false, vertical: true)
////
////  }
////
////}
////
////extension TextField {
////
////  fileprivate func SectionTextFieldSingleLineSecond(_ appStyles: StylesLogEntry)
////    -> some View
////  {
////    self
////      .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldHeight2))
////      .textInputAutocapitalization(.characters)
////      .lineLimit(1)
////      .foregroundStyle(appStyles.GeneralTextColor)
////      .background(appStyles.TextfieldBackgroundColor)
////      .fixedSize(horizontal: false, vertical: true)
////      .textContentType(.telephoneNumber)
////  }
////
////  fileprivate func SectionTextFieldSingleLineSecond(
////    _ appStyles: StylesLogEntry, isLocked: Bool
////  )
////    -> some View
////  {
////    self
////      .font(Font.custom(appStyles.TextFieldFont, size: appStyles.TextFieldHeight2))
////      .textInputAutocapitalization(.characters)
////      .lineLimit(1)
////      .foregroundStyle(appStyles.GeneralTextColor)
////      .background(
////        isLocked
////          ? appStyles.TextfieldBackgroundColorLocked
////          : appStyles.TextfieldBackgroundColorUnLocked
////      )
////      .fixedSize(horizontal: false, vertical: true)
////      .textContentType(.telephoneNumber)
////      .animation(.easeInOut(duration: 1), value: isLocked)
////  }
////}
