//
//  ContentView.swift
//  Animations
//
//  Created by Chris Boette on 9/30/23.
//

import SwiftUI

struct ContentView: View {
    let letters = Array("Hola SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    @State private var isShowingCyan = false


    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
        
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 25)))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded{ _ in
                        withAnimation(.snappy()) {
                            dragAmount = .zero
                        }
                    }
            )
//            .animation(.spring(), value: dragAmount) // This is simple, yet effective
        
        Spacer()

        Button("Hit it") {
            withAnimation {
                enabled.toggle()
                isShowingCyan.toggle()
            }
        }
        .frame(width: 130, height: 50)
        .background(enabled ? .blue : .red)
//        .animation(nil, value: enabled) // Turn off animation for blue/red switch
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.linear(duration: 0.1), value: enabled)
        
        ZStack {
            Rectangle()
                .fill(.brown)
                .frame(width: 200, height: 200)

            if isShowingCyan {
                Rectangle()
                    .fill(.cyan)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingCyan.toggle()
            }
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: 90, anchor: .topTrailing),
            identity: CornerRotateModifier(amount: 0, anchor: .topTrailing)
        )
    }
}

#Preview {
    ContentView()
}
