//
//  GenericCallbacks.swift
//

public struct GenericCallbacks {
    public typealias VoidCallback = (() -> ())?
    public typealias ErrorCallback = ((Error?) -> ())?
    public typealias InfoCallback = ((Bool?, Error?) -> ())?
}
