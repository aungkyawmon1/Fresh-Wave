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
    
    private let arr: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]
    
    private var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tapEdit = UITapGestureRecognizer(target: self, action: #selector(onTapEdit))
        lblEdit.isUserInteractionEnabled = true
        lblEdit.addGestureRecognizer(tapEdit)
        
        weekPickerView.dataSource = self
        weekPickerView.delegate = self
    }
    
    override func bindData() {
        btnCancel.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            updateRemainderView.isHidden = true
            remainderView.isHidden = false
        }.disposed(by: disposableBag)
        
        btnUpdate.rx.tap.bind {[weak self] in
            guard let self = self else { return }
            updateRemainderView.isHidden = true
            remainderView.isHidden = false
            showMessage("Updated!", isSuccessfulState: true)
        }.disposed(by: disposableBag)
    }
    
    @objc func onTapEdit() {
        remainderView.isHidden = true
        updateRemainderView.isHidden = false
       
    }
    
    
    @IBAction func onClickNOtify(_ snder: UIButton) {
        // The date you would like the notification to fire at
        debugPrint("Click")
        let triggerDate = Date().addingTimeInterval(3)

        var dateComponents = DateComponents()
        dateComponents.weekday = 7
        dateComponents.hour = 9
        dateComponents.minute = 00
//        let firstNotification = DLNotification(identifier: "firstNotification", alertTitle: "Notification Alert", alertBody: "You have successfully created a notification", date: triggerDate)
        let firstNotification = DLNotification(identifier: "freshWaveNotification", alertTitle: "Order Today", alertBody: " 20-liter water with Fresh Wave now!", fromDateComponents: dateComponents , repeatInterval: .weekly)

        let scheduler = DLNotificationScheduler()
        scheduler.scheduleNotification(notification: firstNotification)
        scheduler.scheduleAllNotifications()
        
    }
    
    private func makeAlarm()  {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Tuesday at 2pm"
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current


        dateComponents.weekday = 7  // Tuesday
        dateComponents.hour = 21  // 14:00 hours
        dateComponents.minute = 3
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)


        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request, withCompletionHandler: {(error) in
            if error != nil {
                debugPrint(error.debugDescription)
            }
        })
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
        selectedRow = row + 1
    }
}
