import SwiftUI

struct CharacterOverviewView: View {
    
    @State var character: Character?
    @Binding var path: NavigationPath
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Avatar + Name
                    HStack(spacing: 16) {
                        ZStack {
                            if let image = character?.charImg {
                                Image(image)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Color.gray.opacity(0.15)
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.primary.opacity(0.1), lineWidth: 1))
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(character?.name ?? "Unknown")
                                .font(.system(size: 20, weight: .semibold, design: .serif))
                            Text("Lvl \(character?.level ?? 1)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                            let classNames = (character?.classes as? Set<Classes>)
                                .map { $0.compactMap { $0.name }.sorted().joined(separator: " / ") } ?? "—"
                            Text("\(character?.race ?? "—")  ·  \(classNames)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // MARK: - Details
                    
                    let subclassNames = (character?.classes as? Set<Classes>)
                        .map { $0.compactMap{ $0.subclass}.sorted().joined(separator: " / ")}
                    ?? "—"
                    
                    VStack(spacing: 14) {
                        HStack {
                            StatCircle(icon: "heart", value: "\(character?.hp ?? 0)", label: "Hit Points")
                            Spacer()
                            StatCircle(icon: "shield", value: "\(character?.armorClass ?? 0)", label: "Armor Class")
                            Spacer()
                            VStack(spacing: 4) {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1.5)
                                    .frame(width: 44, height: 44)
                                    .overlay {
                                        Text("\(character?.initiative ?? 0)")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                Text("Initiative")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(spacing: 4) {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1.5)
                                    .frame(width: 44, height: 44)
                                    .overlay {
                                        Text("\(character?.passivePerception ?? 0)")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                Text("Perception")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primary.opacity(0.3), lineWidth: 1.5)
                                    .frame(width: 44, height: 44)
                                    .overlay {
                                        VStack(spacing: 1) {
                                            Text("\(character?.speed ?? "30")")
                                                .font(.system(size: 12, weight: .bold))
                                        }
                                    }
                                Text("Speed")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        HStack{
                            if(character?.useXp == true){
                                HStack(spacing: 6) {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 10))
                                    Text("\(character?.experiencePoints ?? 0) xp")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                            }
                            
                            Spacer()
                            HStack(spacing: 6) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 10))
                                Text("\(character?.gold ?? 0) gp")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.yellow.opacity(0.1))
                            .cornerRadius(8)
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.indigo)
                                    .font(.system(size: 12))
                                Text("\(character?.inspiration ?? 0) Inspiration")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.indigo.opacity(0.1))
                            .cornerRadius(8)
                        }
                        Divider()
                        
                        OverviewRow(label: "Subclass", value: subclassNames)
                        OverviewRow(label: "Subrace", value: character?.subrace ?? "—")
                        OverviewRow(label: "Background", value: character?.background ?? "—")
                        OverviewRow(label: "Alignment", value: character?.alignment ?? "—")
                        OverviewRow(label: "Age", value: "\(character?.age ?? 0) years old")
                    }
                    
                    Divider()
                    
                    // MARK: - Stats
                    HStack {
                        Text("Stats")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .kerning(1)
                        Spacer()
                        NavigationLink(destination: ChangeStatsView(character: character ?? nil)) {
                            Image(systemName: "pencil")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        MiniStat(label: "STR", value: character?.stats?.strength ?? 0)
                        MiniStat(label: "DEX", value: character?.stats?.dexterity ?? 0)
                        MiniStat(label: "CON", value: character?.stats?.constitution ?? 0)
                        MiniStat(label: "INT", value: character?.stats?.intelligence ?? 0)
                        MiniStat(label: "WIS", value: character?.stats?.wisdom ?? 0)
                        MiniStat(label: "CHA", value: character?.stats?.charisma ?? 0)
                    }
                    
                    Divider()
                    
                    // MARK: - Skill Proficiencies
                    HStack {
                        Text("Skill Proficiencies")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .kerning(1)
                        Spacer()
                        NavigationLink(destination: ChangeSkillsView(character: character ?? nil)) {
                            Image(systemName: "pencil")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    let proficientSkills = (character?.skillProf as? Set<SkillProficiencies>)?
                        .filter { $0.isProficient }
                        .sorted { ($0.name ?? "") < ($1.name ?? "") } ?? []
                    
                    if proficientSkills.isEmpty {
                        Text("No proficiencies")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(Array(proficientSkills.enumerated()), id: \.element) { index, skill in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.primary.opacity(0.75))
                                        .frame(width: 7, height: 7)
                                    Text(skill.name ?? "—")
                                        .font(.subheadline)
                                    Spacer()
                                    Text("+\(character?.proficiencyBonus ?? 0)")
                                        .font(.system(size: 13, design: .monospaced))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 4)
                                
                                if index < proficientSkills.count - 1 {
                                    Divider().padding(.leading, 20)
                                }
                            }
                        }
                        .background(Color.primary.opacity(0.03))
                        .cornerRadius(10)
                    }
                    
                    Divider()
                    
                    // MARK: - Languages
                    HStack {
                        Text("Languages")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                            .kerning(1)
                        Spacer()
                        NavigationLink(destination: ChangeLanguagesView(character: character!)) {
                            Image(systemName: "pencil")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false){
                        FlowLayout(items: character?.languages ?? []) { lang in
                            Text(lang)
                                .font(.footnote)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.primary.opacity(0.06))
                                .cornerRadius(20)
                        }
                    }
                    
                    Divider()
                    
                    // MARK: - Quick Access
                    Text("Quick Access")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .kerning(1)
                    VStack(spacing: 12) {
                        NavigationLink(destination: SpellsView(character: character)) {
                            Label("Spells", systemImage: "sparkles")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.indigo.opacity(0.1))
                                .foregroundColor(.indigo)
                                .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: ItemsView(character: character)) {
                            Label("Items", systemImage: "bag.fill")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: NotesView(character: character)) {
                            Label("Notes", systemImage: "note.text")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.green.opacity(0.1))
                                .foregroundColor(.green)
                                .cornerRadius(12)
                        }
                        NavigationLink(
                            destination: Group {
                                if character?.campaign == nil {
                                    CreateCampaignView(character: character!, path: $path)
                                } else {
                                    QuestLogView(campaign: character!.campaign!)
                                }
                            }
                        ) {
                            Label("Campaign", systemImage: "map")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(12)
                        }
                    }
                    .padding(24)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        path = NavigationPath()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        UpdateCharacterView(character: character!)
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .navigationTitle(character?.name ?? "Overview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            NavigationLink(destination:LevelUpView(character: character!)){
                Image(systemName: "arrow.up")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.indigo)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
                .padding(24)
        }
    }
}

// MARK: - Subviews

struct OverviewRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }
}

struct MiniStat: View {
    let label: String
    let value: Int16
    
    var modifier: String {
        let mod = (Int(value) - 10) / 2
        return mod >= 0 ? "+\(mod)" : "\(mod)"
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.system(size: 20, weight: .semibold))
            Text(modifier)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .kerning(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.primary.opacity(0.04))
        .cornerRadius(10)
    }
}

struct FlowLayout<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self, content: content)
            }
        }
    }
}

struct StatCircle: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(Color(.systemGray6))
                .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1.5)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                        .overlay {
                            Text(value)
                                .font(.system(size: 10, weight: .heavy))
                                .foregroundColor(.black)
                                .offset(y: 1)
                        }
                }
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}
