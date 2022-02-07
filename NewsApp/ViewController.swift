//
//  ViewController.swift
//  NewsApp
//
//  Created by Macbook on 04.02.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModels = [NewsTableViewCellModel]() {
        didSet {
            NewsCellModelsDefaults.saveNewsCellModels(with: viewModels)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        if let viewModelDefault = NewsCellModelsDefaults.getNewsCellModels() {
            viewModels = viewModelDefault
            tableView.reloadData()
        } else {
            callNetworkManager()
        }
        
    }
    
    @objc private func refreshNews() {
        callNetworkManager()
        tableView.refreshControl?.endRefreshing()
    }
    
    private func callNetworkManager() {
        NetworkManager.shared.getTopStories { [weak self] result in
            switch result {
                case .success(let article):
                    self?.viewModels = article.compactMap({
                        NewsTableViewCellModel(title: $0.title,
                                               subtitle: $0.description ?? "No description",
                                               imageURL: URL(string: $0.urlToImage ?? ""),
                                               clicksCount: 0,
                                               url: $0.url)
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let alertVC = UIAlertController(
                                    title: "Something wrong :(",
                                    message: "\(error)",
                                    preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertVC.addAction(action)
                        self?.present(alertVC, animated: true, completion: nil)
                    }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                       for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        let cellModelDefaults = NewsCellModelsDefaults.getNewsCellModels()
        cell.configure(with: cellModelDefaults![indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModels[indexPath.row].clicksCount += 1
        NewsCellModelsDefaults.saveNewsCellModels(with: viewModels)
        
        let cellModelDefaults = NewsCellModelsDefaults.getNewsCellModels()
        let newsURL = cellModelDefaults![indexPath.row].url
        guard let url = URL(string: newsURL ?? "") else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}


