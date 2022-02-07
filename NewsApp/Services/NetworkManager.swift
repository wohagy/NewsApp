//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Macbook on 05.02.2022.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    struct Constants {
        static let newsURL = URL(string:
            "https://newsapi.org/v2/top-headlines?country=us&pageSize=20&apiKey=ce5bd0c216e84a8b8339db1dd3598597")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.newsURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
