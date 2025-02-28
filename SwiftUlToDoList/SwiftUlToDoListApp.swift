import SwiftUI

@main
struct SwiftUlToDoListApp: App {
    let modelContainer = SwiftDataService.shared.getModelContainer() // モデルコンテナ

    var body: some Scene {
        WindowGroup {
            InitialView()
        }
        .modelContainer(modelContainer)
    }
}
