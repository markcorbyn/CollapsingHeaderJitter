//
//  ContentView.swift
//  CollapsingHeaderJitter
//
//  Created by Mark Corbyn on 7/9/2022.
//

import SwiftUI

struct ContentView: View {

    @State private var scrollOffset: CGFloat = 0
    @State private var headerNaturalHeight: CGFloat?
    @State private var headerHeight: CGFloat?

    var body: some View {
        VStack(spacing: 0) {
            Header()
                .getSize { size in
                    headerNaturalHeight = size.height
                }
                .frame(height: headerHeight)
            ScrollView {
                ScrollViewContent()
                    .getVerticalOffset(in: .named("scrollView")) { offset in
                        scrollOffset = -offset
                    }
            }
            .coordinateSpace(name: "scrollView")
        }
        .onChange(of: scrollOffset) { offset in
            updateHeaderHeight()
        }
    }

    private func updateHeaderHeight() {
        guard let headerNaturalHeight = headerNaturalHeight else {
            return
        }

        let substractFromNaturalHeight = scrollOffset / 3
        let newHeight = headerNaturalHeight - substractFromNaturalHeight.clamped(to: 0...headerNaturalHeight)
        if newHeight != headerHeight {
            headerHeight = newHeight
        }
    }
}

private struct Header: View {
    var body: some View {
        VStack(spacing: 0) {
            Color.blue.frame(height: 50)
                .overlay(Text("Header Line 1"))
            Color.blue.opacity(0.7).frame(height: 50)
                .overlay(Text("Header Line 2"))
            Color.blue.frame(height: 50)
                .overlay(Text("Header Line 3"))
        }
    }
}

private struct ScrollViewContent: View {

    @State private var rowCount = 2

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    if rowCount > 0 {
                        rowCount -= 1
                    }
                }) {
                    Text("Remove Row")
                }
                Spacer()
                Button(action: { rowCount += 1 }) {
                    Text("Add Row")
                }
            }
            .padding()

            ForEach(0..<rowCount, id: \.self) { number in
                HStack {
                    Text("Row \(number + 1)")
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 50)
                .background(
                    Color.red.opacity(number % 2 == 0 ? 1 : 0.7)
                )
            }
        }
        .background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
