//
//  FileLoader.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

struct FileLoader {
    enum Error: Swift.Error {
        case fileNotFound(name: String)
        case fileDecodingFailed(name: String, Swift.Error)
    }

    func loadFile<T: Decodable>(type: T.Type, fromFileNamed name: String) throws -> [T] {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("\(name).json")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                return try decoder.decode([T].self, from: data)
            } catch {
                return []
            }
        } else {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
            return []
        }
    }
}
