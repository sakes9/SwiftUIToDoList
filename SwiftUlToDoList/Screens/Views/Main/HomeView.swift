import SwiftUI

// ホーム画面
struct HomeView: View {
    @Binding var navigationPath: [NavigationItem]

    var body: some View {
        VStack {
            ToDoListItem(text: "タスク１", isSelected: true, action: {})
            ToDoListItem(text: "タスク２", isSelected: false, action: {})
        }
        // ナビゲーションバー設定
        .navigationBarSetting(title: "ホーム", isVisible: true)
        .navigationBarIconSetting(name: "folder.fill", isEnabled: true, action: onTabManageIconTapped)

        // 画面スタイル
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BgColor"))

        // コンポーネント
        .floatingButton(iconName: "plus", action: onTaskAddButtonTapped)
    }

    /// タブ管理アイコンタップ時
    private func onTabManageIconTapped() {
        navigationPath.append(.init(id: .tabManage))
    }

    /// タスク追加ボタンタップ時
    private func onTaskAddButtonTapped() {
        print("タスク追加ボタンがタップされました")
    }
}

#Preview {
    NavigationView {
        HomeView(navigationPath: .constant([]))
    }
}
