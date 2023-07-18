//
// 📄 MDProgressIndicator.swift
// 👨🏼‍💻 Author: Tobias Gleiss
//

import SwiftUI

public struct MDProgressIndicator: View {

    @State var progress: Double
    @State var width: CGFloat

    @Binding var isCancelled: Bool

    let type: MDProgressIndicatorType
    let duration: Double
    let desiredWidth: CGFloat
    let backgroundBarColor: Color
    let progressBarColor: Color
    let onTimerCompletion: () -> Void

    private var animationDuration: Double { isCancelled ? 0 : duration }
    private var progressAnimation: Animation { isCancelled ? .linear(duration: 0.1) : .linear(duration: duration) }

    /// The SwiftUI Material Design Linear Progress Indicator
    /// - Parameters:
    ///   - type: Specifies if the indicator is a countdown or a progress indicator.
    ///   - duration: The duration of the animation.
    ///   - width: The width of the progress indicator. Will span over all available space if not set.
    ///   - backgroundBarColor: The color of the background bar.
    ///   - progressBarColor: The color of the progress indicator bar.
    ///   - isCancelled: A Binding Bool which will immediately terminate the animation **without** calling the completion if set to `true`.
    ///   - onCompletion: The action which will be executed once the animation is completed.
    ///
    public init(type: MDProgressIndicatorType = .linearCountdown, duration: Double = 2, width: CGFloat = .infinity, backgroundBarColor: Color = .defaultMaterialAccent.opacity(0.3), progressBarColor: Color = .defaultMaterialAccent, isCancelled: Binding<Bool> = .constant(false), onCompletion: @escaping () -> Void = { }) {
        self.type = type
        self.duration = duration
        self.desiredWidth = width
        self.width = width
        self.progress = width // type == .linearProgress ? 0 : width
        self.backgroundBarColor = backgroundBarColor
        self.progressBarColor = progressBarColor
        self._isCancelled = isCancelled
        self.onTimerCompletion = onCompletion
    }

    public var body: some View {
        contentLayer
            .onChange(of: isCancelled, perform: cancellationFlagChanged)
            .onAppear(perform: viewAppeared)
    }

    private var contentLayer: some View {
        ZStack(alignment: .leading) {
            backgroundBar
                .measureWidth { width = $0 }

            progressBar
        }
    }

    private var backgroundBar: some View {
        Rectangle()
            .foregroundColor(backgroundBarColor)
            .frame(height: 4)
    }

    private var progressBar: some View {
        Rectangle()
            .foregroundColor(progressBarColor)
            .frame(width: progress, height: 4)
            .animation(progressAnimation)
    }

    private func viewAppeared() {
        guard !isCancelled else { return }
        switch type {
        // case .linearProgress: progress = width
        case .linearCountdown: progress = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: runCompletionIfPossible)
    }

    private func runCompletionIfPossible() {
        guard !isCancelled else { return }
        onTimerCompletion()
    }

    private func cancellationFlagChanged(to isCancelled: Bool) {
        guard isCancelled else { return }
        switch type {
        // case .linearProgress: progress = width
        case .linearCountdown: progress = 0
        }
    }

}

public enum MDProgressIndicatorType {

    // case linearProgress
    case linearCountdown

}

struct MDProgressIndicator_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            MDProgressIndicator(type: .linearCountdown)
                .padding()
        }
    }

}
