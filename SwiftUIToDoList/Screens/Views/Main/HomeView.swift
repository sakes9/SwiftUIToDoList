import SwiftData
import SwiftUI
import SwiftUITabView

// ホーム画面
struct HomeView: View {
    @Binding var navigationPath: [NavigationItem]

    @Query(sort: \ToDoTab.createdAt) private var toDoTabs: [ToDoTab] // タブリスト
    @Query(sort: \ToDoTask.createdAt) private var toDoTasks: [ToDoTask] // タスクリスト

    @State private var isAddTaskPresented = false // タスク追加アラート表示判定
    @State private var isEditTaskPresented = false // タスク修正アラート表示判定
    @State private var selectedTabIndex = 0 // 選択されたタブのインデックス
    @State private var alertInfo: AlertInfo? // アラート情報
    @State private var selectedTask: ToDoTask? // 選択されたタスク

    private let todoTaskService = ToDoTaskService() // ToDoタスクサービス

    var body: some View {
        VStack(spacing: 0) {
            TabBarView(selectedIndex: $selectedTabIndex,
                       titles: toDoTabs.map { $0.name },
                       selectedColor: Color("ThemeColor"))
            TabView(selection: $selectedTabIndex) {
                ForEach(toDoTabs.indices, id: \.self) { index in
                    // タブに紐づくタスクを抽出する
                    let tabId = toDoTabs[index].id
                    let filteredTasks = toDoTasks.filter { $0.todoTab?.id == tabId }

                    CustomList(items: filteredTasks, onDelete: onDeleteButtonTapped) { task in
                        ToDoListItem(
                            text: task.name,
                            isSelected: task.isCompleted,
                            action: { onCheckBoxTapped(task: task) }
                        )
                        .listRowInsets(EdgeInsets()) // 要素の余白を削除
                        .onTapGesture {
                            selectedTask = task
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
                        defaultText: selectedTask?.name ?? "",
                        maxLength: 50,
                        onConfirm: editTask)
        .customAlert(alertInfo: $alertInfo)

        // ライフサイクル
        .onAppear {
            // 選択されているタブのインデックスがタブリストの範囲外の場合は初期値に設定
            if selectedTabIndex >= toDoTabs.count {
                selectedTabIndex = 0
            }
        }
    }

    /// タブ管理アイコンタップ時
    private func onTabManageIconTapped() {
        navigationPath.append(.init(id: .tabManage))
    }

    /// タスク追加ボタンタップ時
    private func onTaskAddButtonTapped() {
        // タブが存在しない場合はアラートを表示して処理を中断
        if toDoTabs.isEmpty {
            alertInfo = .init(title: "確認", message: "はじめにタブを作成してください")
            return
        }

        isAddTaskPresented = true
    }

    /// 削除ボタンタップ時
    /// - Parameter task: タスク
    private func onDeleteButtonTapped(task: ToDoTask) {
        do {
            try todoTaskService.delete(taskId: task.id)
        } catch {
            alertInfo = .init(title: "エラー", message: "タスクの削除に失敗しました")
        }
    }

    /// チェックボックスタップ時
    /// - Parameter task: タスク
    private func onCheckBoxTapped(task: ToDoTask) {
        do {
            try todoTaskService.toggleCompletion(taskId: task.id)
        } catch {
            alertInfo = .init(title: "エラー", message: "タスクのチェックに失敗しました")
        }
    }

    /// タスク追加
    /// - Parameter text: 入力テキスト
    private func addTask(text: String) {
        do {
            let selectedTab = toDoTabs[selectedTabIndex]
            try todoTaskService.add(name: text, tabId: selectedTab.id)
        } catch {
            alertInfo = .init(title: "エラー", message: "タスクの追加に失敗しました")
        }
    }

    /// タスク修正
    /// - Parameter text: 入力テキスト
    private func editTask(text: String) {
        do {
            guard let task = selectedTask else { return }
            try todoTaskService.edit(taskId: task.id, name: text)
        } catch {
            alertInfo = .init(title: "エラー", message: "タスクの修正に失敗しました")
        }
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
