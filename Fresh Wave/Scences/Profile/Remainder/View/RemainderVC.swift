//
//  RemainderVC.swift
//  Fresh Wave
//
//  Created by Aung Kyaw Mon on 09/03/2024.
//

import UIKit
import DLLocalNotifications

class RemainderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickNOtify(_ snder: UIButton) {
        // The date you would like the notification to fire at
        debugPrint("Click")
        let triggerDate = Date().addingTimeInterval(3)

        var dateComponents = DateComponents()
        dateComponents.weekday = 7
        dateComponents.hour = 21
        dateComponents.minute = 20
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
