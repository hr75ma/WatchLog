//
//  CallInView.swift
//  WatchLog
//
//  Created by Marcus Hörning on 26.06.25.
//

import SwiftUI

struct CallInView: View {
    
    @Bindable var logEntry: WatchLogEntry
    @Environment(\.appStyles) var appStyles
    
    @State private var selectedCallIn: CallInType.CallInTypeShort = CallInType.CallInTypeShort.EMERGENCY
    @State private var selectedCallInHelper: CallInType.CallInTypeShort = CallInType.CallInTypeShort.EMERGENCY
    @State private var selectedCallInAsString: String = CallInType.callInTypes[CallInType.CallInTypeShort.EMERGENCY]!
    
    
    
    @State private var tempLocked: Bool = false

    
    var body: some View {
      HStack(alignment: .top, spacing: 0) {
          
        SectionImage
        

        VStack(alignment: .leading, spacing: 5) {

            callInSection
        }
      }
      .disabled(logEntry.isLocked)
      .padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 10))
      .overlay(
        Rectangle()
          .frame(height: appStyles.GeneralInnerFrameBorderWidth)  // Border thickness
          .foregroundColor(appStyles.GeneralInnerFrameColor),  // Border color
        alignment: .bottom
      )
      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
  }




extension CallInView {
    
    private var SectionImage: some View {
        Image(systemName: appStyles.SectionCallInImage)
            .SectionImageStyle(primaryColor: appStyles.SectionCallInImagePrimary, secondaryColor: appStyles.SectionCallInImageSecondary)
        //.symbolEffect(.variableColor.cumulative.hideInactiveLayers.nonReversing, options: .repeat(.continuous),isActive: !logEntry.isLocked)
    }
    
    private var callInSection: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Text("Eingang")
                .sectionTextLabel(appStyles: appStyles)
            
            VStack(alignment: .leading, spacing: 0) {
                
                TextField("", text: $selectedCallInAsString)
                  .sectionTextFieldSimulated(appStyles: appStyles, text: $selectedCallInAsString, isLocked: true, numberOfCharacters: 50)
                  .isHidden(!tempLocked, remove: true)
                
                customPickerView(preselectedIndex: $selectedCallIn, appStyles: appStyles)
                    .isHidden(tempLocked, remove: true)
                
                
            }
        }
        .onAppear() {
            withAnimation(.easeInOut(duration: 1)) {
                print("animation onchange uuid")
                selectedCallIn = logEntry.CallIn
                selectedCallInHelper = selectedCallIn
                tempLocked = logEntry.isLocked
            }
        }
        .onChange(of: selectedCallIn) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 1)) {
                logEntry.CallIn = selectedCallIn
                selectedCallInHelper = selectedCallIn
                selectedCallInAsString = CallInType.callInTypes[logEntry.CallIn]!
            }
        }
        .onChange(of: logEntry.uuid) {
            oldValue, newValue in
                withAnimation(.easeInOut(duration: 1)) {
                    print("animation onchange uuid")
                    selectedCallIn = logEntry.CallIn
                    selectedCallInHelper = selectedCallIn
                }
            
        }
        .onChange(of: logEntry.isLocked) {
            withAnimation(.easeInOut(duration: 1)) {
                tempLocked = logEntry.isLocked
                selectedCallInHelper = selectedCallIn
                selectedCallInAsString = CallInType.callInTypes[logEntry.CallIn]!
                
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
    
    struct customPickerView: View {
        @Binding var preselectedIndex: CallInType.CallInTypeShort
        let appStyles: StylesLogEntry
        
        init(preselectedIndex: Binding<CallInType.CallInTypeShort>, appStyles: StylesLogEntry) {
            self._preselectedIndex = preselectedIndex
            
            self.appStyles = appStyles
            
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(appStyles.GeneralInnerFrameColor)
            UISegmentedControl.appearance().backgroundColor = UIColor(appStyles.TextfieldBackgroundColorUnLocked)
            
            UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont(name: appStyles.TextFieldFont, size: appStyles.TextFieldFontSize)!, .foregroundColor: UIColor(appStyles.GeneralTextColor)], for: .normal)

            UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont(name: appStyles.TextFieldFont, size: appStyles.TextFieldFontSize)!, .foregroundColor: UIColor(appStyles.GeneralPickerTextColor)], for: .selected)
            
            UISegmentedControl.appearance().setContentHuggingPriority(.defaultLow, for: .vertical)
        }
        
        
        var body: some View {
            Picker("", selection: $preselectedIndex) {
                ForEach(
                    Array(
                        CallInType.callInTypes.sorted { (first, second) -> Bool in
                            return first.value < second.value
                        }), id: \.key
                ) { key, value in
                    
                    //callInItem(value: value, key: key, isLocked: false, isSelected: true).tag(key)
                    Text(value)
                        //.fixedSize(horizontal: true, vertical: true)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                
                
            }
            .frame(height: appStyles.TextFieldHeight)
            .pickerStyle(.segmented)
        }
    }
    
    
    struct callInItem: View {
        @State var value: String
        @State var key: CallInType.CallInTypeShort
        @State var isLocked: Bool
        
        
        var isSelected: Bool
        
        var body: some View {
            
            HStack(alignment: .center) {
                Text(value)
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
            }
            
        }
    }
}

extension UIColor {
    var color: Color {
        get {
            let rgbColours = self.cgColor.components
            return Color(
                red: Double(rgbColours![0]),
                green: Double(rgbColours![1]),
                blue: Double(rgbColours![2])
            )
        }
    }
}
