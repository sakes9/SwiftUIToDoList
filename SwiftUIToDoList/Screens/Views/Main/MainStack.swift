import SwiftUI

/// メインスタック
struct MainStack: View {
    @State private var navigationPath: [NavigationItem] = []

    var body: some View {
        NavigationStack(path: $navigationPath) {
            // ホーム画面
            HomeView(navigationPath: $navigationPath)

                // 画面遷移定義
                .navigationDestination(for: NavigationItem.self) { item in
                    switch item.id {
                    // タブ管理画面
                    case .tabManage:
                        TabManageView()

                    default:
                        EmptyView()
                    }
                }
        }
    }
}

#Preview {
    MainStack()
}
