import SwiftUI

struct FlashcardView: View {
    let card: Flashcard

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(card.verb.infinitive.capitalized)
                        .font(.title2.weight(.semibold))
                    Text(card.verb.english)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                badge(text: card.tense.displayName)
                badge(text: card.subject.displayName)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThickMaterial)
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .shadow(radius: 4)

                VStack(spacing: 8) {
                    switch card.mode {
                    case .audioPrompt:
                        Image(systemName: "waveform")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundStyle(.accentColor)
                        Text("Say the form aloud")
                            .font(.headline)
                        Text(prompt)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    case .writtenPrompt:
                        Text("Type or think the form")
                            .font(.headline)
                        Text(prompt)
                            .font(.title)
                    }

                    Divider().padding(.vertical, 4)
                    Text(card.conjugatedForm)
                        .font(.largeTitle.weight(.bold))
                }
                .padding()
            }

            if let notes = card.verb.notes, !notes.isEmpty {
                HStack {
                    Image(systemName: "info.circle")
                    Text(notes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
        }
    }

    private var prompt: String {
        let base = "Conjugate \(card.verb.infinitive) for \(card.subject.displayName) in the \(card.tense.displayName.lowercased())"
        switch card.mode {
        case .audioPrompt:
            return base + ", then speak it."
        case .writtenPrompt:
            return base + "."
        }
    }

    private func badge(text: String) -> some View {
        Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.accentColor.opacity(0.12)))
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        let verb = Verb(
            infinitive: "hablar",
            english: "to speak",
            ending: .ar,
            regularity: .regular,
            highlyIrregular: false
        )
        let card = Flashcard(verb: verb, tense: .present, subject: .yo, mode: .audioPrompt, conjugatedForm: "hablo")
        FlashcardView(card: card)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
