//
//  CompleteProfileVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 17/03/2024.
//

import UIKit
import RxCocoa

class CompleteProfileVC: BaseViewController {

    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    
    private let viewModel: CompleteProfileViewModel
    
    private var noOfBottole: Int = 1
    
    required init(viewModel: CompleteProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bindViewModel(in: self)
    }
    
    override func setupUI() {
        title = "Register Account"
        btnRegister.layer.cornerRadius = btnRegister.frame.height / 2.0
    }

    
    override func bindData() {
        
        txtFieldName.rx.text.map { $0 ?? ""}.bind(to: viewModel.nameSubject).disposed(by: disposableBag)
        
        btnAddress.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            self.presentChooseAddressOnMap()
            
        }.disposed(by: disposableBag)
        
        btnRegister.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            guard let userName = txtFieldName.text, let address = txtFieldAddress.text else { return }
            viewModel.registerCustomer(userName: userName, address: address)
        }.disposed(by: disposableBag)
        
        viewModel.areAllFieldsValid().bind(to: btnRegister.rx.isEnabled ).disposed(by: disposableBag)
        
        viewModel.areAllFieldsValid().map({ $0 ? 1.0 : 0.5}).bind(to: btnRegister.rx.alpha ).disposed(by: disposableBag)
        
        viewModel.userProfile.subscribe(onNext: {[weak self] response in
            guard let self = self, let _ = response else { return }
            self.showMessage("Account is successfully registered!", isSuccessfulState: true)
            self.popVC()
        }).disposed(by: disposableBag)
        
    }
    
    private func presentChooseAddressOnMap() {
        let vc = ChooseAddressOnMapVC()
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        self.present( navVC , animated: true)
    }

}

//MARK: - ChooseAddressOnMapDelegate
extension CompleteProfileVC: ChooseAddressOnMapDelegate {
    func chooseAddress(addressPlace: String, latitude: Double, longitude: Double) {
        txtFieldAddress.text = addressPlace
        viewModel.addressSubject.onNext(addressPlace)
    }
    
    
}
