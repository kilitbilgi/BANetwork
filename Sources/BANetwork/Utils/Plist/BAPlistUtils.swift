//
//  BAPlistUtils.swift
//  
//
//  Created by Burak Colak on 18.03.2023.
//

import Foundation

public final class BAPlistUtils {

    func getConfig() throws -> BAPlistModel? {
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist") else {
            throw PropertyListSerializationError.fileNotFound
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else {
            throw PropertyListSerializationError.dataNotAvailable
        }

        guard let plist = try? getList(with: data) else {
            throw PropertyListSerializationError.fileNotParsed
        }

        return plist
    }

    private func getList(with data: Data) throws -> BAPlistModel? {
        let decoder = PropertyListDecoder()
        guard let model = try? decoder.decode(BAPlistModel.self, from: data) else {
            throw PropertyListSerializationError.modelNotParsed
        }
        return model
    }

}
