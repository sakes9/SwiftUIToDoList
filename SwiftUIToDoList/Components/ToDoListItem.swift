import SwiftUI

/// ToDoリストアイテム
struct ToDoListItem: View {
    let text: String // テキスト
    let isSelected: Bool // チェック状態
    let action: () -> Void // アクション

    var body: some View {
        HStack(spacing: 10) {
            // チェックボックスアイコン
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundColor(isSelected ? Color("ThemeColor") : .gray)
                .onTapGesture(perform: action)

            // テキスト
            if isSelected {
                Text(text)
                    .font(.system(size: 16))
                    .strikethrough() // テキストに取り消し線をつける
            } else {
                Text(text)
                    .font(.system(size: 16))
            }

            Spacer()
        }
        .frame(minHeight: 42)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
    }
}

#Preview {
    VStack {
        ToDoListItem(text: "タスク１", isSelected: true, action: {})
        ToDoListItem(text: "タスク２", isSelected: false, action: {})
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGray6))
}
