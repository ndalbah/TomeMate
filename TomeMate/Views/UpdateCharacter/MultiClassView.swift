//
//  MultiClassView.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-10.
//
import SwiftUI

struct MultiClassView: View {
    let character: Character?
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: TomeMateHolder
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = ClassesViewModel()
    @State private var selectedClass: ClassesModel? = nil
    @State private var selectedSubclass: SubclassModel? = nil
    @State private var sheetClass: ClassesModel? = nil
    @State private var showSheet: Bool = false

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var canConfirm: Bool {
        selectedClass != nil && selectedSubclass != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Select your New Class")
                .font(.title2)
                .bold()
                .padding(.horizontal)
                .padding(.top)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.classes) { classes in
                        ClassCards(classes: classes, selectedClass: selectedClass)
                            .onTapGesture {
                                selectedClass = classes
                                selectedSubclass = nil
                                sheetClass = classes
                                showSheet = true
                            }
                            .padding()
                    }
                }
            }

            // MARK: - Selected summary
            if let cls = selectedClass {
                VStack(spacing: 4) {
                    Divider()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(cls.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            if let sub = selectedSubclass {
                                Text(sub.name)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("")
                                    .font(.caption)
                                    .foregroundStyle(.red.opacity(0.7))
                            }
                        }
                        Spacer()
                        Button {
                            sheetClass = cls
                            showSheet = true
                        } label: {
                            Text("Change Subclass")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }

            // MARK: - Confirm button
            Button {
                guard let cls = selectedClass, let sub = selectedSubclass, let character else { return }
                holder.multiclass(character: character, selectedClass: cls, selectedSubclass: sub, context)
                dismiss()
            } label: {
                Label("Confirm Multiclass", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(canConfirm ? Color.blue : Color(.systemGray4))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(!canConfirm)
            .padding()
        }
        .sheet(isPresented: $showSheet) {
            if let sheetClass {
                SubclassView(selectedClass: sheetClass, selectedSubclass: $selectedSubclass)
                    .presentationDetents([.fraction(0.25)])
                    .presentationDragIndicator(.visible)
            }
        }
        .navigationTitle("Multiclass")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - ClassCards
private struct ClassCards: View {
    let classes: ClassesModel
    var selectedClass: ClassesModel? = nil

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 100, height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedClass == classes ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .overlay {
                VStack(spacing: 6) {
                    Spacer()
                    Text(classes.name)
                        .font(.headline)
                    Text(classes.primaryAbility)
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(8)
            }
            .padding(4)
    }
}

// MARK: - SubclassView
private struct SubclassView: View {
    let selectedClass: ClassesModel
    @Binding var selectedSubclass: SubclassModel?
    @StateObject var viewModel = SubclassesViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select a Subclass")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.subclasses) { subclass in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                            .frame(width: 120, height: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedSubclass == subclass ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .overlay {
                                Text(subclass.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(4)
                            }
                            .onTapGesture {
                                selectedSubclass = subclass
                                dismiss()
                            }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear{
                viewModel.fetchSubclasses(className: selectedClass.name)
            }
        }
    }
}
