import SwiftUI

struct ChangeSkillsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: TomeMateHolder
    let character: Character?
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    @State var skills: [SkillProficiencies] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("Select your Skills")
                    .font(.title)
                    .bold()
                    .padding(.vertical, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(skills) { skill in
                            SkillsCard(skill: skill) {
                                skill.isProficient.toggle()
                            }
                        }
                    }
                    .padding(.bottom, 90)
                }
            }
            
            Button {
                holder.updateSkill(character: character!, skills: skills, context)
                dismiss()
            } label: {
                Text("Save Skills")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom, 20)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            )
        }
        .onAppear {
            skills = (character?.skillProf as? Set<SkillProficiencies>)?.sorted(by: { $0.name ?? "" < $1.name ?? "" }) ?? []
        }
    }
}

private struct SkillsCard: View {
    @ObservedObject var skill: SkillProficiencies
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text("\(skill.name ?? "") (\(skill.ability ?? ""))")
            Spacer()
            ZStack {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .frame(width: 20, height: 20)
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.blue)
                    .scaleEffect(skill.isProficient ? 1 : 0)
            }
        }
        .padding()
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    //ChangeSkillsView()
}
