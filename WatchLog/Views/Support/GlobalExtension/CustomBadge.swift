//
//  CustomBadge.swift
//  WatchLog
//
//  Created by Marcus Hörning on 06.08.25.
//

import SwiftUI

struct CustomBadge: ViewModifier {
    let count: Int
    let maxCountAmount: Int
    
    func body(content: Content) -> some View {
        // if the count is larger than zero, we want to add a badge
        if count > 0 {
            ZStack(alignment: .topTrailing) {
                content
                HStack(spacing: 0) {
                    // min returns the smallest value of either count, or the maxCountAmount
                    Text(min(count, maxCountAmount), format: .number)
                    
                    // optionally adding a plus sign if our badge count gets too large to let the user know
                    // there are more badges than we want to display
                    if count > maxCountAmount {
                        Text("+")
                    }
                }
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(.horizontal, 5)
                // when the badge is a single digit, I like the badge to be close to a circle shape
                .padding(.vertical, count > 9 ? 7 : 5)
                .background(Color.red)
                // when the badge is more than one digit, I like the badge to look like a capsule
                .frame(height: count > 9 ? 17 : 19)
                .clipShape(Capsule())
            }
        } else {
            // if the count is less than or equal to zero, we don't want to add a badge
            content
        }
    }
}

extension View {
    // we want to give the developer the option for a max badge amount
    // so that the design won't overflow the content
    func customBadge(_ count: Int = 0, maxCountAmount: Int = 99) -> some View {
        modifier(CustomBadge(count: count, maxCountAmount: maxCountAmount))
    }
}
