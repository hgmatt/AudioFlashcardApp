import Foundation

public enum CardMode: String, CaseIterable, Identifiable, Codable {
    case audioPrompt
    case writtenPrompt

    public var id: String { rawValue }

    public var description: String {
        switch self {
        case .audioPrompt: return "Audio response"
        case .writtenPrompt: return "Written response"
        }
    }
}

public struct Flashcard: Identifiable, Equatable {
    public let id = UUID()
    public let verb: Verb
    public let tense: Tense
    public let subject: SubjectPronoun
    public let mode: CardMode
    public let conjugatedForm: String

    public init(verb: Verb, tense: Tense, subject: SubjectPronoun, mode: CardMode, conjugatedForm: String) {
        self.verb = verb
        self.tense = tense
        self.subject = subject
        self.mode = mode
        self.conjugatedForm = conjugatedForm
    }
}

public struct VerbFilter: Equatable {
    public var selectedVerbs: Set<UUID> = []
    public var tenses: Set<Tense> = Set(Tense.allCases)
    public var subjects: Set<SubjectPronoun> = Set(SubjectPronoun.allCases)
    public var endings: Set<VerbEnding> = Set(VerbEnding.allCases)
    public var regularities: Set<VerbRegularity> = Set(VerbRegularity.allCases)
    public var disableVosotros: Bool = false {
        didSet {
            if disableVosotros {
                subjects.remove(.vosotros)
            } else {
                subjects.insert(.vosotros)
            }
        }
    }

    public init() {}
}
