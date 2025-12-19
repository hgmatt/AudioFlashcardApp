import Foundation

struct ConjugationGenerator {
    static func conjugate(_ verb: Verb, tense: Tense, subject: SubjectPronoun) -> String {
        if let provided = verb.providedConjugations?[tense.rawValue]?[subject.rawValue] {
            return provided
        }

        switch tense {
        case .present:
            return present(verb: verb, subject: subject)
        case .preterite:
            return preterite(verb: verb, subject: subject)
        case .imperfect:
            return imperfect(verb: verb, subject: subject)
        case .future:
            return future(verb: verb, subject: subject)
        }
    }

    private static func stem(for verb: Verb, withChange change: String?, subject: SubjectPronoun) -> String {
        let infinitive = verb.infinitive
        let baseStem: String
        switch verb.ending {
        case .ar, .er, .ir:
            baseStem = String(infinitive.dropLast(2))
        case .other:
            baseStem = infinitive
        }

        guard let change else { return baseStem }
        // Only handle simple e>ie / o>ue / e>i transformations for demo purposes.
        if subject == .nosotros || subject == .vosotros { return baseStem }
        if change.contains(">") {
            let parts = change.split(separator: ">")
            if parts.count == 2, let from = parts.first, let to = parts.last, let range = baseStem.range(of: String(from), options: [.backwards]) {
                var mutated = baseStem
                mutated.replaceSubrange(range, with: to)
                return mutated
            }
        }
        return baseStem
    }

    private static func present(verb: Verb, subject: SubjectPronoun) -> String {
        let endingsAR = ["yo": "o", "tú": "as", "usted": "a", "nosotros": "amos", "vosotros": "áis", "ustedes": "an"]
        let endingsER = ["yo": "o", "tú": "es", "usted": "e", "nosotros": "emos", "vosotros": "éis", "ustedes": "en"]
        let endingsIR = ["yo": "o", "tú": "es", "usted": "e", "nosotros": "imos", "vosotros": "ís", "ustedes": "en"]

        let stem = stem(for: verb, withChange: verb.stemChange, subject: subject)
        let endingSet: [String: String]
        switch verb.ending {
        case .ar: endingSet = endingsAR
        case .er: endingSet = endingsER
        case .ir: endingSet = endingsIR
        case .other: endingSet = endingsAR
        }
        let suffix = endingSet[subject.rawValue] ?? ""
        return stem + suffix
    }

    private static func preterite(verb: Verb, subject: SubjectPronoun) -> String {
        let endingsAR = ["yo": "é", "tú": "aste", "usted": "ó", "nosotros": "amos", "vosotros": "asteis", "ustedes": "aron"]
        let endingsERIR = ["yo": "í", "tú": "iste", "usted": "ió", "nosotros": "imos", "vosotros": "isteis", "ustedes": "ieron"]
        let stem = stem(for: verb, withChange: nil, subject: subject)
        let endingSet: [String: String]
        switch verb.ending {
        case .ar: endingSet = endingsAR
        case .er, .ir: endingSet = endingsERIR
        case .other: endingSet = endingsAR
        }
        let suffix = endingSet[subject.rawValue] ?? ""
        return stem + suffix
    }

    private static func imperfect(verb: Verb, subject: SubjectPronoun) -> String {
        let endingsAR = ["yo": "aba", "tú": "abas", "usted": "aba", "nosotros": "ábamos", "vosotros": "abais", "ustedes": "aban"]
        let endingsERIR = ["yo": "ía", "tú": "ías", "usted": "ía", "nosotros": "íamos", "vosotros": "íais", "ustedes": "ían"]
        let stem = stem(for: verb, withChange: nil, subject: subject)
        let endingSet: [String: String] = verb.ending == .ar ? endingsAR : endingsERIR
        let suffix = endingSet[subject.rawValue] ?? ""
        return stem + suffix
    }

    private static func future(verb: Verb, subject: SubjectPronoun) -> String {
        let endings = ["yo": "é", "tú": "ás", "usted": "á", "nosotros": "emos", "vosotros": "éis", "ustedes": "án"]
        let infinitive = verb.infinitive
        let suffix = endings[subject.rawValue] ?? ""
        return infinitive + suffix
    }
}
