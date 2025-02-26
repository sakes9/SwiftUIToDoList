import SwiftUI

// MARK: - 基本設定

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

// MARK: - アイコン

/// アイコンオプション
struct NavigationBarIconOptions {
    let name: String // アイコン名
    let isEnabled: Bool // 有効判定（true: 有効, false: 無効）
    let action: () -> Void // アクション
}

/// アイコンモディファイア
private struct NavigationBarIconModifier: ViewModifier {
    let options: NavigationBarIconOptions

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: options.action,
                           label: {
                               Image(systemName: options.name)
                                   .foregroundColor(options.isEnabled ? .white : .gray)
                           })
                           .disabled(!options.isEnabled)
                }
            }
    }
}

/// ビュー拡張
extension View {
    /// アイコンの設定
    /// - Parameters:
    ///   - name: アイコン名
    ///   - isEnabled: 有効判定
    ///   - action: アクション
    /// - Returns: アイコンが設定されたビュー
    func navigationBarIconSetting(name: String,
                                  isEnabled: Bool = true,
                                  action: @escaping () -> Void) -> some View {
        modifier(NavigationBarIconModifier(
            options: .init(name: name, isEnabled: isEnabled, action: action))
        )
    }
}

#Preview {
    NavigationView {
        Text("Hello world!")
            .navigationBarSetting(title: "ホーム", isVisible: true)
            .navigationBarIconSetting(name: "folder.fill", isEnabled: true, action: {})
    }
}
