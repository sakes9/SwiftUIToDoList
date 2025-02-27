import SwiftUI

// ホーム画面
struct HomeView: View {
    @Binding var navigationPath: [NavigationItem]

    @State private var isAddTaskPresented = false // タスク追加アラート表示判定
    @State private var isEditTaskPresented = false // タスク修正アラート表示判定

    // ダミーのToDoタスク構造体
    private struct DummyTodoTask: Identifiable {
        var id: UUID // ID
        var name: String // タスク名
        var isCompleted: Bool = false // ToDoの完了状態
    }

    // ダミーのToDoタスクリスト
    @State private var DUMMY_TODO_TASKS: [DummyTodoTask] = [
        .init(id: UUID(), name: "タスク1", isCompleted: true),
        .init(id: UUID(), name: "タスク2", isCompleted: false),
        .init(id: UUID(), name: "タスク3", isCompleted: false)
    ]

    var body: some View {
        CustomList(items: DUMMY_TODO_TASKS, onDelete: onDeleteButtonTapped) { task in
            ToDoListItem(text: task.name,
                         isSelected: task.isCompleted,
                         action: {
                             print("\(task.name) がタップされました")
                         })
                         .listRowInsets(EdgeInsets()) // 要素の余白を削除
                         .onTapGesture {
                             isEditTaskPresented = true
                         }
        }
        // ナビゲーションバー設定
        .navigationBarSetting(title: "ホーム", isVisible: true)
        .navigationBarIconSetting(name: "folder.fill", isEnabled: true, action: onTabManageIconTapped)

        // 画面スタイル
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BgColor"))

        // コンポーネント
        .floatingButton(iconName: "plus", action: onTaskAddButtonTapped)
        .textFieldAlert(isPresented: $isAddTaskPresented,
                        title: "ToDo追加",
                        message: "追加するタスク名を入力してください\n(50文字以内)",
                        placeholder: "例）アプリ開発",
                        defaultText: "",
                        maxLength: 50,
                        onConfirm: addTask)
        .textFieldAlert(isPresented: $isEditTaskPresented,
                        title: "ToDo修正",
                        message: "修正するタスク名を入力してください\n(50文字以内)",
                        placeholder: "例）アプリ開発",
                        defaultText: "タスク",
                        maxLength: 50,
                        onConfirm: editTask)
    }

    /// タブ管理アイコンタップ時
    private func onTabManageIconTapped() {
        navigationPath.append(.init(id: .tabManage))
    }

    /// タスク追加ボタンタップ時
    private func onTaskAddButtonTapped() {
        isAddTaskPresented = true
    }

    /// 削除ボタンタップ時
    /// - Parameter task: タスク
    private func onDeleteButtonTapped(task: DummyTodoTask) {
        DUMMY_TODO_TASKS.removeAll { $0.id == task.id }
    }

    /// タスク追加
    /// - Parameter text: 入力テキスト
    private func addTask(text: String) {
        print("タスク追加: \(text)")
    }

    /// タスク修正
    /// - Parameter text: 入力テキスト
    private func editTask(text: String) {
        print("タスク修正: \(text)")
    }
}

#Preview {
    NavigationView {
        HomeView(navigationPath: .constant([]))
    }
}
