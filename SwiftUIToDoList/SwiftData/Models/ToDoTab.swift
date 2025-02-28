import Foundation
import SwiftData

/// ToDoタブモデル
@Model
class ToDoTab {
    var id: UUID = UUID() // タブID
    var name: String = "" // タブ名
    var todoTasks: [ToDoTask]? // タスクのリレーション
    var createdAt: Date = Date() // 作成日時
    var updatedAt: Date? // 更新日時

    /// イニシャライザ
    init(id: UUID,
         name: String,
         createdAt: Date,
         updatedAt: Date?) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
