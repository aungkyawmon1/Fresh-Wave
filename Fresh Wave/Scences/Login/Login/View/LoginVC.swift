//
//  LoginVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 18/02/2024.
//

import UIKit
import RxCocoa
import RxSwift

class LoginVC: BaseViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblCreatAnAccount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapCreatAnAccount = UITapGestureRecognizer(target: self, action: #selector(onTapCreateAnAccount))
        lblCreatAnAccount.isUserInteractionEnabled = true
        lblCreatAnAccount.addGestureRecognizer(tapCreatAnAccount)
    }
    
    override func setupUI() {
        btnLogin.layer.cornerRadius = btnLogin.frame.height / 2
        
    }
    
    override func bindData() {
        btnLogin.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            self.navigateToVerifyVC()
        }.disposed(by: disposableBag)
    }
    
// MARK: - onTap
    @objc func onTapCreateAnAccount() {
        navigateToRegisterVC()
    }
    
// MARK: - Route
    private func navigateToVerifyVC() {
        let vc = VerifyVC()
        pushVCWithAnimation(vc)
    }
    
    private func navigateToRegisterVC() {
        let vc = RegisterVC()
        pushVCWithAnimation(vc)
    }

}
