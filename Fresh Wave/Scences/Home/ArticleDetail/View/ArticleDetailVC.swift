//
//  ArticleDetailVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/02/2024.
//

import UIKit

class ArticleDetailVC: BaseViewController {
    
    @IBOutlet weak var lblArticleTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivArticleImage: UIImageView!
    
    private let articleVO: ArticleVO
    
    required init(articleVO: ArticleVO) {
        self.articleVO = articleVO
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        lblArticleTitle.text = articleVO.title
        lblDate.text = articleVO.updatedAt
        lblDesc.text = articleVO.description
        ivArticleImage.setWebImage(with: articleVO.imageURL)
    }

}
