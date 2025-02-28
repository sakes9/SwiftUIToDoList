import Foundation
import SwiftData

/// ToDoタスクモデル
@Model
class ToDoTask {
    var id: UUID = UUID() // タスクID

    // タブが削除された際に、タブに紐づくタスクのタブ情報には null が設定される
    @Relationship(deleteRule: .nullify, inverse: \ToDoTab.todoTasks) var todoTab: ToDoTab? // タブのリレーション

    var name: String = "" // タスク名
    var isCompleted: Bool = false // 完了フラグ
    var createdAt: Date = Date() // 作成日時
    var updatedAt: Date? // 更新日時

    /// イニシャライザ
    init(id: UUID,
         todoTab: ToDoTab?,
         name: String,
         isCompleted: Bool,
         createdAt: Date,
         updatedAt: Date?) {
        self.id = id
        self.todoTab = todoTab
        self.name = name
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
