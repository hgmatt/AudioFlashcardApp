import Foundation

public enum VerbEnding: String, Codable, CaseIterable, Identifiable {
    case ar = "-ar"
    case er = "-er"
    case ir = "-ir"
    case other

    public var id: String { rawValue }
}

public enum VerbRegularity: String, Codable, CaseIterable, Identifiable {
    case regular
    case irregular
    case stemChange = "stem-change"
    case spellingChange = "spelling-change"
    case highlyIrregular = "highly-irregular"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .regular: return "Regular"
        case .irregular: return "Irregular"
        case .stemChange: return "Stem change"
        case .spellingChange: return "Spelling change"
        case .highlyIrregular: return "Highly irregular"
        }
    }
}

public struct Verb: Identifiable, Codable, Hashable {
    public let id: UUID
    public let infinitive: String
    public let english: String
    public let ending: VerbEnding
    public let regularity: VerbRegularity
    public let highlyIrregular: Bool
    public let stemChange: String?
    public let spellingChange: String?
    public let notes: String?
    public let providedConjugations: [String: [String: String]]?

    public init(
        id: UUID = UUID(),
        infinitive: String,
        english: String,
        ending: VerbEnding,
        regularity: VerbRegularity,
        highlyIrregular: Bool,
        stemChange: String? = nil,
        spellingChange: String? = nil,
        notes: String? = nil,
        providedConjugations: [String: [String: String]]? = nil
    ) {
        self.id = id
        self.infinitive = infinitive
        self.english = english
        self.ending = ending
        self.regularity = regularity
        self.highlyIrregular = highlyIrregular
        self.stemChange = stemChange
        self.spellingChange = spellingChange
        self.notes = notes
        self.providedConjugations = providedConjugations
    }
}

public enum SubjectPronoun: String, CaseIterable, Identifiable, Codable {
    case yo, tú, usted, nosotros, vosotros, ustedes

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .yo: return "yo"
        case .tú: return "tú"
        case .usted: return "usted/él/ella"
        case .nosotros: return "nosotros"
        case .vosotros: return "vosotros"
        case .ustedes: return "ustedes/ellos"
        }
    }
}

public enum Tense: String, CaseIterable, Identifiable, Codable {
    case present
    case preterite
    case imperfect
    case future

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .present: return "Present"
        case .preterite: return "Preterite"
        case .imperfect: return "Imperfect"
        case .future: return "Future"
        }
    }
}
