//
//  LimitedIndicatorTextField.swift
//  WatchLog
//
//  Created by Marcus Hörning on 10.07.25.
//

import SwiftUI

struct LimitedIndicatorTextField: View {
    //Configuration
    var config: Config
    var hint: String
    @Binding var value: String
    let isLocked: Bool
    
    @Environment(\.appStyles) var appStyles
    
   // view properties
    @FocusState private var isKeyboardShowing: Bool
    var body: some View {
       // VStack(alignment: config.progressConfig.alignment, spacing: 12) {
        ZStack(alignment: .trailing) {
            TextField(hint, text: $value, axis: .vertical)
                .sectionTextFieldIndicator(
                                    text: $value, isLocked: isLocked, appStyles: appStyles
                                )
                .focused($isKeyboardShowing)
                .onChange(of: value, initial: true) { oldValue, newValue in
                    guard !config.allowsExcessTyping else { return }
                    value = String(value.prefix(config.limit))
                    
                }
            
//            //progress bar - text indicator
            HStack(alignment: .top, spacing: 0) {
                if config.progressConfig.showsRing && !isLocked {
                    ZStack {
                        Circle()
                            .stroke(.ultraThinMaterial, lineWidth: 4)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(progressColor.gradient, lineWidth: 4)
                            .rotationEffect(.init(degrees:-90))
                            .animation(.linear(duration: 0.25), value: progressColor)
                    }
                    .frame(width: 23, height: 23)
                }
                
                if config.progressConfig.showsText {
                    Text("\(value.count)/\(config.limit)")
                        .foregroundStyle(progressColor.gradient)
                }
            }
            .offset(x: -14)
            .animation(.easeOut(duration: 1), value: isLocked)
        }
    }
    
    var progress: CGFloat {
        return max(min(CGFloat(value.count) / CGFloat(config.limit), 1), 0)
    }
    
    var progressColor: Color {
        return withAnimation { progress < 0.6 ? config.tint : progress == 1.0 ? .red : .orange }
    }
        
        //textfield config
        struct Config {
            var limit: Int
            var tint: Color = .blue
            var autoResizes: Bool = false
            var allowsExcessTyping: Bool = false
            var progressConfig: ProgressConfig = .init()
            var borderConfig: BorderConfig = .init()
        }

        struct ProgressConfig {
            var showsRing: Bool = true
            var showsText: Bool = false
            var alignment: HorizontalAlignment = .trailing
        }

        struct BorderConfig {
            var show: Bool = true
            var radius: CGFloat = 12
            var width: CGFloat = 0.8
        }
}

