//
//  GlobalViewExtension.swift
//  WatchLog
//
//  Created by Marcus Hörning on 11.07.25.
//

import SwiftUI


struct DisableAnimationsViewModifier: ViewModifier {
    let disableAnimation: Bool
    func body(content: Content) -> some View {
        if disableAnimation {
            content.transaction { $0.animation = nil }
        } else {
            content
        }
    }
}

extension View {
    func disableAnimations(disableAnimation: Bool) -> some View {
        modifier(DisableAnimationsViewModifier(disableAnimation: disableAnimation))
    }
}


struct FullScreenCoverModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .presentationBackground(.watchLogViewGeneralBackground)
            .transition(.move(edge: .bottom))
    }
}

extension View {


    func fullScreenCoverModifier() -> some View {
        modifier(FullScreenCoverModifier())
    }
}





extension View {
    // .if Condition
    // - Parameters:
    //   - condition: A Boolean value determining whether the transformation should be applied.
    //   - transform: A closure taking the original view and returning a modified content.
    // - Returns: If the condition is true, returns the transformed content; otherwise, returns the original view.
    //    Text("Welcome to SwiftUI!")
    //        .if(someCondition) {
    //            $0.font(.headline)
    //                .foregroundColor(.green)
    //        }
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    // .ifLet Condition
    // - Parameters:
    //   - value: An optional value that determines whether the transformation should be applied.
    //   - transform: A closure taking the original view and the unwrapped value, returning a modified content.
    // - Returns: If the optional value is non-nil, returns the transformed content; otherwise, returns the original view.
    // Text("Welcome!")
    //    .ifLet(stylingColor) { $0.background($1) }
    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, transform: (Self, T) -> Content) -> some View {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }

    // .modifierIf Condition
    // - Parameters:
    //   - condition: A Boolean value determining whether the modifier should be applied.
    //   - modifier: The custom view modifier to be applied if the condition is true.
    // - Returns: If the condition is true, returns the view with the applied modifier; otherwise, returns the original view.
    // Text(self.price)
    // .modifierIf(hasSpecialPrice, modifier: SpecialPriceModifier())
    @ViewBuilder
    func modifierIf<Modifier: ViewModifier>(_ condition: Bool, modifier: Modifier) -> some View {
        if condition {
            self.modifier(modifier)
        } else {
            self
        }
    }
}
