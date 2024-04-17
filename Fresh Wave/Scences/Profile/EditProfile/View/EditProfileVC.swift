//
//  EditProfileVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 14/04/2024.
//

import UIKit

class EditProfileVC: BaseViewController {

    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnAddress: UIButton!
    
    private let viewModel: EditProfileViewModel
    
    required init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        
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
        title = "Register Account"
        btnUpdate.layer.cornerRadius = 8.0
        
        txtFieldName.text = viewModel.userName
        txtFieldAddress.text = viewModel.address
    }

    
    override func bindData() {
        
        txtFieldName.rx.text.map { $0 ?? ""}.bind(to: viewModel.nameSubject).disposed(by: disposableBag)
        
        btnAddress.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            self.presentChooseAddressOnMap()
            
        }.disposed(by: disposableBag)
        
        btnUpdate.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            guard let userName = txtFieldName.text, let address = txtFieldAddress.text else { return }
            viewModel.updateProfile(userName: userName, address: address)
        }.disposed(by: disposableBag)
        
        viewModel.areAllFieldsValid().bind(to: btnUpdate.rx.isEnabled ).disposed(by: disposableBag)
        
        viewModel.areAllFieldsValid().map({ $0 ? 1.0 : 0.5}).bind(to: btnUpdate.rx.alpha ).disposed(by: disposableBag)
        
        viewModel.updateProfileResponse.subscribe(onNext: {[weak self] response in
            guard let self = self, let _ = response else { return }
            self.showMessage("Profile is successfully updated!", isSuccessfulState: true)
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
extension EditProfileVC: ChooseAddressOnMapDelegate {
    func chooseAddress(addressPlace: String, latitude: Double, longitude: Double) {
        txtFieldAddress.text = addressPlace
        viewModel.addressSubject.onNext(addressPlace)
    }
    
    
}
