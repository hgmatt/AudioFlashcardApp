import Foundation

public final class VerbRepository {
    public init() {}

    public func loadVerbs() -> [Verb] {
        guard let url = Bundle.module.url(forResource: "verbs_top_1000", withExtension: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let rawVerbs = try decoder.decode([RawVerb].self, from: data)
            return rawVerbs.map { $0.toVerb() }
        } catch {
            print("Failed to load verbs: \(error)")
            return []
        }
    }
}

private struct RawVerb: Codable {
    let infinitive: String
    let english: String
    let ending: String
    let regularity: String
    let highlyIrregular: Bool
    let stemChange: String?
    let spellingChange: String?
    let notes: String?
    let providedConjugations: [String: [String: String]]?

    func toVerb() -> Verb {
        let endingType = VerbEnding(rawValue: ending) ?? .other
        let reg = VerbRegularity(rawValue: regularity) ?? .regular
        return Verb(
            infinitive: infinitive,
            english: english,
            ending: endingType,
            regularity: reg,
            highlyIrregular: highlyIrregular,
            stemChange: stemChange,
            spellingChange: spellingChange,
            notes: notes,
            providedConjugations: providedConjugations
        )
    }
}
