import SwiftUI

/// タブ管理画面
struct TabManageView: View {
    @State private var isAddTabPresented = false // タブ追加アラート表示判定
    @State private var isEditTabPresented = false // タブ修正アラート表示判定

    var body: some View {
        VStack {
            Text("タブ管理画面")

            Text("タブ１")
                .onTapGesture {
                    isEditTabPresented = true
                }

            Text("タブ２")
                .onTapGesture {
                    isEditTabPresented = true
                }
        }
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
                        defaultText: "タブ",
                        maxLength: 20,
                        onConfirm: editTab)
    }

    /// タブ追加アイコンタップ時
    private func onTabAddIconTapped() {
        isAddTabPresented = true
    }

    /// タブ追加
    /// - Parameter text: 入力テキスト
    private func addTab(text: String) {
        print("タブ追加: \(text)")
    }

    /// タブ修正
    /// - Parameter text: 入力テキスト
    private func editTab(text: String) {
        print("タブ修正: \(text)")
    }
}

#Preview {
    NavigationView {
        TabManageView()
    }
}
