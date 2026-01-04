import Foundation
import Combine

public final class FlashcardViewModel: ObservableObject {
    @Published public private(set) var schedule: [ScheduledFlashcard] = []
    @Published public private(set) var currentIndex: Int = 0
    @Published public var mode: CardMode = .audioPrompt
    @Published public var filter: VerbFilter
    @Published public private(set) var dueTodayCount: Int = 0

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

        let baseCards = filteredVerbs.flatMap { verb in
            tenses.flatMap { tense in
                subjects.map { subject in
                    let conjugated = ConjugationGenerator.conjugate(verb, tense: tense, subject: subject)
                    return Flashcard(verb: verb, tense: tense, subject: subject, mode: mode, conjugatedForm: conjugated)
                }
            }
        }
        schedule = baseCards.map { card in
            if let existing = schedule.first(where: { $0.card.id == card.id }) {
                var updated = existing
                updated.card = card
                return updated
            }
            return ScheduledFlashcard(card: card)
        }
        schedule.sort { $0.dueDate < $1.dueDate }
        currentIndex = 0
        refreshDueCounts()
    }

    public func advance() {
        guard !schedule.isEmpty else { return }
        currentIndex = (currentIndex + 1) % schedule.count
    }

    public func goBack() {
        guard !schedule.isEmpty else { return }
        currentIndex = (currentIndex - 1 + schedule.count) % schedule.count
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
        guard schedule.indices.contains(currentIndex) else { return nil }
        return schedule[currentIndex].card
    }

    public func reviewCurrentCard(_ grade: ReviewGrade) {
        guard schedule.indices.contains(currentIndex) else { return }
        var cardState = schedule[currentIndex]
        cardState.apply(grade: grade)
        schedule[currentIndex] = cardState
        schedule.sort { $0.dueDate < $1.dueDate }
        refreshDueCounts()
    }

    private func refreshDueCounts() {
        let today = Calendar.current.startOfDay(for: Date())
        dueTodayCount = schedule.filter { Calendar.current.startOfDay(for: $0.dueDate) <= today }.count
    }
}
