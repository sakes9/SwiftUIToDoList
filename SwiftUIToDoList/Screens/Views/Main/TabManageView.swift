import SwiftData
import SwiftUI

/// タブ管理画面
struct TabManageView: View {
    @Query(sort: \ToDoTab.createdAt) private var toDoTabs: [ToDoTab] // タブリスト

    @State private var isAddTabPresented = false // タブ追加アラート表示判定
    @State private var isEditTabPresented = false // タブ修正アラート表示判定
    @State private var alertInfo: AlertInfo? // アラート情報
    @State private var selectedToDoTab: ToDoTab? // 選択されたタブ

    private let todoTabService = ToDoTabService() // ToDoタブサービス

    var body: some View {
        CustomList(items: toDoTabs, onDelete: onDeleteButtonTapped) { toDoTab in
            Text(toDoTab.name)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .contentShape(Rectangle()) // タップ領域を確保
                .onTapGesture {
                    selectedToDoTab = toDoTab
                    isEditTabPresented = true
                }
        }
        .contentMargins(.top, 30) // リスト上部の余白

        // ナビゲーションバー設定
        .navigationBarSetting(title: "タブ管理", isVisible: true)
        .navigationBarIconSetting(name: "plus", isEnabled: true, action: onTabAddIconTapped)

        // 画面スタイル
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BgColor"))

        // コンポーネント
        .textFieldAlert(isPresented: $isAddTabPresented,
                        title: "タブ追加",
                        message: "追加するタブ名を入力してください\n(20文字以内)",
                        placeholder: "例）勉強",
                        defaultText: "",
                        maxLength: 20,
                        onConfirm: addTab)
        .textFieldAlert(isPresented: $isEditTabPresented,
                        title: "タブ修正",
                        message: "修正するタブ名を入力してください\n(20文字以内)",
                        placeholder: "例）勉強",
                        defaultText: selectedToDoTab?.name ?? "",
                        maxLength: 20,
                        onConfirm: editTab)
        .customAlert(alertInfo: $alertInfo)
    }

    /// タブ追加アイコンタップ時
    private func onTabAddIconTapped() {
        isAddTabPresented = true
    }

    /// 削除ボタンタップ時
    /// - Parameter toDoTab: タブ
    private func onDeleteButtonTapped(toDoTab: ToDoTab) {
        do {
            try todoTabService.delete(tabId: toDoTab.id)
        } catch {
            alertInfo = .init(title: "エラー", message: "タブの削除に失敗しました")
        }
    }

    /// タブ追加
    /// - Parameter text: 入力テキスト
    private func addTab(text: String) {
        do {
            _ = try todoTabService.add(name: text)
        } catch {
            alertInfo = .init(title: "エラー", message: "タブの追加に失敗しました")
        }
    }

    /// タブ修正
    /// - Parameter text: 入力テキスト
    private func editTab(text: String) {
        guard let toDoTab = selectedToDoTab else {
            return
        }

        do {
            try todoTabService.edit(tabId: toDoTab.id, name: text)
        } catch {
            alertInfo = .init(title: "エラー", message: "タブの修正に失敗しました")
        }
    }
}

#Preview {
    NavigationView {
        TabManageView()
            .modelContainer(SwiftDataService.shared.getModelContainer())
    }
}
