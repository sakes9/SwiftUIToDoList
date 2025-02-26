import SwiftUI

/// ナビゲーションバーオプション
struct NavigationBarOptions {
    var title: String? // タイトル（オプショナル）
    let isVisible: Bool // ナビゲーションバーの表示判定
}

/// ナビゲーションバーモディファイア
private struct NavigationBarModifier: ViewModifier {
    let options: NavigationBarOptions // ナビゲーションバーオプション

    /// イニシャライザ
    /// - Parameter options: ナビゲーションバーオプション
    init(options: NavigationBarOptions) {
        self.options = options

        // ナビゲーションバーの外観を設定する
        setAppearance()
    }

    func body(content: Content) -> some View {
        let title = options.title ?? ""
        let isShowNavigationBar = options.isVisible

        content
            .navigationBarTitleDisplayMode(.inline) // タイトル表示モード
            .navigationTitle(title) // タイトル
            .navigationBarHidden(isShowNavigationBar ? false : true) // ナビゲーションバーの表示判定
    }

    /// ナビゲーションバーの外観設定
    private func setAppearance() {
        let navBarAppearance = UINavigationBarAppearance()

        // 背景色
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(named: "ThemeColor")

        // 下線の色
        navBarAppearance.shadowColor = .clear

        // タイトルの色
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        // 戻るボタンの文字色
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backButtonAppearance = backItemAppearance

        // 戻るボタンの画像
        let backButtonImage = UIImage(systemName: "chevron.backward")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        navBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)

        // 設定を適用
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
}

/// ビュー拡張
extension View {
    /// ナビゲーションバーの設定
    /// - Parameters:
    ///   - title: タイトル
    ///   - isVisible: ナビゲーションバーの表示判定
    /// - Returns: ナビゲーションバーが設定されたビュー
    func navigationBarSetting(title: String, isVisible: Bool) -> some View {
        modifier(NavigationBarModifier(options: .init(title: title, isVisible: isVisible)))
    }
}

#Preview {
    NavigationView {
        Text("Hello world!")
            .navigationBarSetting(title: "ホーム", isVisible: true)
    }
}
