//
//  BaseResult.swift
//

public enum BaseResult<T, E> where E: Error {
    case success(T)
    case failure(E)
}
