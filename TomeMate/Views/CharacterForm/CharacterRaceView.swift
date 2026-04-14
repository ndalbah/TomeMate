import SwiftUI

struct CharacterRaceView: View {
    @StateObject var viewModel = RacesViewModel()
    
    @Binding var formData: CharacterFormData
    @Binding var currentPage: Int
    @Binding var isDisabled: Bool
    
    @State private var selectedRace: RaceModel? = nil
    @State private var sheetRace: RaceModel? = nil

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
                Text("Choose your Heritage")
                    .font(.custom("IMFellEnglish-Italic", size: 16))
                    .foregroundStyle(Color.tomeSepia)
                    .padding(.top, 24)

                Text("Race")
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
                        ForEach(viewModel.races) { race in
                            ThemedRaceCard(
                                race: race,
                                isSelected: selectedRace == race
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selectedRace = race
                                    formData.race = race
                                }
                                NetworkManager.shared.fetchSubraces(query: race.name) { result in
                                    if case .success(let subraces) = result, !subraces.isEmpty {
                                        sheetRace = race
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear {                         // moved here
            selectedRace = formData.race
            if formData.subrace == nil {
                isDisabled = true
            }
            else{
                isDisabled = false
            }
        }
        .sheet(item: $sheetRace) { selectedRace in
            SubraceView(selectedRace: selectedRace, formData: $formData, currentPage: $currentPage)
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
  //  Page2()
}


struct RaceCards: View {
    let race: RaceModel
    var selectedRace: RaceModel? = nil
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 130, height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedRace == race ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
            )
            .overlay {
                VStack(spacing: 6) {
                    Spacer()
                    Text(race.name)
                        .font(.headline)
                    Text(race.languages.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(8)
            }
            .padding(4)
    }
}

private struct ThemedRaceCard: View {
    let race: RaceModel
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
                    Text(race.name)
                        .font(.custom("Cinzel-Regular", size: 10))
                        .tracking(1)
                        .foregroundStyle(Color.tomeInk)
                        .multilineTextAlignment(.center)
                    Text(race.languages.joined(separator: ", "))
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


struct SubraceView: View {
    let selectedRace: RaceModel
    @Binding var formData: CharacterFormData
    @Binding var currentPage: Int
    @StateObject var viewModel = SubracesViewModel()
    @State private var selectedSubrace: SubraceModel? = nil
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.tomeBg.ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Choose a Lineage")
                    .font(.custom("IMFellEnglish-Italic", size: 13))
                    .foregroundStyle(Color.tomeSepia)
                    .padding(.top, 16)

                Text(selectedRace.name)
                    .font(.custom("Cinzel-Bold", size: 18))
                    .tracking(2)
                    .foregroundStyle(Color.tomeGold)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.subraces) { subrace in
                            let isActive = selectedSubrace == subrace
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
                                    Text(subrace.name)
                                        .font(.custom("Cinzel-Regular", size: 10))
                                        .tracking(0.8)
                                        .foregroundStyle(Color.tomeInk)
                                        .multilineTextAlignment(.center)
                                        .padding(8)
                                }
                                .frame(width: 110, height: 52)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        selectedSubrace = subrace
                                    }
                                    formData.subrace = subrace
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
            viewModel.fetchSubraces(raceName: selectedRace.name)
        }
    }
}
