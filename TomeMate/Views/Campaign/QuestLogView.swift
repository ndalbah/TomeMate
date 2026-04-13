//
//  QuestLog.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-31.
//

import SwiftUI

struct QuestLogView: View {
    let campaign: Campaign
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder

    var campaignQuests: [Quest] {
        holder.quests.filter { $0.campaign == campaign }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing){
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if campaignQuests.isEmpty {
                    VStack(spacing: 12) {
                        Spacer(minLength: 60)
                        Image(systemName: "scroll")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary.opacity(0.4))
                        Text("No quests yet")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Add your first quest to begin the adventure.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ForEach(campaignQuests, id: \.self) { q in
                        NavigationLink {
                            QuestDetailView(quest: q)
                        } label: {
                            QuestCard(quest: q)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .navigationTitle(campaign.name ?? "Quest Log")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: AddQuestView(campaign: campaign)) {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                }
            }
            }
            NavigationLink(destination: WorldMapView(campaign: campaign)){
                Image(systemName: "map")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.red)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding(24)
        }
    }
}

// MARK: - Quest Card
struct QuestCard: View {
    
    let quest: Quest
    
    var statusColor: Color {
        switch quest.status {
        case "Active":    return .blue
        case "Completed": return .green
        case "Failed":    return .red
        default:          return .secondary
        }
    }
    
    var statusIcon: String {
        switch quest.status {
        case "Active":    return "clock.fill"
        case "Completed": return "checkmark.circle.fill"
        case "Failed":    return "xmark.circle.fill"
        default:          return "circle"
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color(.systemBackground))
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
            .overlay {
                HStack(spacing: 14) {
                    // Status indicator bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(statusColor)
                        .frame(width: 4)
                        .padding(.vertical, 14)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(quest.title ?? "Unknown Quest")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        if let desc = quest.desc, !desc.isEmpty {
                            Text(desc)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: statusIcon)
                                .font(.caption2)
                            Text(quest.status ?? "")
                                .font(.caption2.weight(.medium))
                        }
                        .foregroundColor(statusColor)
                        .padding(.top, 2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(.trailing, 4)
                }
                .padding(.leading, 12)
                .padding(.trailing, 16)
                .padding(.vertical, 4)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 80)
    }
}
