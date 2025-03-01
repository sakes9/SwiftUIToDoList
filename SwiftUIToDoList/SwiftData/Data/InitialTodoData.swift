import Foundation

/// 初期ToDoタスクデータ
/// タブ登録時のタブIDはデータベース追加時に生成されるIDを設定するため、この時点では nil を設定しておく。
@MainActor
let INITIAL_TODO_TASK_DATA: [[ToDoTask]] = [
    // 今日の予定
    [
        .init(id: UUID(), todoTab: nil, name: "美容室に行く", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "カフェでランチ", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "映画を見る", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "図書館で読書", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "カレーライスの材料を買う", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "晩御飯にカレーを作る", isCompleted: false, createdAt: Date(), updatedAt: nil)
    ],

    // 買うもの
    [
        .init(id: UUID(), todoTab: nil, name: "ヘッドフォン", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "USB", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "ボールペン", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "シャンプー", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "コップ", isCompleted: false, createdAt: Date(), updatedAt: nil),
    ],

    // やること
    [
        .init(id: UUID(), todoTab: nil, name: "京都旅行", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "車を買う", isCompleted: false, createdAt: Date(), updatedAt: nil)
    ],

    // 引越し
    [
        .init(id: UUID(), todoTab: nil, name: "賃貸住宅の解約", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "郵便物の転送手続き", isCompleted: false, createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), todoTab: nil, name: "転出届の提出", isCompleted: false, createdAt: Date(), updatedAt: nil)
    ]
]
