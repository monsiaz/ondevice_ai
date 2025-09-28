import Foundation

extension Notification.Name {
    static let modelsDidChange = Notification.Name("ModelsDidChange")
}

struct LocalModel: Identifiable, Codable, Equatable {
    let id: UUID
    let displayName: String
    let folderName: String
    let isVision: Bool
    let contextLength: Int

    init(displayName: String, folderName: String, isVision: Bool = false, contextLength: Int = 2048) {
        self.id = UUID()
        self.displayName = displayName
        self.folderName = folderName
        self.isVision = isVision
        self.contextLength = contextLength
    }
}

enum ModelManagerError: Error { case directory, notFound }

final class ModelManager {
    static let shared = ModelManager()
    private init() {}

    private var baseURL: URL {
        let url = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let models = url.appendingPathComponent("Models", isDirectory: true)
        try? FileManager.default.createDirectory(at: models, withIntermediateDirectories: true)
        return models
    }

    func url(for model: LocalModel) -> URL { baseURL.appendingPathComponent(model.folderName, isDirectory: true) }

    func ensure(model: LocalModel) throws -> URL {
        let dir = url(for: model)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    func listInstalled() -> [LocalModel] {
        let fm = FileManager.default
        guard let items = try? fm.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil) else { return [] }
        return items.map { LocalModel(displayName: $0.lastPathComponent, folderName: $0.lastPathComponent) }
    }
    
    func bestDefaultModel() -> AvailableModel? {
        return AvailableModel.catalog.first(where: { $0.isRecommended })
    }

    // Copy a bundled model folder into the writable Models directory on first launch
    func installBundledModelIfNeeded(folderName: String, displayName: String? = nil) {
        let target = url(for: LocalModel(displayName: displayName ?? folderName, folderName: folderName))
        if FileManager.default.fileExists(atPath: target.path) { return }
        guard let source = Bundle.main.url(forResource: folderName, withExtension: nil) else { return }
        do {
            try FileManager.default.createDirectory(at: baseURL, withIntermediateDirectories: true)
            // If destination exists partially, remove it before copy
            if FileManager.default.fileExists(atPath: target.path) {
                try FileManager.default.removeItem(at: target)
            }
            try FileManager.default.copyItem(at: source, to: target)
            print("📦 Installed bundled model at \(target.path)")
        } catch {
            print("⚠️ Failed to install bundled model: \(error)")
        }
    }

    func deleteInstalled(folderName: String) {
        let dir = url(for: LocalModel(displayName: folderName, folderName: folderName))
        do {
            if FileManager.default.fileExists(atPath: dir.path) {
                try FileManager.default.removeItem(at: dir)
                print("🗑️ Removed model at \(dir.path)")
                NotificationCenter.default.post(name: .modelsDidChange, object: nil)
            }
        } catch {
            print("⚠️ Failed to remove model: \(error)")
        }
    }

    func modelExists(folderName: String) -> Bool {
        let dir = url(for: LocalModel(displayName: folderName, folderName: folderName))
        return FileManager.default.fileExists(atPath: dir.path)
    }

    func clearAll() {
        let fm = FileManager.default
        do {
            let items = try fm.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil)
            for item in items { try? fm.removeItem(at: item) }
            NotificationCenter.default.post(name: .modelsDidChange, object: nil)
        } catch {
            print("⚠️ Failed to clear models: \(error)")
        }
    }
}
