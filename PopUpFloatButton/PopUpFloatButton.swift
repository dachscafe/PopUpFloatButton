//
//  PopUpFloatButton.swift
//  PopUpFloatButton
//
//  Created by Cafe on 2023/03/29.
//

import SwiftUI


struct PopUpFloatButton: View {
    
    let buttonLabelArray: [ButtonLabel]
    
    @Binding var index : Int
    
    @State private var offset: CGFloat = 0
    @State private var angle = Angle(degrees: 180)
    @State private var opacity: CGFloat = 0
    @State private var isOpen: Bool = false
    @State private var isLabelDisplay: Bool = false
    
    private let width: CGFloat = 60
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black
                .opacity(isOpen ? 0.7 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isOpen = false
                }
            ZStack(alignment: .trailing) {
                // TODO: 一応動くけど、配列が空の時エラーあるよっていうattentionが残っている。
                ForEach(0..<Int(buttonLabelArray.count - 1)) { num in
                    SelectCircleButton(
                        buttonLabel: buttonLabelArray[indexManageDict()[index]![num]],
                        action: {
                            isOpen = false
                            index = indexManageDict()[index]![num]
                        },
                        color: .mint,
                        isLabelDisplay: isLabelDisplay
                    )
                    .rotationEffect(angle)
                    .offset(y: -offset * CGFloat(num + 1))
                    .opacity(opacity)
                }
                
                SelectCircleButton(
                    buttonLabel: buttonLabelArray[index],
                    action: {
                        isOpen.toggle()
                    },
                    color: .blue,
                    isLabelDisplay: isLabelDisplay,
                    width: width
                )
            } // ZStack
            .padding()
        } // ZStack
        .onChange(of: isOpen) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.1)) {
                    offset = width + 5
                    angle = Angle(degrees: 0)
                    isLabelDisplay = true
                    opacity = 1
                }
            } else {
                withAnimation(.easeInOut(duration: 0.1)) {
                    offset = 0
                    angle = Angle(degrees: 180)
                    isLabelDisplay = false
                    opacity = 0
                }
            }
        }
    } // body
    
    private func indexManageDict() -> [Int: [Int]] {
        // 選択肢が５つの場合、
        // [0: [1,2,3,4], 1: [0,2,3,4], 2: [0,1,3,4]]・・・]
        // というdictuonaryを作成して返し、選択されたボタンと、選択できるボタンのindexを分けている。
        var dict: [Int: [Int]] = [:]
        var array: [Int] = []
        let num: Int = buttonLabelArray.count
        for i in 0...num {
            for j in 0...num {
                if i != j {
                    array.append(j)
                }
            }
            dict[i] = array
            array = []
        }
        return dict
    }
}

struct PopUpFloatButton_Previews: PreviewProvider {
    static var previews: some View {
        PopUpFloatButton(
            buttonLabelArray: [
                ButtonLabel(systemName: "1.circle", label: "One"),
                ButtonLabel(systemName: "2.circle", label: "Two"),
                ButtonLabel(systemName: "3.circle", label: "Three"),
                ButtonLabel(systemName: "4.circle", label: "Four"),
                ButtonLabel(systemName: "5.circle", label: "Five"),
            ],
            index: .constant(1)
        )
    }
}
