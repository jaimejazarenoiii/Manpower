//
//  Saveable.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/7/22.
//

import Foundation

protocol Saveable {}
extension Saveable {
    func saveToJson<T: Codable>(type: T.Type, objects: [T], fileName: String) {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(objects)
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!.appendingPathComponent("\(fileName).json")

        do {
            try String(data: jsonData, encoding: .utf8)!
                .write(to: path,
                       atomically: true,
                       encoding: .utf8)
        } catch(let err) {
            print("Saving error: \(err.localizedDescription)")
        }
    }
}
