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

    /// タブを修正する
    /// - Parameters:
    ///   - tabId: 修正対象のタブのID
    ///   - name: タブ名
    func edit(tabId: UUID, name: String) throws {
        guard let modelContext else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContextの初期化に失敗しました"])
        }

        // 修正対象のタブを取得する
        let fetchDescriptor = FetchDescriptor<ToDoTab>(predicate: #Predicate { $0.id == tabId })
        guard let fetchedToDoTab = try modelContext.fetch(fetchDescriptor).first else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "タブの取得に失敗しました"])
        }

        // タブ情報を修正する
        fetchedToDoTab.name = name
        fetchedToDoTab.updatedAt = Date()

        try modelContext.save() // 変更を即時に書き込む
    }

    /// タブを削除する
    /// - Parameters tabId: 削除対象のタブのID
    func delete(tabId: UUID) throws {
        guard let modelContext else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContextの初期化に失敗しました"])
        }

        // 削除対象のタブを取得する
        let fetchDescriptor = FetchDescriptor<ToDoTab>(predicate: #Predicate { $0.id == tabId })
        guard let fetchedToDoTab = try modelContext.fetch(fetchDescriptor).first else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "タブの取得に失敗しました"])
        }

        // タブに紐づくタスクも削除する
        if let tasks = fetchedToDoTab.todoTasks {
            for task in tasks {
                modelContext.delete(task)
            }
        }

        // タブを削除する
        modelContext.delete(fetchedToDoTab)
        try modelContext.save() // 変更を即時に書き込む
    }
}
