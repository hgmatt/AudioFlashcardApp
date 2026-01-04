import Foundation

#if canImport(Speech)
import Speech
import AVFoundation

@MainActor
final class SpeechRecognizer: ObservableObject {
    @Published var transcript: String = ""
    @Published var isRecording: Bool = false

    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-ES"))

    func startTranscribing() {
        guard !isRecording else { return }
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            guard authStatus == .authorized else { return }
            Task { await self?.startSession() }
        }
    }

    func stopTranscribing() {
        isRecording = false
        request?.endAudio()
        task?.cancel()
        audioEngine?.stop()
        request = nil
        task = nil
        audioEngine = nil
    }

    func resetTranscript() {
        transcript = ""
    }

    private func startSession() async {
        let audioEngine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true

        guard let recognizer, recognizer.isAvailable else { return }
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()

        isRecording = true
        task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            if let result {
                Task { @MainActor in
                    self?.transcript = result.bestTranscription.formattedString
                }
            }
            if error != nil {
                Task { @MainActor in self?.stopTranscribing() }
            }
        }

        self.audioEngine = audioEngine
        self.request = request
    }
}
#else
@MainActor
final class SpeechRecognizer: ObservableObject {
    @Published var transcript: String = "Speech recognition unavailable in this build"
    @Published var isRecording: Bool = false

    func startTranscribing() {}
    func stopTranscribing() {}
    func resetTranscript() {}
}
#endif
