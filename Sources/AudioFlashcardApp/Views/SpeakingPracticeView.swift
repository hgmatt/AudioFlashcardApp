import SwiftUI

struct SpeakingPracticeView: View {
    @EnvironmentObject var viewModel: FlashcardViewModel
    @StateObject private var speechRecognizer = SpeechRecognizer()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let card = viewModel.currentCard {
                    FlashcardView(card: card)
                    transcriptSection(for: card)
                    controlButtons
                } else {
                    Text("No hay tarjetas disponibles con los filtros actuales.")
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Práctica hablada")
            .onAppear {
                if viewModel.mode != .audioPrompt {
                    viewModel.updateMode(.audioPrompt)
                }
            }
        }
    }

    private func transcriptSection(for card: Flashcard) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Diga la respuesta en voz alta (español)", systemImage: "mic")
                .font(.headline)
            Text("Transcripción en vivo:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(speechRecognizer.transcript.isEmpty ? "(en espera de audio)" : speechRecognizer.transcript)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.08)))

            if !speechRecognizer.transcript.isEmpty {
                let isMatch = normalized(speechRecognizer.transcript).contains(normalized(card.conjugatedForm))
                HStack {
                    Image(systemName: isMatch ? "checkmark.circle.fill" : "xmark.circle")
                        .foregroundStyle(isMatch ? .green : .orange)
                    Text(isMatch ? "Coincidencia con la conjugación correcta" : "No coincide todavía")
                        .foregroundStyle(.secondary)
                }
                .font(.footnote)
            }
        }
    }

    private var controlButtons: some View {
        HStack {
            Button {
                if speechRecognizer.isRecording {
                    speechRecognizer.stopTranscribing()
                } else {
                    speechRecognizer.resetTranscript()
                    speechRecognizer.startTranscribing()
                }
            } label: {
                Label(speechRecognizer.isRecording ? "Detener" : "Grabar", systemImage: speechRecognizer.isRecording ? "stop.circle" : "mic.circle")
            }
            .buttonStyle(.borderedProminent)

            Button("Siguiente tarjeta") {
                speechRecognizer.stopTranscribing()
                viewModel.advance()
            }
            .buttonStyle(.bordered)
        }
    }

    private func normalized(_ text: String) -> String {
        text
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
}

struct SpeakingPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = FlashcardViewModel()
        SpeakingPracticeView()
            .environmentObject(vm)
    }
}
