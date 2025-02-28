import SwiftUI

@main
struct SwiftUIToDoListApp: App {
    let modelContainer = SwiftDataService.shared.getModelContainer() // モデルコンテナ

    var body: some Scene {
        WindowGroup {
            InitialView()
        }
        .modelContainer(modelContainer)
    }
}
