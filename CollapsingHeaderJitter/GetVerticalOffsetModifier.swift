//
//  GetVerticalOffsetModifier.swift
//

import SwiftUI

extension View {
    func getVerticalOffset(
        in coordinateSpace: CoordinateSpace,
        perform: @escaping (CGFloat) -> Void
    ) -> some View {
        modifier(GetVerticalOffsetModifier(coordinateSpace: coordinateSpace))
            .onPreferenceChange(VerticalOffsetPreferenceKey.self) {
                perform($0)
            }
    }
}

private struct VerticalOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct GetVerticalOffsetModifier: ViewModifier {
    let coordinateSpace: CoordinateSpace

    func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: VerticalOffsetPreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin.y
                )
            }
        )
    }
}
