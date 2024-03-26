//
//  ArticleModel.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 22/03/2024.
//

import Foundation
import RxSwift

protocol ArticleModel {
    func getArticlePosts(body: RequestBody) -> Observable<ArticleResponse>
}

class ArticleModelImpl: BaseModel, ArticleModel {

    static let shared = ArticleModelImpl()
    
    func getArticlePosts(body: RequestBody) -> RxSwift.Observable<ArticleResponse> {
        service.request(endpoint: .articles(body), response: ArticleResponse.self)
    }
    
    
}
