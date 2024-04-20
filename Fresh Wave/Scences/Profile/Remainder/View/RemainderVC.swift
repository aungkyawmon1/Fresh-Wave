//
//  RemainderVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 09/03/2024.
//

import UIKit
import DLLocalNotifications
import RxCocoa

class RemainderVC: BaseViewController {

    @IBOutlet weak var weekPickerView: UIPickerView!
    @IBOutlet weak var updateRemainderView: UIView!
    @IBOutlet weak var remainderView:  UIView!
    @IBOutlet weak var remainderSwitch: UISwitch!
    @IBOutlet weak var lblEdit: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblRemainderDesc: UILabel!
    
    private let arr: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]
    
    private var selectedRow: Int = Preference.getInteger(forKey: .remainderDate)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tapEdit = UITapGestureRecognizer(target: self, action: #selector(onTapEdit))
        lblEdit.isUserInteractionEnabled = true
        lblEdit.addGestureRecognizer(tapEdit)
        
        weekPickerView.dataSource = self
        weekPickerView.delegate = self
    }
    
    override func setupUI() {
        let isRemainderOn = Preference.getBool(forKey: .isRemainderOn)
        remainderSwitch.isOn = isRemainderOn
        remainderView.isHidden = !isRemainderOn
        
        lblRemainderDesc.text = "Notification will be notified at  9 AM at every \(arr[selectedRow])"
    }
    
    override func bindData() {
        btnCancel.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            updateRemainderView.isHidden = true
            remainderView.isHidden = false
        }.disposed(by: disposableBag)
        
        remainderSwitch.rx.isOn.bind { state in
            Preference.setValue(state, forKey: .isRemainderOn)
            self.remainderView.isHidden = !state
            if state {
                self.makeAlarm()
            } else {
                self.cancelAlarm()
            }
        }.disposed(by: disposableBag)
        
        btnUpdate.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            updateRemainderView.isHidden = true
            remainderView.isHidden = false
            showMessage("Updated!", isSuccessfulState: true)
            lblRemainderDesc.text = "Notification will be notified at  9 AM at every \(arr[selectedRow])"
            makeAlarm()
        }.disposed(by: disposableBag)
    }
    
    @objc func onTapEdit() {
        remainderView.isHidden = true
        updateRemainderView.isHidden = false
       
    }
    
    private func makeAlarm()  {
        var dateComponents = DateComponents()
        dateComponents.weekday = selectedRow + 1
        dateComponents.hour = 11
        dateComponents.minute = 54
//        let firstNotification = DLNotification(identifier: "firstNotification", alertTitle: "Notification Alert", alertBody: "You have successfully created a notification", date: triggerDate)
        let firstNotification = DLNotification(identifier: "freshWaveNotification", alertTitle: "Order Today", alertBody: " 20-liter water with Fresh Wave now!", fromDateComponents: dateComponents , repeatInterval: .weekly)

        let scheduler = DLNotificationScheduler()
        scheduler.cancelAlllNotifications()
        scheduler.scheduleNotification(notification: firstNotification)
        scheduler.scheduleAllNotifications()
    }
    
    private func cancelAlarm() {
        let scheduler = DLNotificationScheduler()
        scheduler.cancelAlllNotifications()
    }

}


extension RemainderVC : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
      
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
      
}
  
  
extension RemainderVC : UIPickerViewDelegate{
      
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        Preference.setValue(selectedRow, forKey: .remainderDate)
    }
}
