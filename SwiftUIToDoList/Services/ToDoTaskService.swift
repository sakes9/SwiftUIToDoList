import Foundation
import SwiftData

/// ToDoタスクサービス
@MainActor
class ToDoTaskService {
    private let modelContext: ModelContext? // モデルコンテキスト

    /// イニシャライザ
    init() {
        let modelContainer = SwiftDataService.shared.getModelContainer()
        self.modelContext = modelContainer.mainContext
    }
}

/// 外部公開メソッド
extension ToDoTaskService {
    /// タスクを追加する
    /// - Parameters:
    ///   - name: タスク名
    ///   - tabId: 関連づけるタブのID
    func add(name: String, tabId: UUID) throws {
        guard let modelContext else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContextの初期化に失敗しました"])
        }

        // 関連づけるタブを取得
        let fetchDescriptor = FetchDescriptor<ToDoTab>(predicate: #Predicate { $0.id == tabId })
        guard let toDoTab = try modelContext.fetch(fetchDescriptor).first else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "タブの取得に失敗しました"])
        }

        // タスクを追加
        let toDoTask = ToDoTask(id: UUID(),
                                todoTab: toDoTab,
                                name: name,
                                isCompleted: false,
                                createdAt: Date(),
                                updatedAt: nil)
        modelContext.insert(toDoTask)
        try modelContext.save() // 変更を即時に書き込む
    }
}
