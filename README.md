# 概要
- SwiftUIでオシャレな選択ボタンを作りたかった
- アニメーションなどを色々駆使して作りました
- Googleカレンダーアプリの右下のボタンぽいものにしました


# 環境
- macOS: 13.0.1
- iOS: 16.1
- XCode: 14.1


# 完成品
- ボタンを押すと、選択肢が出てきて、タップしたボタンが選択されます。
- 少し回転しながらボタンが出たり入ったりするのがこだわりポイントです。
     <img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/2918864/3ab8f5c3-b6ee-d320-d8c0-72a02f2c6a2d.gif" width=200>


# GitHub
https://github.com/dachscafe/PopUpFloatButton


# ソースコード

1. 選択ボタンの情報を格納するButtonLabel`モデルを作成します。`systemName`でボタンのアイコンを指定したり、`label`でボタンのラベルを指定できます。

    ```swift: ButtonLabel.swift
        import Foundation

        struct ButtonLabel: Identifiable {
            let id = UUID()
            let systemName: String
            let label: String
        }
    ```


1. 以下はContentView。`ButtonLabel`モデルに従って、配列を作成すると使えます。`@Binding`でインデックスが返ってきます。

    ```swift: ContentView.swift
    
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

    ```

1. ここから、詳細に入ります。`PopUpFloatButton.swift`と`SelectCircleButton.swift`です。解説は難しいですが、簡単にいうと、ボタンを押すと、`offset`モディファイアの`y`の値が変わり、重なっていたボタンがずれるようになっています。


    ```swift: PopUpFloatButton.swift
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
    
    
    ```
    
    ```swift: SelectCircleButton.swift
    
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
    
    ```

1. 以上
