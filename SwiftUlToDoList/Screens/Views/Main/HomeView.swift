import SwiftUI

// ホーム画面
struct HomeView: View {
    @Binding var navigationPath: [NavigationItem]

    var body: some View {
        Text("ホーム画面")

        Button(action: onTabManageIconTapped) {
            Text("タブ管理アイコン")
        }
    }

    /// タブ管理アイコンタップ時
    private func onTabManageIconTapped() {
        navigationPath.append(.init(id: .tabManage))
    }
}

#Preview {
    HomeView(navigationPath: .constant([]))
}
