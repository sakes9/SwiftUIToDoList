import SwiftUI

/// フローティングボタン
private struct FloatingButton: View {
    let iconName: String // アイコン名
    let action: () -> Void // アクション

    var body: some View {
        Button(action: self.action) {
            Image(systemName: self.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .padding(20)
                .foregroundColor(.white)
                .background(Color("ThemeColor"))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
}

/// フローティングボタンモディファイア
private struct FloatingButtonModifier: ViewModifier {
    let iconName: String // アイコン名
    let action: () -> Void // アクション

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingButton(iconName: self.iconName, action: self.action)
                        .padding([.bottom, .trailing], 20)
                }
            }
        }
    }
}

/// ビュー拡張
extension View {
    /// フローティングボタン
    /// - Parameters:
    ///   - iconName: アイコン
    ///   - action: アクション
    /// - Returns: フローティングボタンを付与したビュー
    func floatingButton(iconName: String, action: @escaping () -> Void) -> some View {
        self.modifier(FloatingButtonModifier(iconName: iconName, action: action))
    }
}

#Preview {
    Text("Hello world!")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .floatingButton(iconName: "plus", action: {})
}
