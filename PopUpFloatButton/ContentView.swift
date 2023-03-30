//
//  ContentView.swift
//  PopUpFloatButton
//
//  Created by Cafe on 2023/03/29.
//

import SwiftUI

struct ContentView: View {
    @State var index: Int = 1
    var body: some View {
        ZStack {
            Text("選択した配列のインデックス：\(index)")
            PopUpFloatButton(
                buttonLabelArray: [
                    ButtonLabel(systemName: "0.circle", label: "Zero"),
                    ButtonLabel(systemName: "1.circle", label: "One"),
                    ButtonLabel(systemName: "2.circle", label: "Two"),
                    ButtonLabel(systemName: "3.circle", label: "Three"),
                    ButtonLabel(systemName: "4.circle", label: "Four"),
                ],
                index: $index
            )
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
