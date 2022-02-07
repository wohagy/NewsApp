//
//  NewsTableViewCellModel.swift
//  NewsApp
//
//  Created by Macbook on 05.02.2022.
//

import Foundation

class NewsTableViewCellModel: Codable {
    let title: String
    let subtitle: String
    let url: String?
    let imageURL: URL?
    var imageData: Data? = nil
    var clicksCount: Int
    
    init(title: String,subtitle: String,imageURL: URL?, clicksCount: Int, url: String?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.clicksCount = clicksCount
        self.url = url
    }
}
