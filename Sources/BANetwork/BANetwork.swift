public struct BANetwork {
    public init() throws {
        do {
            let config = try BAPlistUtils().getConfig()
            print(config.baseURL)
        } catch {
            throw PropertyListSerializationError.configNotLoaded
        }
    }
}
