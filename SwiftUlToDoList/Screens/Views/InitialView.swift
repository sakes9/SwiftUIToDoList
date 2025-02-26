import SwiftUI

/// 起動画面
struct InitialView: View {
    @State private var isInitialized = false // 初期化フラグ

    var body: some View {
        ZStack {
            if isInitialized {
                MainStack()
            } else {
                Text("アプリ起動中...")
                    .padding()
            }
        }
        .onAppear {
            // 1秒後に初期化フラグを立てる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isInitialized = true
            }
        }
    }
}

#Preview {
    InitialView()
}
