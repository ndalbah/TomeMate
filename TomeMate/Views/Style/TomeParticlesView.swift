//
//  TomeParticlesView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

struct DustMote: Identifiable {
    let id = UUID()
    var x: CGFloat
    var size: CGFloat
    var duration: Double
    var delay: Double
}

private struct DustMoteView: View {
    let mote: DustMote
    let screenHeight: CGFloat
    let screenWidth: CGFloat
    
    @State private var yOffset: CGFloat = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        Circle()
            .fill(Color.tomeGold.opacity(0.35))
            .frame(width: mote.size, height: mote.size)
            .position(x: mote.x * screenWidth, y: screenHeight - yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .linear(duration: mote.duration)
                    .delay(mote.delay)
                    .repeatForever(autoreverses: false)
                ) {
                    yOffset = screenHeight + 20
                }
                withAnimation(.easeIn(duration: 1.5).delay(mote.delay)) {
                    opacity = .random(in: 0.2...0.6)
                }
            }
    }
}

struct TomeParticlesView: View {
    let motes: [DustMote] = (0..<14).map {
        _ in
        DustMote(
            x: .random(in: 0...1),
            size: .random(in: 1.5...3.5),
            duration: .random(in: 14...28),
            delay: .random(in: 0...20)
        )
    }
    
    var body: some View {
        GeometryReader {
            geo in
            ForEach(motes) {
                mote in
                DustMoteView(
                    mote: mote,
                    screenHeight: geo.size.height,
                    screenWidth: geo.size.width
                )
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
