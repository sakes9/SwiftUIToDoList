import SwiftUI

/// カスタムリスト
struct CustomList<T: Identifiable, Content: View>: View {
    let items: [T] // 要素
    let onDelete: (T) -> Void // 削除時のアクション
    let rowContent: (T) -> Content // 行のコンテンツを作成するクロージャ

    var body: some View {
        List {
            ForEach(items) { item in
                rowContent(item)
            }
            .onDelete(perform: onDelete)
        }
        .listStyle(PlainListStyle()) // シンプルなスタイルに設定
        .background(Color(.systemGray6))
    }

    /// 削除ボタンタップ時の処理
    /// - Parameter indexSet: インデックスセット
    private func onDelete(indexSet: IndexSet) {
        let item = items[indexSet.first!]
        onDelete(item)
    }
}
