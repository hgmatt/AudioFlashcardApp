import Foundation

@MainActor
final class GradedReaderViewModel: ObservableObject {
    @Published var sourceURL: String = "https://example.com/articulo"
    @Published var sourceText: String = "En un pequeño pueblo, los estudiantes se reunían cada tarde para leer historias en voz alta."
    @Published var selectedLevel: CEFRLevel = .b1
    @Published private(set) var rewrittenText: String = ""
    @Published private(set) var selectedWords: Set<String> = []
    @Published private(set) var vocabularyCards: [VocabularyCard] = []

    private let dictionary: SpanishDictionary

    init(dictionary: SpanishDictionary = SpanishDictionary()) {
        self.dictionary = dictionary
    }

    func rewriteArticle() {
        let trimmed = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            rewrittenText = ""
            return
        }

        let simplifiedSentences = trimmed
            .split(separator: ".")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { sentence in
                let words = sentence.split(separator: " ")
                let limited = words.prefix(maxWords(for: selectedLevel))
                return limited.joined(separator: " ")
            }

        rewrittenText = "Nivel \(selectedLevel.rawValue): " + simplifiedSentences.joined(separator: ". ") + "."
        selectedWords = []
    }

    func toggleSelection(for word: String) {
        let cleaned = cleanedWord(word)
        guard !cleaned.isEmpty else { return }
        if selectedWords.contains(cleaned) {
            selectedWords.remove(cleaned)
        } else {
            selectedWords.insert(cleaned)
        }
    }

    func generateFlashcards() {
        let sentences = rewrittenText.split(separator: ".")
        vocabularyCards = selectedWords.sorted().map { word in
            let translation = dictionary.translate(word)
            let context = sentences.first { sentence in
                sentence.lowercased().contains(word.lowercased())
            }.map(String.init) ?? rewrittenText
            return VocabularyCard(word: word, translation: translation, context: context)
        }
    }

    private func maxWords(for level: CEFRLevel) -> Int {
        switch level {
        case .a1: return 6
        case .a2: return 10
        case .b1: return 14
        case .b2: return 18
        case .c1: return 24
        case .c2: return 32
        }
    }

    private func cleanedWord(_ word: String) -> String {
        word.lowercased().trimmingCharacters(in: .punctuationCharacters)
    }
}
