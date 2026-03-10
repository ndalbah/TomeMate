//
//  TomeAuthView.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

enum AuthTab { case login, register }

struct TomeAuthView: View {
    @State private var activeTab: AuthTab = .login
    @State private var bookAppeared = false
    @State private var dustOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            
            RadialGradient(
                colors: [Color.tomeGold.opacity(0.06), .clear],
                center: UnitPoint(x: 0.2, y: 0.5),
                startRadius: 0,
                endRadius: 350
            )
            .ignoresSafeArea()
            
            RadialGradient(
                colors: [Color.tomeCrimson.opacity(0.05), .clear],
                center: UnitPoint(x: 0.8, y: 0.5),
                startRadius: 0,
                endRadius: 350
            )
            .ignoresSafeArea()
            
            TomeParticlesView()
                .opacity(dustOpacity)
                .animation(.easeInOut(duration: 3), value: dustOpacity)
            
            BookView(activeTab: $activeTab)
                .scaleEffect(bookAppeared ? 1: 0.92)
                .opacity(bookAppeared ? 1 : 0)
                .rotation3DEffect(.degrees(bookAppeared ? 0 : 12), axis: (1, 0, 0))
                .animation(
                    .spring(response: 1.1, dampingFraction: 0.75).delay(0.1),
                    value: bookAppeared
                )
            .onAppear {
                bookAppeared = true;
                dustOpacity = 1
            }
        }
    }
}

// Book
struct BookView: View {
    @Binding var activeTab: AuthTab
    var body: some View {
        HStack {
            LeftPageView()
            SpineView()
            RightPageView(activeTab: $activeTab)
        }
        .frame(width: 740, height: 520)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .shadow(color: .black.opacity(0.85), radius: 60, x: 0, y: 30)
        .shadow(color: Color.tomeGold.opacity(0.08), radius: 80)
    }
}

// Left Page
struct LeftPageView: View {
    @State private var appeared = false
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.tomeParchmentDark, Color("#E8D8B0"), Color.tomeParchment, Color("#E0CF9E")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            RuledLinesView()
            AgeSpotView(size: 90, offset: CGPoint(x: 80, y: -100), opacity: 0.05)
            AgeSpotView(size: 55, offset: CGPoint(x: -70, y: 90), opacity: 0.04)
            CornerOrnamentView()
            
            VStack {
                emblemCircle
                    .padding(.bottom, 16)
                    .fadeUp(appeared, delay: 0.4)
                
                Text("TomeMate")
                    .font(.custom("Cinzel-Regular", size: 20))
                    .fontWeight(.semibold)
                    .tracking(3)
                    .fadeUp(appeared, delay: 0.55)
                
                DecorativeRuleView()
                    .padding(.vertical, 10)
                
                Text("D&D Companion Guide")
                    .font(.custom("IMFellEnglish-Regular", size: 10))
                    .foregroundStyle(Color.tomeInk)
                    .tracking(3)
                    .fadeUp(appeared, delay: 0.55)
                
                DecorativeRuleView()
                    .padding(.vertical, 10)
                
                Text("Start your journey now!")
                    .font(.custom("IMFellEnglish-Regular", size: 12))
                    .italic()
                    .foregroundStyle(Color.tomeParchmentText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fadeUp(appeared, delay: 0.75)
                
                Spacer()
                
                WaxSealView()
                    .frame(width: 58, height: 58)
                    .opacity(appeared ? 0.85 : 0)
                    .animation(.easeOut(duration: 0.7).delay(0.9), value: appeared)
            }
            .padding(.vertical, 44)
            .padding(.horizontal, 30)
        }
        .frame(width: 340, height: 520)
        .onAppear {
            appeared = true
        }
    }
    
    private var emblemCircle: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.tomeSepia.opacity(0.5), lineWidth: 1.5)
                .frame(width: 130, height: 130)
            Circle()
                .strokeBorder(Color.tomeSepia.opacity(0.25), lineWidth: 0.8)
                .frame(width: 114, height: 114)
            D20IconView()
                .frame(width: 70, height: 70)
        }
    }
}

// Spine View
struct SpineView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color("#0A0600"), Color("#1A0C04"), Color("#0A0600")],
                startPoint: .leading,
                endPoint: .trailing
            )
            Text("TomeMeat")
                .font(.custom("Cinzel-Regular", size: 7))
                .foregroundStyle(Color.tomeGold.opacity(0.35))
                .tracking(4)
                .rotationEffect(.degrees(90))
        }
        .frame(width: 24, height: 520)
        .shadow(color: .black.opacity(0.5), radius: 6, x: -2)
        .shadow(color: .black.opacity(0.5), radius: 6, x: 2)
    }
}

// Right Page
struct RightPageView: View {
    @Binding var activeTab: AuthTab
    @State private var appeared = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                colors: [Color.tomeParchmentDark, Color("#E8D8B0"), Color.tomeParchment, Color("#E8B9A8")],
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
            
            RuledLinesView()
            
            Rectangle()
                .fill(Color.tomeCrimson.opacity(0.22))
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .padding(.leading, 54)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            AgeSpotView(size: 110, offset: CGPoint(x: 100, y: -110), opacity: 0.04)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    TomeTabButton(label: "Login", isActive: activeTab == .login) {
                        withAnimation(.easeInOut(duration: 0.25)) { activeTab = .login }
                    }
                    TomeTabButton(label: "Register", isActive: activeTab == .register) {
                        withAnimation(.easeInOut(duration: 0.25)) { activeTab = .register }
                    }
                    Spacer()
                }
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.5), value: appeared)
                
                Divider()
                    .background(Color.tomeSepia.opacity(0.3))
                    .padding(.bottom, 22)
                
                // Form Contents
                Group {
                    if activeTab == .login {
                        LoginView()
                            .transition(.asymmetric(insertion: .opacity.combined(with: .offset(x: -10)), removal: .opacity))
                    } else {
                        RegisterView()
                            .transition(.asymmetric(insertion: .opacity.combined(with: .offset(x: 10)), removal: .opacity))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.top, 36)
        }
        .frame(width: 376, height: 520)
        .onAppear {
            appeared = true
        }
    }
}

#Preview {
    TomeAuthView()
        .environmentObject(AuthManager())
        .frame(width: 900, height: 700)
}
