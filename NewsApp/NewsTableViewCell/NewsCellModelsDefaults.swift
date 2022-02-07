//
//  NewsCellModelsDefaults.swift
//  NewsApp
//
//  Created by Macbook on 06.02.2022.
//

import Foundation

struct NewsCellModelsDefaults {

    private static let cellsDefaults = UserDefaults.standard
    private static let key = "NewsCells"
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    private init() {}

    static func getNewsCellModels() -> [NewsTableViewCellModel]? {

        var winterModel: [NewsTableViewCellModel]?
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            winterModel = try? decoder.decode([NewsTableViewCellModel].self, from: data)
        }
        return winterModel
    }

    static func saveNewsCellModels(with cellModels: [NewsTableViewCellModel]) {
        let data = try? encoder.encode(cellModels)
        cellsDefaults.set(data, forKey: key)
    }
}
