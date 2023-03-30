//
//  SelectCircleButton.swift
//  PopUpFloatButton
//
//  Created by Cafe on 2023/03/29.
//

import SwiftUI

struct SelectCircleButton: View {
    
    let buttonLabel: ButtonLabel
    let action: () -> Void
    let color: Color
    let isLabelDisplay: Bool
    
    @State var width: CGFloat = 40
    @State private var fontSize: Font = .title
    
    var body: some View {
        HStack {
            isLabelDisplay ? Text(buttonLabel.label)
                .foregroundColor(.white)
                .fontWeight(.heavy) : nil
            Image(systemName: buttonLabel.systemName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .scaledToFit()
                .padding(width/5)
                .background(
                    Circle()
                        .foregroundColor(color)
                )
                .frame(width: width)
        } // HStack
        .onTapGesture() {
            onTapAction()
        }
    } // body
    private func onTapAction() {
        action()
        withAnimation(.linear(duration: 0.5)) {
            width = width/3
        }
        withAnimation(.linear(duration: 0.3)) {
            width = width*3
        }
    }
}

struct SelectCircleButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectCircleButton(
            buttonLabel: ButtonLabel(systemName: "1.circle", label: "One"),
            action: {
                //
            },
            color: .blue,
            isLabelDisplay: true
        )
    }
}
