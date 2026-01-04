import Foundation

public enum CEFRLevel: String, CaseIterable, Identifiable {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"
    case b2 = "B2"
    case c1 = "C1"
    case c2 = "C2"

    public var id: String { rawValue }

    public var guidance: String {
        switch self {
        case .a1: return "Frases muy simples y vocabulario cotidiano."
        case .a2: return "Frases frecuentes y lenguaje básico sobre la vida diaria."
        case .b1: return "Lenguaje directo con algunas ideas conectadas."
        case .b2: return "Texto claro con detalles y opiniones matizadas."
        case .c1: return "Texto complejo con matices y vocabulario amplio."
        case .c2: return "Nivel casi nativo con expresiones especializadas."
        }
    }
}

public struct VocabularyCard: Identifiable, Equatable {
    public let id = UUID()
    public let word: String
    public let translation: String
    public let context: String
}

public struct SpanishDictionary {
    private let fallbackTranslation = "(consulta necesaria)"
    private let quickLookup: [String: String] = [
        "gato": "cat",
        "perro": "dog",
        "hablar": "to speak",
        "leer": "to read",
        "escuchar": "to listen",
        "escribir": "to write",
        "correr": "to run",
        "caminar": "to walk",
        "comer": "to eat",
        "beber": "to drink",
        "ir": "to go",
        "ser": "to be",
        "estar": "to be (temporary)",
        "tener": "to have",
        "hacer": "to do / make",
        "decir": "to say",
        "poder": "to be able to",
        "querer": "to want",
        "necesitar": "to need"
    ]

    public init() {}

    public func translate(_ word: String) -> String {
        let cleaned = word.lowercased().trimmingCharacters(in: .punctuationCharacters)
        return quickLookup[cleaned] ?? fallbackTranslation
    }
}
