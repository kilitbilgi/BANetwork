//
//  BAPlistUtils.swift
//
//
//  Created by Burak Colak on 18.03.2023.
//

import Foundation

public final class BAPlistUtils {
    func getConfig() -> BAPlistModel? {
        guard let path = Bundle.main.path(forResource: "BAConfig", ofType: "plist") else {
            throwFatalError(with: PropertyListSerializationError.fileNotFound)
            return nil
        }
        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)

            guard let plist = getList(with: data) else {
                throwFatalError(with: PropertyListSerializationError.fileNotParsed)
                return nil
            }

            return plist
        } catch {
            throwFatalError(with: PropertyListSerializationError.dataNotAvailable)
            return nil
        }
    }

    private func getList(with data: Data) -> BAPlistModel? {
        let decoder = PropertyListDecoder()
        do {
            let model = try decoder.decode(BAPlistModel.self, from: data)
            return model
        } catch {
            throwFatalError(with: PropertyListSerializationError.modelNotParsed)
            return nil
        }
    }

    private func throwFatalError(with error: PropertyListSerializationError) {
        fatalError(error.localizedDescription)
    }
}
