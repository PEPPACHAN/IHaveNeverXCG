//
//  LoadingView.swift
//  IHaveNever
//
//  Created by PEPPA CHAN on 29.11.2024.
//

import SwiftUI

struct LoadingView: View {
    var color: Color
    var size: CGFloat
    @State private var isAnimating: Bool = false
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: size/10)
                .foregroundColor(color.opacity(0.3))
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [color.opacity(0.3), color]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: size/10, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .frame(width: size, height: size)
                .animation(
                    Animation
                        .linear(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .onAppear{
            isAnimating.toggle()
        }
    }
}

//#Preview {
//    LoadingView()
//}
