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
    
    lazy private var refreshControl = UIRefreshControl()
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.bindViewModel(in: self)
        
        setupRefreshControl()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchArticlePosts()
    }
    
    private func setupTableView() {
        tableViewHome.delegate = self
        tableViewHome.dataSource = self
        
        tableViewHome.registerCell(from: ArticleCell.self)
    }
    
    private func setupRefreshControl() {
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "colorPrimary600")
        tableViewHome.addSubview(refreshControl)
    }
    
    override func setupUI() {
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func bindData() {
        viewModel.articleListsRelay.subscribe(onNext: { [weak self] articleList in
            guard let self = self, let articleList = articleList else { return }
            if !articleList.isEmpty {
                self.tableViewHome.reloadData()
            }
        }).disposed(by: disposableBag)
    }
    
    @objc private func refresh() {
        viewModel.refreshArticle()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Route
    private func navigateToArticleDetailVC(_ articleVO: ArticleVO?) {
        guard let articleVO = articleVO else { return }
        let vc = ArticleDetailVC(articleVO: articleVO)
        hideTabBarAndPushVC(vc)
    }
    
    private func navigateToCartVC() {
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if viewModel.readyToPaginate(by: indexPath.row) {
            viewModel.fetchNextArticlePosts()
        }
        
    }
    
}
