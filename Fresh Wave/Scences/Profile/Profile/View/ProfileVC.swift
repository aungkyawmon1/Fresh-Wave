//
//  ProfileVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 18/02/2024.
//

import UIKit

class ProfileVC: BaseViewController {

    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var logOutView: UIView!
    @IBOutlet weak var editAccountSV: UIStackView!
    @IBOutlet weak var orderHistorySV: UIStackView!
    @IBOutlet weak var setRemainderSV: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGesture()
    }
    
    private func setupGesture() {
        let tapEditAccount = UITapGestureRecognizer(target: self, action: #selector(onTapEditAccount))
        editAccountSV.isUserInteractionEnabled = true
        editAccountSV.addGestureRecognizer(tapEditAccount)
        
        let tapOrderHistory = UITapGestureRecognizer(target: self, action: #selector(onTapOrderHistory))
        orderHistorySV.isUserInteractionEnabled = true
        orderHistorySV.addGestureRecognizer(tapOrderHistory)
        
        let tapSetRemainder = UITapGestureRecognizer(target: self, action: #selector(onTapSetRemainder))
        setRemainderSV.isUserInteractionEnabled = true
        setRemainderSV.addGestureRecognizer(tapSetRemainder)
    }
    
    override func setupUI() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        editView.layer.cornerRadius = 16.0
        helpView.layer.cornerRadius = 16.0
        logOutView.layer.cornerRadius = 16.0
    }
    
    // MARK: - onTap
    @objc func onTapEditAccount() {
        
    }
    
    @objc func onTapOrderHistory() {
        let vc = OrderHistoryVC()
        hideTabBarAndPushVC(vc)
    }
    
    @objc func onTapSetRemainder() {
        let vc = RemainderVC()
        hideTabBarAndPushVC(vc)
    }

}
