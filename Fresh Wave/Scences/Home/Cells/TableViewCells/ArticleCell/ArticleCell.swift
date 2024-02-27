//
//  ArticleCell.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/02/2024.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var lblArticleTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var ivArticlePhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
