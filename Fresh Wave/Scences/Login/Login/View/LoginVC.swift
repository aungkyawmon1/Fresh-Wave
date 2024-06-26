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
    
    @IBOutlet weak var txtFieldPhoneNo: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    private let viewModel: LoginViewModel
    
    required init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.bindViewModel(in: self)
    }
    
    override func setupUI() {
        btnLogin.layer.cornerRadius = 8
        
    }
    
    override func bindData() {
        txtFieldPhoneNo.rx.text.map { $0 ?? ""}.bind(to: viewModel.phoneSubject ).disposed(by: disposableBag)
        
        viewModel.isValid().map { $0 }.bind(to: btnLogin.rx.isEnabled).disposed(by: disposableBag)
               
        viewModel.isValid().map { $0 ? 1.0 : 0.5}.bind(to: btnLogin.rx.alpha).disposed(by: disposableBag)
        
        btnLogin.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            self.viewModel.checkPhoneNumber(txtFieldPhoneNo.text ?? "")
        }.disposed(by: disposableBag)
        
        viewModel.verifyProfileResponse.subscribe(onNext: {[weak self] state in
            guard let self = self, let state = state, state else { return }
            self.navigateToVerifyVC()
            
        }).disposed(by: disposableBag)
        
        viewModel.phoneNumberResponse.subscribe(onNext: {[weak self] response in
            guard let self = self, let _ = response else { return }
            self.navigateToCompleteProfile()
        }).disposed(by: disposableBag)
        
    
    }
    
// MARK: - Route
    private func navigateToVerifyVC() {
        let vc = VerifyVC(viewModel: VerifyViewModel(authModel: AuthModelImpl.shared, phoneNumber: txtFieldPhoneNo.text ?? ""))
        pushVCWithAnimation(vc)
    }
    
    private func navigateToRegisterVC() {
        let vc = RegisterVC()
        pushVCWithAnimation(vc)
    }
    
    private func navigateToCompleteProfile() {
        let vc = CompleteProfileVC(viewModel: CompleteProfileViewModel(authModel: AuthModelImpl.shared, phoneNo: txtFieldPhoneNo.text ?? ""))
        pushVCWithAnimation(vc)
    }

}
