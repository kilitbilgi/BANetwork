public struct BANetwork {
    public init() {
        guard let config = try? BAPlistUtils().getConfig() else {
            return
        }
        print(config.baseURL)
    }
}
