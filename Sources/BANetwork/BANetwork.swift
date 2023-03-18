public struct BANetwork {
    public init() {
        if let config = BAPlistUtils().getConfig() {
            print(config.baseURL)
        }
    }
}
