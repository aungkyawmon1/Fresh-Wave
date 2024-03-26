//
//  HomeViewModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/02/2024.
//

import Foundation
import RxRelay

class HomeViewModel: BaseViewModel {
    private let articleModel: ArticleModel
    
    let articleListsRelay = BehaviorRelay<[ArticleVO]?>(value: nil)
    private var currentPage: Int = 1
    private var totalPage: Int = 0
    private let pageSize: Int = 10
    
    init(articleModel: ArticleModel) {
        self.articleModel = articleModel
    }
    
    func fetchArticlePosts() {
        let body: RequestBody = ["page": currentPage, "size": pageSize]
        self.loadingPublishRelay.accept(true)
        
        articleModel.getArticlePosts(body: body).subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.totalPage = response.pagination?.total ?? 0
            if currentPage == 1 {
                self.articleListsRelay.accept(response.data)
            } else {
                self.articleListsRelay.accept((self.articleListsRelay.value ?? []) + (response.data ?? []))
            }
            
        }, onError: { [weak self] error in
            guard let self = self else { return }
            self.loadingPublishRelay.accept(false)
            self.errorObservable.accept(error)
        }).disposed(by: disposableBag)
    }
    
    func hasMorePage() -> Bool {
        return currentPage * pageSize < totalPage
    }
    
    func fetchNextArticlePosts() {
        if hasMorePage() {
            currentPage += 1
            fetchArticlePosts()
        }
    }
    
    
    func numberOfArticles() -> Int {
        articleListsRelay.value?.count ?? 0
    }
    
    func getArticles(at index: Int) -> ArticleVO? {
        articleListsRelay.value?[index]
    }
}
