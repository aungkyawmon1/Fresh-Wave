//
//  OrderHistoryCell.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 19/02/2024.
//

import UIKit

class OrderHistoryCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var orderVO: OrderVO? {
        didSet {
            if let orderVO = orderVO {
                lblPrice.text = "\(orderVO.totalPrice ?? "0") MMK"
                lblDate.text = "Ordered on \(orderVO.createdDate ?? "")"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
