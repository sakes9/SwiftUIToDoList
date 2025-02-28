import Foundation
import SwiftData

/// ToDoタブサービス
@MainActor
class ToDoTabService {
    private let modelContext: ModelContext? // モデルコンテキスト

    /// イニシャライザ
    init() {
        let modelContainer = SwiftDataService.shared.getModelContainer()
        self.modelContext = modelContainer.mainContext
    }
}

/// 外部公開メソッド
extension ToDoTabService {
    /// タブを追加する
    /// - Parameter name: タブ名
    func add(name: String) throws {
        guard let modelContext else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContextの初期化に失敗しました"])
        }

        let toDoTab = ToDoTab(id: UUID(),
                              name: name,
                              createdAt: Date(),
                              updatedAt: nil)

        modelContext.insert(toDoTab)
        try modelContext.save() // 変更を即時に書き込む
    }
}
