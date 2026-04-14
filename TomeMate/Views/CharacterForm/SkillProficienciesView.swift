//
//  Page5.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//

import SwiftUI

struct SkillProficienciesView: View {
    @Binding var formData: CharacterFormData
    @Binding var isDisabled: Bool
    @StateObject var viewModel = SkillsViewModel()
    @State var skills: [SkillsModel] = []
    @State var manualSelections: Set<String> = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    func applyProficiencies(_ skillList: [SkillsModel]) -> [SkillsModel] {
        skillList.map { skill in
            var s = skill
            let isBackgroundProficient = formData.background.skillProficiencies
                .map({ $0.lowercased().trimmingCharacters(in: .whitespaces) })
                .contains(skill.name.lowercased().trimmingCharacters(in: .whitespaces))
            s.isProficient = manualSelections.contains(skill.name) || isBackgroundProficient
            return s
        }
    }

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView().opacity(0.4)
            
            VStack(spacing: 0) {
                Text("Hone your Expertise")
                    .font(.custom("IMFellEnglish-Italic", size: 16))
                    .foregroundStyle(Color.tomeSepia)
                    .padding(.top, 24)
                
                Text("Skills")
                    .font(.custom("Cinzel-Bold", size: 28))
                    .tracking(3)
                    .foregroundStyle(Color.tomeGold)
                    .shadow(color: Color.tomeGold.opacity(0.3), radius: 10)
                    .padding(.top, 4)
                
                TomeDecorativeRule()
                    .frame(maxWidth: 220)
                    .padding(.vertical, 16)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach($skills) { $skill in
                            ThemedSkillCard(skill: $skill, formData: $formData) {
                                if manualSelections.contains(skill.name) {
                                    manualSelections.remove(skill.name)
                                } else {
                                    manualSelections.insert(skill.name)
                                }
                                skills = applyProficiencies(skills)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .onDisappear {
            formData.skills = skills
        }
        .onAppear {
            isDisabled = false
            let backgroundProficiencies = formData.background.skillProficiencies
                .map { $0.lowercased().trimmingCharacters(in: .whitespaces) }
            if !formData.skills.isEmpty {
                manualSelections = Set(
                    formData.skills
                        .filter { skill in
                            skill.isProficient &&
                            !backgroundProficiencies.contains(
                                skill.name.lowercased().trimmingCharacters(in: .whitespaces)
                            )
                        }
                        .map { $0.name }
                )
                skills = applyProficiencies(formData.skills)
            } else {
                viewModel.fetchSkills()
            }
        }
        .onChange(of: viewModel.skills) { newSkills in
            skills = applyProficiencies(newSkills)
        }
        .onChange(of: formData.background.skillProficiencies) { _ in
            formData.skills.removeAll()
            skills = applyProficiencies(skills)
        }
    }
}

// MARK: - Themed Skill Card

private struct ThemedSkillCard: View {
    @Binding var skill: SkillsModel
    @Binding var formData: CharacterFormData
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(skill.name)
                    .font(.custom("Cinzel-Regular", size: 11))
                    .tracking(0.5)
                    .foregroundStyle(Color.tomeInk)
                Text(skill.ability)
                    .font(.custom("IMFellEnglish-Regular", size: 10))
                    .foregroundStyle(Color.tomeSepia)
            }
            Spacer()
            
            // Proficiency pip
            ZStack {
                Circle()
                    .strokeBorder(
                        skill.isProficient ? Color.tomeCrimson : Color.tomeSepia.opacity(0.5),
                        lineWidth: 1.5
                    )
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(Color.tomeCrimson)
                    .frame(width: 12, height: 12)
                    .scaleEffect(skill.isProficient ? 1 : 0)
                    .animation(.spring(response: 0.25, dampingFraction: 0.6), value: skill.isProficient)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 3)
                .fill(skill.isProficient ? Color.tomeParchmentMid : Color.tomeParchmentLight)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .strokeBorder(
                            skill.isProficient ? Color.tomeCrimson : Color.tomeSepia.opacity(0.4),
                            lineWidth: skill.isProficient ? 1.5 : 1
                        )
                )
        )
        .shadow(color: .black.opacity(skill.isProficient ? 0.25 : 0.1), radius: skill.isProficient ? 6 : 3, y: 2)
        .animation(.easeInOut(duration: 0.15), value: skill.isProficient)
        .onTapGesture { onTap() }
    }
}
