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
    /// 全てのタスクを取得する
    /// - Returns: 全てのタスク
    func getAll() throws -> [ToDoTask] {
        guard let modelContext else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContextの初期化に失敗しました"])
        }

        let fetchDescriptor = FetchDescriptor<ToDoTask>()
        let toDoTasks = try modelContext.fetch(fetchDescriptor)

        return toDoTasks
    }

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

    /// タスクを修正する
    /// - Parameters:
    ///   - taskId: 修正対象のタスクのID
    ///   - name: タスク名
    func edit(taskId: UUID, name: String) throws {
        guard let modelContext else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContextの初期化に失敗しました"])
        }

        // 修正対象のタスクを取得する
        let fetchDescriptor = FetchDescriptor<ToDoTask>(predicate: #Predicate { $0.id == taskId })
        guard let toDoTask = try modelContext.fetch(fetchDescriptor).first else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "タスクの取得に失敗しました"])
        }

        // タスク情報を修正する
        toDoTask.name = name
        toDoTask.updatedAt = Date()

        try modelContext.save() // 変更を即時に書き込む
    }

    /// タスクを削除する
    /// - Parameter taskId: 削除対象のタスクのID
    func delete(taskId: UUID) throws {
        guard let modelContext else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContextの初期化に失敗しました"])
        }

        // 削除対象のタスクを取得する
        let fetchDescriptor = FetchDescriptor<ToDoTask>(predicate: #Predicate { $0.id == taskId })
        guard let toDoTask = try modelContext.fetch(fetchDescriptor).first else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "タスクの取得に失敗しました"])
        }

        // タスクを削除
        modelContext.delete(toDoTask)
        try modelContext.save() // 変更を即時に書き込む
    }

    /// タスクの完了フラグを反転させる
    /// - Parameter taskId: 完了フラグを反転させるタスクのID
    func toggleCompletion(taskId: UUID) throws {
        guard let modelContext else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "ModelContextの初期化に失敗しました"])
        }

        // 更新対象のタスクを取得する
        let fetchDescriptor = FetchDescriptor<ToDoTask>(predicate: #Predicate { $0.id == taskId })
        guard let toDoTask = try modelContext.fetch(fetchDescriptor).first else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "タスクの取得に失敗しました"])
        }

        // タスクの完了フラグを反転させる
        toDoTask.isCompleted.toggle()
        toDoTask.updatedAt = Date()

        try modelContext.save() // 変更を即時に書き込む
    }
}
