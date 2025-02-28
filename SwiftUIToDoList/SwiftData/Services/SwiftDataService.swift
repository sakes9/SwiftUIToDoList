import SwiftData
import SwiftUI

/// SwiftDataサービス
/// Swift6からは、シングルトンクラスに@MainActor属性を付与しないと、スレッドセーフではないというエラーになるため、
/// このクラスに@MainActor属性を付与しています。
@MainActor
class SwiftDataService {
    static let shared = SwiftDataService() // シングルトン
    private let modelContainer: ModelContainer // モデルコンテナ

    /// イニシャライザ
    private init() {
        do {
            // SQLiteファイルのURLを取得
            let sqliteURL = try SwiftDataService.getSQLiteURL()

            // Schemaでデータモデルを指定
            let schema = Schema([ToDoTab.self, ToDoTask.self])

            // Schema と SQLiteファイルのURLを指定して ModelConfiguration を作成
            // プレビュー時は inMemory, 実機では SQLite
            let modelConfiguration = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
                ? ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                : ModelConfiguration(schema: schema, url: sqliteURL)

            // ModelContainer を作成
            let modelContainer = try ModelContainer(for: schema, configurations: modelConfiguration)
            self.modelContainer = modelContainer

        } catch {
            fatalError("SwiftDataServiceの初期化に失敗しました: \(error)")
        }
    }

    /// SQLiteファイルのURLを取得
    /// - Returns: SQLiteファイルのURL
    private static func getSQLiteURL() throws -> URL {
        guard let projectName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String else {
            throw NSError(domain: "SwiftDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "プロジェクト名の取得に失敗しました"])
        }

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sqliteURL = documentsURL.appendingPathComponent("\(projectName).sqlite")
        return sqliteURL
    }
}

/// 外部公開メソッド
extension SwiftDataService {
    /// モデルコンテナを取得する
    /// - Returns: モデルコンテナ
    func getModelContainer() -> ModelContainer {
        return modelContainer
    }
}
