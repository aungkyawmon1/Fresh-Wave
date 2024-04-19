//
//  OrderDetailVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 25/03/2024.
//

import UIKit

class OrderDetailVC: BaseViewController {

    @IBOutlet weak var lblNoOfBottle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var agentView: UIStackView!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var agentAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFloorPrice: UILabel!
    @IBOutlet weak var lblBottlePrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    
    private let orderVO: OrderVO
    
    required init(orderVO: OrderVO) {
        self.orderVO = orderVO
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupUI() {
        lblOrderStatus.text = orderVO.orderStatus
        lblNoOfBottle.text = "\(orderVO.count ?? 0)"
        lblAddress.text = Preference.getUserInfo()?.address ?? ""
        
        lblPrice.text = "\(orderVO.price ?? "0") MMK"
        lblFloorPrice.text = "\(orderVO.floorPrice ?? "0") MMK"
        
        let orderStatus = orderVO.orderStatus
        if orderStatus == "5" {
            agentView.isHidden = true
            
        } else {
            agentView.isHidden = false
            agentName.text = Preference.getNearestAgentInfo()?.username
            agentAddress.text = Preference.getNearestAgentInfo()?.address
            
        }
        
        lblBottlePrice.text = "\(orderVO.netPrice ?? "0") MMK"
        lblTotalPrice.text = "\(orderVO.totalPrice ?? "0") MMK"
        lblDate.text = "Ordered on \(orderVO.createdDate ?? "")"
    }
    
  

}
