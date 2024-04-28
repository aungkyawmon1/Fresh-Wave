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
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var editAccountSV: UIStackView!
    @IBOutlet weak var orderHistorySV: UIStackView!
    @IBOutlet weak var setRemainderSV: UIStackView!
    @IBOutlet weak var callCenterSV: UIStackView!
    @IBOutlet weak var termAndPolicySV: UIStackView!
    
    private let viewModel: ProfileViewModel
    
    required init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblUsername.text = viewModel.userName
        lblAddress.text = viewModel.address
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
        
        let tapCallCenter = UITapGestureRecognizer(target: self, action: #selector(onTapCallCenter))
        callCenterSV.isUserInteractionEnabled = true
        callCenterSV.addGestureRecognizer(tapCallCenter)
        
        let tapTermAndPolicy = UITapGestureRecognizer(target: self, action: #selector(onTapTermAndPolicy))
        termAndPolicySV.isUserInteractionEnabled = true
        termAndPolicySV.addGestureRecognizer(tapTermAndPolicy)
        
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(onTapLogout))
        logOutView.isUserInteractionEnabled = true
        logOutView.addGestureRecognizer(tapLogout)
        
    }
    
    override func setupUI() {
        title = "Profile"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
       
        editView.layer.cornerRadius = 16.0
        helpView.layer.cornerRadius = 16.0
        logOutView.layer.cornerRadius = 16.0
    }
    
    // MARK: - onTap
    @objc func onTapEditAccount() {
        let vc = EditProfileVC(viewModel: EditProfileViewModel(authModel: AuthModelImpl.shared))
        hideTabBarAndPushVC(vc)
    }
    
    @objc func onTapOrderHistory() {
        let vc = OrderHistoryVC(viewModel: OrderHistoryViewModel(orderModel: OrderModelImpl.shared))
        hideTabBarAndPushVC(vc)
    }
    
    @objc func onTapSetRemainder() {
        let vc = RemainderVC()
        hideTabBarAndPushVC(vc)
    }
    
    @objc func onTapLogout() {
        doLogOut()
    }
    
    @objc func onTapCallCenter() {
        let vc = CallCenterVC()
        hideTabBarAndPushVC(vc)
    }
    
    @objc func onTapTermAndPolicy() {
        if let url = URL(string: "https://university-magazine-group-8.click/terms") {
            UIApplication.shared.open(url)
            
        }

    }

}
