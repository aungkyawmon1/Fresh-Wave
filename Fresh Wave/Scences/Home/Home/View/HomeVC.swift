//
//  HomeVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 18/02/2024.
//

import UIKit

class HomeVC: BaseViewController {
    
    @IBOutlet weak var tableViewHome: UITableView!

    private let viewModel: HomeViewModel
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        
        tableViewHome.registerCell(from: ArticleCell.self)
    }
    
    override func setupUI() {
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Route
    private func navigateToArticleDetailVC(_ articleVO: ArticleVO?) {
        guard let articleVO = articleVO else { return }
        let vc = ArticleDetailVC(articleVO: articleVO)
        hideTabBarAndPushVC(vc)
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToArticleDetailVC(viewModel.getArticles(at: indexPath.row))
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfArticles()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(from: ArticleCell.self, at: indexPath)
        cell.articleVO = viewModel.getArticles(at: indexPath.row)
        return cell
    }
    
}
