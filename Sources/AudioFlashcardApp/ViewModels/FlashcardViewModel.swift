import Foundation
import Combine

public final class FlashcardViewModel: ObservableObject {
    @Published public private(set) var cards: [Flashcard] = []
    @Published public private(set) var currentIndex: Int = 0
    @Published public var mode: CardMode = .audioPrompt
    @Published public var filter: VerbFilter

    private let repository: VerbRepository
    private var verbs: [Verb] = [] {
        didSet { rebuildCards() }
    }

    public init(repository: VerbRepository = VerbRepository(), initialMode: CardMode = .audioPrompt, filter: VerbFilter = VerbFilter()) {
        self.repository = repository
        self.mode = initialMode
        self.filter = filter
        loadVerbs()
    }

    public func loadVerbs() {
        verbs = repository.loadVerbs()
    }

    public func rebuildCards() {
        let filteredVerbs = verbs.filter { verb in
            (filter.selectedVerbs.isEmpty || filter.selectedVerbs.contains(verb.id)) &&
            filter.endings.contains(verb.ending) &&
            filter.regularities.contains(verb.regularity)
        }

        let subjects = filter.subjects
        let tenses = filter.tenses

        cards = filteredVerbs.flatMap { verb in
            tenses.flatMap { tense in
                subjects.map { subject in
                    let conjugated = ConjugationGenerator.conjugate(verb, tense: tense, subject: subject)
                    return Flashcard(verb: verb, tense: tense, subject: subject, mode: mode, conjugatedForm: conjugated)
                }
            }
        }
        currentIndex = 0
    }

    public func advance() {
        guard !cards.isEmpty else { return }
        currentIndex = (currentIndex + 1) % cards.count
    }

    public func goBack() {
        guard !cards.isEmpty else { return }
        currentIndex = (currentIndex - 1 + cards.count) % cards.count
    }

    public func updateMode(_ newMode: CardMode) {
        mode = newMode
        rebuildCards()
    }

    public func updateFilter(_ update: (inout VerbFilter) -> Void) {
        update(&filter)
        rebuildCards()
    }

    public var currentCard: Flashcard? {
        guard cards.indices.contains(currentIndex) else { return nil }
        return cards[currentIndex]
    }
}
