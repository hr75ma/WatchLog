import SwiftUI
import Combine

// MARK: - onTimer

extension View {
    /// Adds an action to perform at specified intervals.
    ///
    /// - Parameters:
    ///   - interval: The time interval on which to publish events. For example, a value of `0.5` publishes an event approximately every half-second.
    ///   - tolerance: The allowed timing variance when emitting events. Defaults to `nil`, which allows any variance.
    ///   - cancelTrigger: A value to monitor for changes to determine when to cancel `Timer`
    ///   - perform: A closure that is executed with the current date each time the timer fires.
    func onTimer(
        every interval: TimeInterval,
        tolerance: TimeInterval? = nil,
        cancelTrigger: AnyHashable? = nil,
        perform: @escaping (_ date: Date) -> Void
    ) -> some View {
        self.modifier(
            TimerModifier(
                every: interval,
                tolerance: tolerance,
                cancelTrigger: cancelTrigger,
                perform: { date in perform(date) }
            )
        )
    }
    
    /// Adds an action to perform at specified intervals.
    ///
    /// - Parameters:
    ///   - interval: The time interval on which to publish events. For example, a value of `0.5` publishes an event approximately every half-second.
    ///   - tolerance: The allowed timing variance when emitting events. Defaults to `nil`, which allows any variance.
    ///   - cancelTrigger: A value to monitor for changes to determine when to cancel `Timer`
    ///   - perform: A closure that is executed each time the timer fires.
    func onTimer(
        every interval: TimeInterval,
        tolerance: TimeInterval? = nil,
        cancelTrigger: AnyHashable? = nil,
        perform: @escaping () -> Void
    ) -> some View {
        self.modifier(
            TimerModifier(
                every: interval,
                tolerance: tolerance,
                cancelTrigger: cancelTrigger,
                perform: { _ in perform() }
            )
        )
    }
}

// MARK: - TimerModifier

/// Use via `.onTimer` modifiers
struct TimerModifier: ViewModifier {
    @State private var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let cancelTrigger: AnyHashable?
    private let perform: (Date) -> Void
    
    init(
        every interval: TimeInterval,
        tolerance: TimeInterval?,
        cancelTrigger: AnyHashable?,
        perform: @escaping (Date) -> Void
    ) {
        self.timer = Timer.publish(every: interval, tolerance: tolerance, on: .main, in: .common)
            .autoconnect()
        self.cancelTrigger = cancelTrigger
        self.perform = perform
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(timer) { date in
                self.perform(date)
            }
            .onChange(of: cancelTrigger) {
                self.timer.upstream.connect().cancel()
            }
    }
}