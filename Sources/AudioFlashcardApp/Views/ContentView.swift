import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: FlashcardViewModel
    @State private var showingFilters = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                if let card = viewModel.currentCard {
                    FlashcardView(card: card)
                    controlStrip
                } else {
                    Text("No cards found for your filters.")
                        .foregroundStyle(.secondary)
                        .padding()
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Audio Flashcards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Mode", selection: $viewModel.mode) {
                        ForEach(CardMode.allCases) { mode in
                            Text(mode.description).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: viewModel.mode) { _, newValue in
                        viewModel.updateMode(newValue)
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                NavigationStack {
                    FilterView(filter: viewModel.filter) { newFilter in
                        viewModel.updateFilter { $0 = newFilter }
                    }
                }
                .presentationDetents([.medium, .large])
            }
        }
    }

    private var controlStrip: some View {
        HStack {
            Button(action: viewModel.goBack) {
                Label("Back", systemImage: "arrow.left")
            }
            .buttonStyle(.bordered)

            Spacer()

            Text("Card \(viewModel.currentIndex + 1) / \(max(viewModel.cards.count, 1))")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: viewModel.advance) {
                Label("Next", systemImage: "arrow.right")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FlashcardViewModel())
    }
}
