//
//  BAPlistUtils.swift
//

import Foundation

final class BAPlistUtils {
    static let shared = BAPlistUtils()

    var config: BAPlistModel? {
        guard let path = Bundle.main.path(forResource: PListContants.fileName, ofType: PListContants.fileExtension) else {
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
        } catch let DecodingError.dataCorrupted(context) {
            throwFatalError(with: PropertyListSerializationError.dataCorrupted(context: context))
            return nil
        } catch let DecodingError.keyNotFound(key, context) {
            throwFatalError(with: PropertyListSerializationError.keyNotFound(key: key, context: context))
            return nil
        } catch let DecodingError.valueNotFound(value, context) {
            throwFatalError(with: PropertyListSerializationError.valueNotFound(value: value, context: context))
            return nil
        } catch let DecodingError.typeMismatch(type, context) {
            throwFatalError(with: PropertyListSerializationError.typeMismatch(type: type, context: context))
            return nil
        } catch {
            throwFatalError(with: PropertyListSerializationError.modelNotParsed)
            return nil
        }
    }

    private func throwFatalError(with error: PropertyListSerializationError) {
        fatalError(error.localizedDescription)
    }
}
