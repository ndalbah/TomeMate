//
//  Page2.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-02-28.
//
import SwiftUI

struct CharacterClassView: View {
    
    @StateObject var viewModel = ClassesViewModel()
    
    @Binding var formData: CharacterFormData
    @Binding var currentPage: Int
    @Binding var isDisabled: Bool
    
    @State private var selectedClass: ClassesModel? = nil
    @State private var sheetClass: ClassesModel? = nil
    @State private var showSheet: Bool = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()
            TomeParticlesView().opacity(0.4)

            VStack(spacing: 0) {
                Text("Choose your Calling")
                    .font(.custom("IMFellEnglish-Italic", size: 16))
                    .foregroundStyle(Color.tomeSepia)
                    .padding(.top, 24)

                Text("Class")
                    .font(.custom("Cinzel-Bold", size: 28))
                    .tracking(3)
                    .foregroundStyle(Color.tomeGold)
                    .shadow(color: Color.tomeGold.opacity(0.3), radius: 10)
                    .padding(.top, 4)

                TomeDecorativeRule()
                    .frame(maxWidth: 220)
                    .padding(.vertical, 16)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.classes) { classes in
                            ThemedClassCard(
                                classes: classes,
                                isSelected: selectedClass == classes
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selectedClass = classes
                                }
                                formData.charClass = classes
                                sheetClass = classes
                                showSheet = true
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear {
            selectedClass = formData.charClass
            isDisabled = formData.subclass == nil
        }
        
        .sheet(isPresented: $showSheet) {
            if let sheetClass {
                ThemedSubclassView(
                    selectedClass: sheetClass,
                    formData: $formData,
                    currentPage: $currentPage
                )
                .presentationDetents([.fraction(0.25)])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color.tomeBg)
            }
        }
    }
}

#Preview {
  //  Page2()
}


private struct ThemedClassCard: View {
    let classes: ClassesModel
    let isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(isSelected ? Color.tomeParchmentMid : Color.tomeParchmentLight)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(
                        isSelected ? Color.tomeCrimson : Color.tomeSepia.opacity(0.4),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .shadow(color: .black.opacity(isSelected ? 0.3 : 0.15), radius: isSelected ? 8 : 4, y: 3)
            .overlay {
                VStack(spacing: 4) {
                    Spacer()
                    Text(classes.name)
                        .font(.custom("Cinzel-Regular", size: 10))
                        .tracking(1)
                        .foregroundStyle(Color.tomeInk)
                        .multilineTextAlignment(.center)
                    Text(classes.primaryAbility)
                        .font(.custom("IMFellEnglish-Regular", size: 9))
                        .foregroundStyle(Color.tomeSepia)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .padding(8)
            }
            .frame(height: 80)
    }
}

// MARK: - Themed Subclass Sheet

private struct ThemedSubclassView: View {
    let selectedClass: ClassesModel
    @Binding var formData: CharacterFormData
    @Binding var currentPage: Int
    @StateObject var viewModel = SubclassesViewModel()
    @State private var selectedSubclass: SubclassModel? = nil
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Choose a Path")
                    .font(.custom("IMFellEnglish-Italic", size: 13))
                    .foregroundStyle(Color.tomeSepia)
                    .padding(.top, 16)

                Text(selectedClass.name)
                    .font(.custom("Cinzel-Bold", size: 18))
                    .tracking(2)
                    .foregroundStyle(Color.tomeGold)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.subclasses) { subclass in
                            let isActive = selectedSubclass == subclass
                            RoundedRectangle(cornerRadius: 3)
                                .fill(isActive ? Color.tomeParchmentMid : Color.tomeParchmentLight)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .strokeBorder(
                                            isActive ? Color.tomeCrimson : Color.tomeSepia.opacity(0.4),
                                            lineWidth: isActive ? 1.5 : 1
                                        )
                                )
                                .shadow(color: .black.opacity(isActive ? 0.3 : 0.1), radius: isActive ? 6 : 3, y: 2)
                                .overlay {
                                    Text(subclass.name)
                                        .font(.custom("Cinzel-Regular", size: 10))
                                        .tracking(0.8)
                                        .foregroundStyle(Color.tomeInk)
                                        .multilineTextAlignment(.center)
                                        .padding(8)
                                }
                                .frame(width: 110, height: 52)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        selectedSubclass = subclass
                                    }
                                    formData.subclass = subclass
                                    dismiss()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        currentPage += 1
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .onAppear {
            viewModel.fetchSubclasses(className: selectedClass.name)
        }
    }
}
