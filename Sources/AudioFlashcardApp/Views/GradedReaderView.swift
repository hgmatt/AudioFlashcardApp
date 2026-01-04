import SwiftUI

struct GradedReaderView: View {
    @EnvironmentObject var viewModel: GradedReaderViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    GroupBox("Artículo de entrada") {
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("URL opcional", text: $viewModel.sourceURL)
                                .textInputAutocapitalization(.never)
                                .textFieldStyle(.roundedBorder)
                            TextEditor(text: $viewModel.sourceText)
                                .frame(minHeight: 120)
                                .padding(6)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))

                            HStack {
                                Picker("Nivel", selection: $viewModel.selectedLevel) {
                                    ForEach(CEFRLevel.allCases) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                                .pickerStyle(.segmented)
                                Spacer()
                                Button("Reescribir") {
                                    viewModel.rewriteArticle()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            Text(viewModel.selectedLevel.guidance)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(4)
                    }

                    if !viewModel.rewrittenText.isEmpty {
                        GroupBox("Versión graduada en español") {
                            VStack(alignment: .leading, spacing: 12) {
                                underlinedText(viewModel.rewrittenText)
                                    .font(.body)

                                Divider()
                                Text("Toca palabras para subrayarlas y crear tarjetas. Solo se admite español.")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)

                                wordGrid

                                Button {
                                    viewModel.generateFlashcards()
                                } label: {
                                    Label("Crear tarjetas desde palabras subrayadas", systemImage: "rectangle.and.pencil.and.ellipsis")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }

                    if !viewModel.vocabularyCards.isEmpty {
                        GroupBox("Tarjetas generadas") {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.vocabularyCards) { card in
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(card.word.capitalized)
                                            .font(.headline)
                                        Text(card.translation)
                                            .foregroundStyle(.secondary)
                                        Text(card.context)
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.vertical, 6)
                                    Divider()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Lector graduado")
        }
    }

    private var wordGrid: some View {
        let words = viewModel.rewrittenText.split(separator: " ").map(String.init)
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
            ForEach(words, id: \.self) { word in
                let cleaned = word.trimmingCharacters(in: .punctuationCharacters)
                let isSelected = viewModel.selectedWords.contains(cleaned.lowercased())
                Button {
                    viewModel.toggleSelection(for: word)
                } label: {
                    Text(cleaned)
                        .underline(isSelected)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.gray.opacity(0.08))
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func underlinedText(_ text: String) -> Text {
        text
            .split(separator: " ")
            .map(String.init)
            .reduce(Text("")) { partialResult, word in
                let cleaned = word.trimmingCharacters(in: .punctuationCharacters)
                let isSelected = viewModel.selectedWords.contains(cleaned.lowercased())
                let spaced = Text(word + " ").underline(isSelected)
                return partialResult + spaced
            }
    }
}

struct GradedReaderView_Previews: PreviewProvider {
    static var previews: some View {
        GradedReaderView()
            .environmentObject(GradedReaderViewModel())
    }
}
