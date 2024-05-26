//
//  RangePickerBar.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 29/6/23.
//

import SwiftUI
import XUI

public struct SliderRangePicker: View {

    private let value: Binding<ClosedRange<Int>>
    private let sliderBounds: ClosedRange<Int>
    private let step: Int
    private let formatter = KMBFormatter()
    private let controlWidth = CGFloat(30)

    @State private var currentValue: ClosedRange<Int>
    @State private var isLowerActive = false
    @State private var isUpperActive = false

    public init(value: Binding<ClosedRange<Int>>, step: Int) {
        self.value = value
        self.currentValue = value.wrappedValue
        self.sliderBounds = 0...(step * 100)
        self.step = step
    }

    public var body: some View {
        VStack(spacing: 1) {
            Spacer(minLength: 20)
            GeometryReader { geomentry in
                sliderView(sliderSize: geomentry.size)
            }
            Spacer(minLength: 10)
        }
        .padding(.horizontal)
        .task {
            if currentValue == 0...0 {
                currentValue = sliderBounds
            }
        }
    }

    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2

        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .frame(height: 4)
                .foregroundStyle(.quaternary)

            ZStack {
                let sliderBoundDifference = sliderBounds.count - 1
                let stepWidthInPixel = sliderSize.width / sliderBoundDifference.cgFloat

                let leftThumbLocation = (currentValue.lowerBound.cgFloat - sliderBounds.lowerBound.cgFloat) * stepWidthInPixel
                let rightThumbLocation = currentValue.upperBound.cgFloat * stepWidthInPixel

                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))

                let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)

                thumbView(position: leftThumbPoint, value: currentValue.lowerBound)
                    .foregroundStyle(isLowerActive ? .primary : .tertiary)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { dragValue in
                                let dragLocation = dragValue.location

                                let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)

                                let newValue = (sliderBounds.lowerBound.cgFloat) + (xThumbOffset / stepWidthInPixel)

                                let rounded = (newValue.int / step) * step
                                // Stop the range thumbs from colliding each other
                                if rounded < currentValue.upperBound && rounded != currentValue.lowerBound {
                                    isLowerActive = true
                                    currentValue = rounded...currentValue.upperBound
                                    _Haptics.play(.soft)
                                }
                            }.onEnded { _ in
                                isLowerActive = false
                                update()
                            }
                    )

                // Right Thumb Handle
                thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: currentValue.upperBound)
                    .foregroundStyle(isUpperActive ? .primary : .tertiary)
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { dragValue in
                                let dragLocation = dragValue.location
                                let xThumbOffset = min(max(leftThumbPoint.x, dragLocation.x), sliderSize.width)

                                let newValue = (sliderBounds.lowerBound.cgFloat) + (xThumbOffset / stepWidthInPixel)

                                let rounded = ((newValue.int / step) * step)
                                // Stop the range thumbs from colliding each other
                                if rounded > currentValue.lowerBound && rounded != currentValue.upperBound {
                                    isUpperActive = true
                                    currentValue = currentValue.lowerBound...rounded
                                    _Haptics.play(.soft)
                                }
                            }.onEnded { _ in
                                isUpperActive = false
                                update()
                            }
                    )
            }
        }
    }

    @ViewBuilder private func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(Color.green, lineWidth: 4)
    }

    @ViewBuilder private func thumbView(position: CGPoint, value: Int) -> some View {
        ZStack {
            Text(formatter.string(fromNumber: value))
                .font(.footnote.bold().italic())
                .offset(y: -23)

            Circle()
                .fill(isValid(value) ? Color.green : Color(uiColor: .systemBackground))
                .frame(square: controlWidth)
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
                .contentShape(Rectangle())
                .padding()
        }
        .position(x: position.x, y: position.y)
    }

    private func isValid(_ value: Int) -> Bool {
        value > sliderBounds.lowerBound && value < sliderBounds.upperBound
    }

    private func update() {
        value.wrappedValue = currentValue
        _Haptics.generateNotificationFeedback(style: .success)
    }
}
