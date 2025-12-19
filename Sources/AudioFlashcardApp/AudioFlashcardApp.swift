import SwiftUI

@main
struct AudioFlashcardApp: App {
    @StateObject private var viewModel = FlashcardViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
