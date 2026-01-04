import SwiftUI

struct RootView: View {
    @StateObject private var flashcardViewModel = FlashcardViewModel()
    @StateObject private var readerViewModel = GradedReaderViewModel()

    var body: some View {
        TabView {
            ContentView()
                .environmentObject(flashcardViewModel)
                .tabItem {
                    Label("Tarjetas", systemImage: "rectangle.stack")
                }

            GradedReaderView()
                .environmentObject(readerViewModel)
                .tabItem {
                    Label("Lector", systemImage: "book")
                }

            SpeakingPracticeView()
                .environmentObject(flashcardViewModel)
                .tabItem {
                    Label("Hablar", systemImage: "mic.circle")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
