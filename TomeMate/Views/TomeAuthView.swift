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
            
            TomeParticlesView()
                .opacity(dustOpacity)
                .animation(.easeInOut(duration: 3), value: dustOpacity)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    TomeAuthHeaderView()
                        .opacity(bookAppeared ? 1 : 0)
                        .offset(y: bookAppeared ? 0 : 16)
                        .animation(.spring(response: 0.9, dampingFraction: 0.75).delay(0.1), value: bookAppeared)
                    
                    TomeParchmentCard(activeTab: $activeTab)
                        .opacity(bookAppeared ? 1 : 0)
                        .offset(y: bookAppeared ? 0 : 20)
                        .animation(.spring(response: 0.9, dampingFraction: 0.75).delay(0.25), value: bookAppeared)
                        .padding(.horizontal, 16)
                    
                    TomeWaxSealFooter()
                        .opacity(bookAppeared ? 0.85 : 0)
                        .animation(.easeOut(duration: 0.7).delay(0.55), value: bookAppeared)
                        .padding(.top, 28)
                        .padding(.bottom, 48)
                }
                .padding(.top, 52)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                bookAppeared = true
                dustOpacity = 1
            }
        }
    }
}
struct TomeAuthHeaderView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Emblem
            TomeEmblemView()
                .frame(width: 96, height: 96)
                .padding(.bottom, 20)

            Text("TomeMate")
                .font(.custom("Cinzel-SemiBold", size: 22))
                .tracking(4)
                .foregroundStyle(Color.tomeGold)
                .shadow(color: Color.tomeGold.opacity(0.3), radius: 12)

            TomeDecorativeRule()
                .padding(.vertical, 10)
                .frame(maxWidth: 240)

            Text("D&D Companion Guide")
                .font(.custom("IMFellEnglish-Regular", size: 9))
                .tracking(3)
                .foregroundStyle(Color.tomeSepia)
                .textCase(.uppercase)

            Text("Start your journey now…")
                .font(.custom("IMFellEnglish-Italic", size: 12))
                .foregroundStyle(Color.tomeGold.opacity(0.5))
                .padding(.top, 8)
        }
        .padding(.bottom, 28)
    }
}

// MARK: - Emblem

struct TomeEmblemView: View {
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.tomeGold.opacity(0.45), lineWidth: 1.5)
            Circle()
                .strokeBorder(Color.tomeGold.opacity(0.22), lineWidth: 0.8)
                .padding(8)
            D20IconView()
                .frame(width: 52, height: 52)
        }
    }
}

// MARK: - Decorative Rule

struct TomeDecorativeRule: View {
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(
                    LinearGradient(colors: [.clear, Color.tomeSepia, .clear],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .frame(height: 1)
            Rectangle()
                .fill(Color.tomeGold.opacity(0.6))
                .frame(width: 5, height: 5)
                .rotationEffect(.degrees(45))
            Rectangle()
                .fill(
                    LinearGradient(colors: [.clear, Color.tomeSepia, .clear],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .frame(height: 1)
        }
    }
}

// MARK: - Parchment Card

struct TomeParchmentCard: View {
    @Binding var activeTab: AuthTab

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Parchment background
            LinearGradient(
                colors: [Color.tomeParchmentLight, Color.tomeParchmentMid, Color.tomeParchmentDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Ruled lines
            TomeRuledLinesView()

            // Crimson margin line
            Rectangle()
                .fill(Color.tomeCrimson.opacity(0.22))
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .padding(.leading, 52)

            // Age spots
            TomeAgeSpot(size: 100, offset: CGPoint(x: 60, y: -30), opacity: 0.05)
            TomeAgeSpot(size: 60,  offset: CGPoint(x: -20, y: 120), opacity: 0.04)

            // Content
            VStack(alignment: .leading, spacing: 0) {
                // Tabs
                HStack(spacing: 0) {
                    TomeMobileTabButton(label: "Login", isActive: activeTab == .login) {
                        withAnimation(.easeInOut(duration: 0.25)) { activeTab = .login }
                    }
                    TomeMobileTabButton(label: "Register", isActive: activeTab == .register) {
                        withAnimation(.easeInOut(duration: 0.25)) { activeTab = .register }
                    }
                }

                Divider()
                    .background(Color.tomeSepia.opacity(0.3))
                    .padding(.bottom, 22)

                // Form
                Group {
                    if activeTab == .login {
                        LoginView()
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: -10)),
                                removal: .opacity
                            ))
                    } else {
                        RegisterView()
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: 10)),
                                removal: .opacity
                            ))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 28)
        }
        .clipShape(RoundedRectangle(cornerRadius: 3))
        .shadow(color: .black.opacity(0.7), radius: 30, x: 0, y: 16)
        .shadow(color: Color.tomeGold.opacity(0.08), radius: 40)
    }
}

// MARK: - Ruled Lines

struct TomeRuledLinesView: View {
    var body: some View {
        GeometryReader { geo in
            let lineCount = Int(geo.size.height / 24)
            VStack(spacing: 0) {
                ForEach(0..<lineCount, id: \.self) { _ in
                    Spacer()
                    Rectangle()
                        .fill(Color(red: 0.47, green: 0.35, blue: 0.2).opacity(0.07))
                        .frame(height: 1)
                } 
            }
        }
    }
}

// MARK: - Age Spot

struct TomeAgeSpot: View {
    let size: CGFloat
    let offset: CGPoint
    let opacity: Double

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color(red: 0.39, green: 0.27, blue: 0.12).opacity(opacity), .clear],
                    center: .center, startRadius: 0, endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .offset(x: offset.x, y: offset.y)
            .allowsHitTesting(false)
    }
}

// MARK: - Mobile Tab Button

struct TomeMobileTabButton: View {
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(label)
                    .font(.custom("Cinzel-Regular", size: 10))
                    .tracking(2)
                    .foregroundStyle(isActive ? Color.tomeCrimson : Color.tomeParchmentText)
                    .textCase(.uppercase)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)

                // Active underline
                Rectangle()
                    .fill(isActive ? Color.tomeCrimson : Color.clear)
                    .frame(height: 2)
                    .padding(.horizontal, 20)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Wax Seal Footer

struct TomeWaxSealFooter: View {
    var body: some View {
        VStack(spacing: 12) {
            WaxSealView()
                .frame(width: 48, height: 48)

            Text("\"Roll for initiative, adventurer.\"")
                .font(.custom("IMFellEnglish-Italic", size: 10))
                .foregroundStyle(Color.tomeGold.opacity(0.4))
                .tracking(0.5)
        }
    }
}

#Preview {
    TomeAuthView()
        .environmentObject(AuthManager())
        .frame(width: 900, height: 700)
}
