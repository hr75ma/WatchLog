//
//  test.swift
//  WatchLog
//
//  Created by Marcus Hörning on 09.07.25.
//

import SwiftUI

struct AnimatedListRowBackground: View {
    @State private var selectedRow: Int? = nil
    @State private var isAnimating = false

    var body: some View {
        List(0..<10, id: \.self) { index in
            Text("Row \(index)")
                .padding()
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedRow == index ? Color.blue : Color.gray)
                        .animation(.easeInOut(duration: 1), value: selectedRow)
                )
                .onTapGesture {
                    withAnimation {
                        selectedRow = selectedRow == index ? nil : index
                    }
                }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct AnimatedListRowBackground_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedListRowBackground()
    }
}


