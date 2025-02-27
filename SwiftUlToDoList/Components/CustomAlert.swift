import SwiftUI

/// アラートボタン情報
struct AlertButton {
    let text: String // ボタン情報
    let action: () -> Void // ボタンタップ時のアクション
}

/// アラート情報
struct AlertInfo: Identifiable {
    let id = UUID() // 一意の識別子
    let title: String // タイトル
    let message: String // メッセージ
    var alertButton: AlertButton = .init(text: "OK", action: {}) // ボタン情報
    var isCancel = false // キャンセルボタン表示の有無
}

/// カスタムアラート モディファイア
struct CustomAlertModifier: ViewModifier {
    @Binding var alertInfo: AlertInfo?

    func body(content: Content) -> some View {
        content
            .alert(item: $alertInfo) { alertInfo in
                // キャンセルボタンを表示する場合
                if alertInfo.isCancel {
                    return Alert(
                        title: Text(alertInfo.title),
                        message: Text(alertInfo.message),
                        primaryButton: .default(Text(alertInfo.alertButton.text), action: alertInfo.alertButton.action),
                        secondaryButton: .cancel(Text("キャンセル"), action: {})
                    )
                }
                // キャンセルボタンを表示しない場合
                else {
                    return Alert(
                        title: Text(alertInfo.title),
                        message: Text(alertInfo.message),
                        dismissButton: .default(Text(alertInfo.alertButton.text), action: alertInfo.alertButton.action)
                    )
                }
            }
    }
}

/// ビュー拡張
extension View {
    /// カスタムアラート
    /// - Parameter alertInfo: アラート情報
    /// - Returns: カスタムアラートを付与したビュー
    func customAlert(alertInfo: Binding<AlertInfo?>) -> some View {
        modifier(CustomAlertModifier(alertInfo: alertInfo))
    }
}

#Preview {
    @Previewable @State var alertInfo: AlertInfo?

    VStack {
        Button(
            action: {
                alertInfo = .init(title: "エラー",
                                  message: "エラーが発生しました")
            },
            label: { Text("キャンセルなし") }
        )

        Button(
            action: {
                alertInfo = .init(title: "確認",
                                  message: "入力を完了しますか？",
                                  alertButton: .init(text: "完了", action: {}),
                                  isCancel: true)
            },
            label: { Text("キャンセルあり") }
        )
    }
    .customAlert(alertInfo: $alertInfo)
}
