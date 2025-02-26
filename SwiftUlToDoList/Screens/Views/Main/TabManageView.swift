import SwiftUI

/// タブ管理画面
struct TabManageView: View {
    var body: some View {
        VStack {
            Text("タブ管理画面")
        }
        // ナビゲーションバー設定
        .navigationBarSetting(title: "タブ管理", isVisible: true)

        // 画面スタイル
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BgColor"))
    }
}

#Preview {
    NavigationView {
        TabManageView()
    }
}
