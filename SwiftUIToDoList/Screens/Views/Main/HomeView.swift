import SwiftData
import SwiftUI
import SwiftUITabView

// ホーム画面
struct HomeView: View {
    @Binding var navigationPath: [NavigationItem]

    @Query(sort: \ToDoTab.createdAt) private var toDoTabs: [ToDoTab] // タブリスト

    @State private var isAddTaskPresented = false // タスク追加アラート表示判定
    @State private var isEditTaskPresented = false // タスク修正アラート表示判定
    @State private var selectedTabIndex = 0 // 選択されたタブのインデックス

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
        VStack(spacing: 0) {
            TabBarView(selectedIndex: $selectedTabIndex,
                       titles: toDoTabs.map { $0.name },
                       selectedColor: Color("ThemeColor"))
            TabView(selection: $selectedTabIndex) {
                ForEach(toDoTabs.indices, id: \.self) { _ in
                    CustomList(items: DUMMY_TODO_TASKS, onDelete: onDeleteButtonTapped) { task in
                        ToDoListItem(
                            text: task.name,
                            isSelected: task.isCompleted,
                            action: {
                                print("\(task.name) がタップされました")
                            }
                        )
                        .listRowInsets(EdgeInsets()) // 要素の余白を削除
                        .onTapGesture {
                            isEditTaskPresented = true
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear {
                // リストのスワイプ削除とタブビューのスワイプページングのジェスチャーが競合するため、
                // タブビューのスクロール機能を無効化して、タブビューのスワイプページングを無効にする。
                UIScrollView.appearance().isScrollEnabled = false
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
    let TODO_TAB_DATA: [ToDoTab] = [
        .init(id: UUID(), name: "今日の予定", createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), name: "買うもの", createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), name: "やること", createdAt: Date(), updatedAt: nil),
        .init(id: UUID(), name: "引越し", createdAt: Date(), updatedAt: nil)
    ]

    let todoTabService = ToDoTabService()

    NavigationView {
        HomeView(navigationPath: .constant([]))
            .modelContainer(SwiftDataService.shared.getModelContainer())
    }
    .onAppear {
        for tab in TODO_TAB_DATA {
            try? todoTabService.add(name: tab.name)
        }
    }
}
