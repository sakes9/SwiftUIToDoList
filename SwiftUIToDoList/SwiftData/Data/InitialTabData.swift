import Foundation

/// 初期ToDoタブデータ
@MainActor
let INITIAL_TODO_TAB_DATA: [ToDoTab] = [
    .init(id: UUID(), name: "今日の予定", createdAt: Date(), updatedAt: nil),
    .init(id: UUID(), name: "買うもの", createdAt: Date(), updatedAt: nil),
    .init(id: UUID(), name: "やること", createdAt: Date(), updatedAt: nil),
    .init(id: UUID(), name: "引越し", createdAt: Date(), updatedAt: nil)
]
