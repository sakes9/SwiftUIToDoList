import SwiftUI

// ホーム画面
struct HomeView: View {
    @Binding var navigationPath: [NavigationItem]

    @State private var isAddTaskPresented = false // タスク追加アラート表示判定
    @State private var isEditTaskPresented = false // タスク修正アラート表示判定

    var body: some View {
        VStack {
            ToDoListItem(text: "タスク１", isSelected: true, action: {})
                .onTapGesture {
                    isEditTaskPresented = true
                }
            ToDoListItem(text: "タスク２", isSelected: false, action: {})
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
