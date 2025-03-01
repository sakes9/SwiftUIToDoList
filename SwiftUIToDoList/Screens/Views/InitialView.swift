import SwiftUI

/// 起動画面
struct InitialView: View {
    @State private var screenMessage: String = "アプリ起動中..." // 画面メッセージ
    @State private var isInitialized = false // 初期化フラグ

    private let todoTabService = ToDoTabService() // ToDoタブサービス
    private let todoTaskService = ToDoTaskService() // ToDoタスクサービス

    var body: some View {
        ZStack {
            if isInitialized {
                MainStack()
            } else {
                Text(screenMessage)
                    .padding()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                do {
                    // タブとタスクのデータを取得
                    let toDoTabs = try todoTabService.getAll()
                    let toDoTasks = try todoTaskService.getAll()

                    // データが存在しない場合のみ初期化処理を実行
                    if toDoTabs.isEmpty && toDoTasks.isEmpty {
                        try initializeData()
                    }

                    // 初期化フラグを立てる
                    isInitialized = true

                } catch {
                    screenMessage = "アプリの起動に失敗しました。\nアプリを再起動してください。"
                }
            }
        }
    }

    /// 初期データの登録
    private func initializeData() throws {
        for (index, tab) in INITIAL_TODO_TAB_DATA.enumerated() {
            let addedTabId = try todoTabService.add(name: tab.name)

            for task in INITIAL_TODO_TASK_DATA[index] {
                try todoTaskService.add(name: task.name, tabId: addedTabId)
            }
        }
    }
}

#Preview {
    InitialView()
}
