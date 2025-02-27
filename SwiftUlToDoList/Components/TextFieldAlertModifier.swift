import SwiftUI

/// テキストフィールドアラートモディファイア
private struct TextFieldAlertModifier: ViewModifier {
    @Binding var isPresented: Bool // 表示状態
    let title: String // タイトル
    let message: String // メッセージ
    let placeholder: String // プレースホルダー
    var defaultText: String = "" // デフォルトテキスト
    let maxLength: Int // 最大文字数
    let onConfirm: (_ text: String) -> Void // OKボタンが押された時のアクション

    @State private var text: String = "" // テキスト

    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented, actions: {
                TextField(placeholder, text: $text)
                    .onChange(of: text, initial: false) { _, newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }

                Button("OK", action: {
                    onConfirm(text)
                    text = "" // テキストを初期化
                })
                .disabled(text.isEmpty || text.count > maxLength)

                Button("キャンセル", role: .cancel, action: {
                    text = "" // テキストを初期化
                })
            }, message: {
                Text(message)
            })
            .onChange(of: isPresented, initial: false) { _, newValue in
                if newValue {
                    // アラートが表示される時にテキストをデフォルト値で初期化
                    text = defaultText
                }
            }
    }
}

/// ビュー拡張
extension View {
    /// テキストフィールドアラート
    /// - Parameters:
    ///   - isPresented: アラートを表示するかどうか
    ///   - title: アラートのタイトル
    ///   - message: アラートのメッセージ
    ///   - placeholder: テキストフィールドのプレースホルダー
    ///   - defaultText: 初期テキスト
    ///   - maxLength: 最大文字数
    ///   - onConfirm: OKボタンが押されたときのアクション
    /// - Returns: 修飾されたビュー
    func textFieldAlert(isPresented: Binding<Bool>,
                        title: String,
                        message: String,
                        placeholder: String = "",
                        defaultText: String,
                        maxLength: Int = 50,
                        onConfirm: @escaping (_ text: String) -> Void) -> some View {
        modifier(TextFieldAlertModifier(isPresented: isPresented,
                                        title: title,
                                        message: message,
                                        placeholder: placeholder,
                                        defaultText: defaultText,
                                        maxLength: maxLength,
                                        onConfirm: onConfirm))
    }
}

#Preview {
    @Previewable @State var isPresented = false
    @Previewable @State var defaultText = ""

    Button("アラート表示") {
        defaultText = "タスク"
        isPresented.toggle()
    }
    .textFieldAlert(isPresented: $isPresented,
                    title: "タイトル",
                    message: "メッセージ",
                    placeholder: "プレースホルダー",
                    defaultText: defaultText,
                    maxLength: 10,
                    onConfirm: { _ in })
}
