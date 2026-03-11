//
//  TomeExtras.swift
//  TomeMate
//
//  Created by Justin Pescador on 2026-03-10.
//
import SwiftUI

// Decorative horizontal rule
struct DecorativeRuleView: View {
    var body: some View {
        HStack {
            Spacer()
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, Color.tomeSepia.opacity(0.6), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 100, height: 1)
            Spacer()
        }
    }
}

// Notebook lines
struct RuledLinesView: View {
    var body: some View {
        GeometryReader {
            geo in
            let spacing: CGFloat = 20
            let count = Int(geo.size.height / spacing) + 1
            Canvas {
                ctx, size in
                for i in 0..<count {
                    let y = CGFloat(i) * spacing + 70
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                    ctx.stroke(path, with: .color(Color("#8B6E3C")), lineWidth: 0.8)
                }
            }
        }
    }
}

// Corner Scroll Ornaments
struct CornerOrnamentView: View {
    var body: some View {
        ZStack {
            CornerMark()
                .padding(12).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            CornerMark()
                .rotationEffect(.degrees(90)).padding(12).frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topTrailing)
            CornerMark().rotationEffect(.degrees(270))
                .padding(12).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            CornerMark().rotationEffect(.degrees(180))
                .padding(12).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .opacity(0.35)
    }
}

struct CornerMark: View {
    var body: some View {
        Path {
            p in
            p.move(to: CGPoint(x: 0, y: 36))
            p.addLine(to: CGPoint(x: 0, y: 0))
            p.addLine(to: CGPoint(x: 36, y: 0))
            p.move(to: CGPoint(x: 0, y: 14))
            p.addQuadCurve(to: CGPoint(x: 14, y: 0), control: CGPoint(x: 6, y: 6))
        }
        .stroke(Color("#6B4C1A"), lineWidth: 1.2)
        .frame(width: 36, height: 36)
    }
}

// Aged Parchment Spot
struct AgeSpotView: View {
    let size: CGFloat
    let offset: CGPoint
    let opacity: Double
    
    var body: some View {
        Circle()
            .fill(Color("#8B6428").opacity(opacity))
            .frame(width: size, height: size)
            .offset(x: offset.x, y: offset.y)
            .blur(radius: size * 0.3)
    }
}

// Wax Seal
struct WaxSealView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("#7A1010").opacity(0.9))
            Circle()
                .strokeBorder(Color("#FFCC96").opacity(0.25), lineWidth: 0.8)
                .padding(6)
            VStack(spacing: 1) {
                Text("Tome")
                    .font(.custom("Cinzel-Regular", size: 7))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.tomeParchment.opacity(0.75))
                Text("Mate")
                    .font(.custom("Cinzel-Regular", size: 7))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.tomeParchment.opacity(0.75))
            }
        }
    }
}

// D20
struct D20IconView: View {
    var body: some View {
        Canvas {
            ctx, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let r: CGFloat = min(size.width, size.height) * 0.45
            
            let pts = (0..<6).map {
                i -> CGPoint in
                let a = CGFloat(i) * .pi / 3 - .pi / 6
                return CGPoint(x : cx + r * cos(a), y: cy + r * sin(a))
            }
            
            var hex = Path()
            hex.addLines(pts)
            hex.closeSubpath()
            ctx.stroke(hex, with: .color(Color("#6B4C1A")), lineWidth: 1.2)
            
            let top = CGPoint(x: cx, y: cy - r * 0.6)
            for pt in [pts[0], pts[1]] {
                var p = Path();
                p.move(to: top);
                p.addLine(to: pt)
                ctx.stroke(p, with: .color(Color("#6B4C1A").opacity(0.5)), lineWidth: 0.8)
            }
            
            ctx.draw(
                Text("20")
                    .font(.custom("Cinzel-Regular", size: 16))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("#6B4C1A")),
                at: CGPoint(x: cx, y: cy + 2),
                anchor: .center
            )
        }
    }
}

// Tab Button
struct TomeTabButton: View {
    let label: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(label)
                    .font(.custom("Cinzel-Regular", size: 10))
                    .tracking(1.5)
                    .foregroundStyle(isActive ? Color.tomeInk : Color.tomeSepia)
                    .padding(.horizontal, 16)
                    .padding(.top, 2)
                Rectangle()
                    .fill(isActive ? Color.tomeCrimson : .clear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
}

// Fadeup view notifier
extension View {
    func fadeUp(_ appeared: Bool, delay: Double) -> some View {
        self
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 14)
            .animation(.easeInOut(duration: 0.7).delay(delay), value: appeared)
    }
}
