//
//  SplashView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-04-11.
//

import SwiftUI

struct SplashView: View {
    @Binding var showLanding: Bool
     
        @State private var appeared = false
        @State private var dustOpacity: Double = 0
        @State private var emblemScale: CGFloat = 0.7
        @State private var glowPulse: Bool = false
     
        var body: some View {
            ZStack {
                // ── Background ──────────────────────────────────────────────
                LinearGradient(
                    colors: [Color("#2A1A08"), Color("#1E1008"), Color("#2C1A0A"), Color("#180E06")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
     
                RadialGradient(
                    colors: [Color.tomeGold.opacity(0.18), .clear],
                    center: UnitPoint(x: 0.15, y: 0.1),
                    startRadius: 0, endRadius: 300
                )
                .ignoresSafeArea()
     
                RadialGradient(
                    colors: [Color.tomeCrimson.opacity(0.14), .clear],
                    center: UnitPoint(x: 0.88, y: 0.9),
                    startRadius: 0, endRadius: 260
                )
                .ignoresSafeArea()
     
                RadialGradient(
                    colors: [.clear, Color.black.opacity(0.55)],
                    center: .center,
                    startRadius: 120, endRadius: 500
                )
                .ignoresSafeArea()
     
                // ── Particles ────────────────────────────────────────────────
                TomeParticlesView()
                    .opacity(dustOpacity)
                    .animation(.easeInOut(duration: 3), value: dustOpacity)
     
                // ── Main Content ─────────────────────────────────────────────
                VStack(spacing: 0) {
                    Spacer()
     
                    // Emblem glow halo
                    ZStack {
                        Circle()
                            .fill(Color.tomeGold.opacity(glowPulse ? 0.12 : 0.05))
                            .frame(width: 160, height: 160)
                            .blur(radius: 30)
                            .animation(
                                .easeInOut(duration: 2.4).repeatForever(autoreverses: true),
                                value: glowPulse
                            )
     
                        TomeEmblemView()
                            .frame(width: 110, height: 110)
                    }
                    .scaleEffect(emblemScale)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 1.0, dampingFraction: 0.7).delay(0.15), value: appeared)
                    .animation(.spring(response: 1.0, dampingFraction: 0.7).delay(0.15), value: emblemScale)
     
                    // Title
                    VStack(spacing: 6) {
                        Text("TomeMate")
                            .font(.custom("Cinzel-Bold", size: 36))
                            .tracking(6)
                            .foregroundStyle(Color.tomeGold)
                            .shadow(color: Color.tomeGold.opacity(0.35), radius: 16)
     
                        TomeDecorativeRule()
                            .frame(maxWidth: 220)
                            .padding(.vertical, 10)
     
                        Text("D&D Companion Guide")
                            .font(.custom("IMFellEnglish-Regular", size: 12))
                            .tracking(3)
                            .foregroundStyle(Color.tomeSepia)
                            .textCase(.uppercase)
                    }
                    .padding(.top, 28)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)
                    .animation(.spring(response: 0.9, dampingFraction: 0.75).delay(0.35), value: appeared)
                    
                    Spacer()
     
                }
                .padding(.horizontal, 32)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    appeared = true
                    emblemScale = 1.0
                    dustOpacity = 1
                    glowPulse = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showLanding = false
                    }
                }
            }
        }
    }
     
#Preview {
    SplashView(showLanding: .constant(true))
        .environmentObject(AuthManager())
}
