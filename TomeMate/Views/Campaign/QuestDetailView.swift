import SwiftUI

struct QuestDetailView: View {
    @ObservedObject var quest: Quest
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder

    @State private var showStatusPicker = false

    let statuses = ["Active", "Completed", "Failed"]

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

    var logs: [String] {
        quest.logs ?? []
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 12) {

                    // Status row
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: statusIcon)
                                .font(.caption)
                            Text(quest.status ?? "Unknown")
                                .font(.caption.weight(.semibold))
                        }
                        .foregroundColor(statusColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(statusColor.opacity(0.1))
                        .cornerRadius(20)

                        Spacer()

                        Button {
                            withAnimation { showStatusPicker.toggle() }
                        } label: {
                            Text("Change Status")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(.systemGray5))
                                .cornerRadius(20)
                        }
                    }

                    // Description
                    if let desc = quest.desc, !desc.isEmpty {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundColor(.primary.opacity(0.8))
                    }

                    Divider()

                    // Location
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.secondary)
                        Text(quest.location ?? "N/A")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                if showStatusPicker {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Update Status")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .kerning(1)

                        HStack(spacing: 10) {
                            ForEach(statuses, id: \.self) { status in
                                let color: Color = status == "Active" ? .blue : status == "Completed" ? .green : .red
                                Button {
                                    holder.updateQuest(log: nil, status: status, quest: quest, context)
                                    withAnimation { showStatusPicker = false }
                                } label: {
                                    Text(status)
                                        .font(.subheadline.weight(.medium))
                                        .foregroundColor(quest.status == status ? .white : color)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(quest.status == status ? color : color.opacity(0.1))
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Quest Log")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .kerning(1)
                        Spacer()
                        NavigationLink(destination: AddQuestLogView(quest: quest)) {
                            Image(systemName: "plus")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.primary)
                        }
                    }

                    if logs.isEmpty {
                        Text("No log entries yet.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    } else {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(logs.enumerated()), id: \.offset) { index, entry in
                                HStack(alignment: .top, spacing: 12) {
                                    VStack(spacing: 0) {
                                        Circle()
                                            .fill(Color.primary.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                            .padding(.top, 5)
                                        if index < logs.count - 1 {
                                            Rectangle()
                                                .fill(Color.primary.opacity(0.1))
                                                .frame(width: 1)
                                                .frame(minHeight: 30)
                                                .padding(.top, 2)
                                        }
                                    }
                                    .frame(width: 8)

                                    Text(entry)
                                        .font(.subheadline)
                                        .foregroundColor(.primary.opacity(0.85))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.bottom, 20)
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle(quest.title ?? "Quest")
        .navigationBarTitleDisplayMode(.large)
        .animation(.easeInOut(duration: 0.2), value: showStatusPicker)
    }
}
