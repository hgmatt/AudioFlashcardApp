import Foundation

public enum ReviewGrade: String, CaseIterable, Identifiable {
    case forgot
    case hard
    case medium
    case easy

    public var id: String { rawValue }

    public var label: String {
        switch self {
        case .forgot: return "Forgot"
        case .hard: return "Hard"
        case .medium: return "Medium"
        case .easy: return "Easy"
        }
    }

    public var easeDelta: Double {
        switch self {
        case .forgot: return -0.4
        case .hard: return -0.2
        case .medium: return 0
        case .easy: return 0.2
        }
    }

    public var intervalMultiplier: Double {
        switch self {
        case .forgot: return 1
        case .hard: return 1.2
        case .medium: return 1.6
        case .easy: return 2.3
        }
    }
}

public struct ScheduledFlashcard: Identifiable {
    public let id: String
    public var card: Flashcard
    public var easeFactor: Double
    public var intervalDays: Int
    public var streak: Int
    public var dueDate: Date

    public init(card: Flashcard) {
        self.id = card.id
        self.card = card
        self.easeFactor = 2.5
        self.intervalDays = 0
        self.streak = 0
        self.dueDate = Date()
    }

    public mutating func apply(grade: ReviewGrade, now: Date = Date()) {
        let clampedEase = max(1.3, easeFactor + grade.easeDelta)
        easeFactor = clampedEase

        if grade == .forgot {
            streak = 0
            intervalDays = 1
        } else {
            streak += 1
            let baseInterval = max(intervalDays, 1)
            intervalDays = max(1, Int(Double(baseInterval) * grade.intervalMultiplier))
        }

        dueDate = Calendar.current.date(byAdding: .day, value: intervalDays, to: now) ?? now
    }
}
