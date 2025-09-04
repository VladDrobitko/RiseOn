//
//  WheelTimePicker.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 04/02/2025.
//

import SwiftUI

// MARK: - iOS-Style Wheel Time Picker
struct WheelTimePicker: View {
    @Binding var selectedHour: Int
    @Binding var selectedMinute: Int
    @Binding var isAM: Bool
    
    private let itemHeight: CGFloat = 34
    private let visibleItems: Int = 5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Selection indicator background
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.05))
                    .frame(height: itemHeight)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                HStack(spacing: 8) {
                    // Hours wheel
                    WheelPickerColumn(
                        values: Array(1...12),
                        selection: $selectedHour,
                        width: 60
                    )
                    
                    // Separator
                    Text(":")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 8)
                    
                    // Minutes wheel
                    WheelPickerColumn(
                        values: Array(0...59),
                        selection: $selectedMinute,
                        width: 60,
                        formatter: { String(format: "%02d", $0) }
                    )
                    
                    // Spacer between minutes and AM/PM
                    Spacer()
                        .frame(width: 12)
                    
                    // AM/PM wheel
                    WheelPickerColumn(
                        values: [0, 1], // 0 = AM, 1 = PM
                        selection: Binding(
                            get: { isAM ? 0 : 1 },
                            set: { isAM = $0 == 0 }
                        ),
                        width: 50,
                        formatter: { $0 == 0 ? "AM" : "PM" }
                    )
                }
                .frame(maxWidth: 220) // Limit total width for compactness
            }
        }
        .frame(height: CGFloat(visibleItems) * itemHeight)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .clipped()
    }
}

// MARK: - iOS-Style Wheel Picker Column
struct WheelPickerColumn: View {
    let values: [Int]
    @Binding var selection: Int
    let width: CGFloat
    let formatter: ((Int) -> String)?
    
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragValue: CGFloat = 0
    
    private let itemHeight: CGFloat = 34
    private let totalItems: Int = 5
    
    init(values: [Int], selection: Binding<Int>, width: CGFloat, formatter: ((Int) -> String)? = nil) {
        self.values = values
        self._selection = selection
        self.width = width
        self.formatter = formatter
    }
    
    var body: some View {
        GeometryReader { geometry in
            let centerY = geometry.size.height / 2
            
            ZStack {
                ForEach(allVisibleIndices, id: \.self) { index in
                    let value = values[index]
                    let position = CGFloat(index - selectedIndex) * itemHeight + dragOffset
                    let yPosition = centerY + position
                    let distanceFromCenter = abs(position)
                    
                    Text(formatter?(value) ?? String(value))
                        .font(.system(size: fontSize(for: distanceFromCenter), 
                                    weight: fontWeight(for: distanceFromCenter)))
                        .foregroundColor(textColor(for: distanceFromCenter))
                        .opacity(opacity(for: distanceFromCenter))
                        .scaleEffect(scale(for: distanceFromCenter))
                        .position(x: geometry.size.width / 2, y: yPosition)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                selection = value
                                dragOffset = 0
                            }
                        }
                }
            }
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.25),
                        .init(color: .black, location: 0.75),
                        .init(color: .clear, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = lastDragValue + value.translation.height
                    }
                    .onEnded { value in
                        let velocity = value.predictedEndTranslation.height - value.translation.height
                        snapToNearestValue(with: velocity)
                    }
            )
        }
        .frame(width: width)
        .onChange(of: selection) { _, _ in
            withAnimation(.easeOut(duration: 0.3)) {
                dragOffset = 0
                lastDragValue = 0
            }
        }
    }
    
    private var selectedIndex: Int {
        values.firstIndex(of: selection) ?? 0
    }
    
    private var allVisibleIndices: [Int] {
        let range = totalItems + 2
        let start = max(0, selectedIndex - range)
        let end = min(values.count - 1, selectedIndex + range)
        return Array(start...end)
    }
    
    private func snapToNearestValue(with velocity: CGFloat) {
        let finalOffset = dragOffset + velocity * 0.3
        let targetIndex = selectedIndex - Int(round(finalOffset / itemHeight))
        let clampedIndex = max(0, min(values.count - 1, targetIndex))
        
        withAnimation(.easeOut(duration: 0.5)) {
            selection = values[clampedIndex]
            dragOffset = 0
            lastDragValue = 0
        }
    }
    
    private func fontSize(for distance: CGFloat) -> CGFloat {
        let normalizedDistance = min(distance / itemHeight, 2.0)
        return max(16, 20 - normalizedDistance * 4)
    }
    
    private func fontWeight(for distance: CGFloat) -> Font.Weight {
        return distance < itemHeight / 2 ? .medium : .regular
    }
    
    private func textColor(for distance: CGFloat) -> Color {
        return .white
    }
    
    private func opacity(for distance: CGFloat) -> Double {
        let normalizedDistance = min(distance / itemHeight, 2.0)
        return max(0.3, 1.0 - normalizedDistance * 0.35)
    }
    
    private func scale(for distance: CGFloat) -> CGFloat {
        let normalizedDistance = min(distance / itemHeight, 2.0)
        return max(0.8, 1.0 - normalizedDistance * 0.1)
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var hour = 11
        @State private var minute = 30
        @State private var isAM = true
        
        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Text("Selected Time: \(String(format: "%02d:%02d %@", hour, minute, isAM ? "AM" : "PM"))")
                        .riseOnHeading3()
                        .foregroundColor(.typographyPrimary)
                    
                    WheelTimePicker(
                        selectedHour: $hour,
                        selectedMinute: $minute,
                        isAM: $isAM
                    )
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    return PreviewWrapper()
        .preferredColorScheme(.dark)
}
