//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Sergey on 05.06.18.
//  Copyright © 2018 Sergey. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        birthdatePicker.maximumDate = Date()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthDate = birthdatePicker.date
        
        guard firstName != "", lastName != "" else {
            let alertController = UIAlertController(title: "Нет данных", message: "Необходимо ввести фамилию и имя", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newBirthday = Birthday(context: context)
        
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthDate as Date?
        newBirthday.birthdayId = UUID().uuidString
        
        if let uniqueId = newBirthday.birthdayId {
            print("birthdateId: \(uniqueId)")
        }
        
        
        do {
            try context.save()
            let message = "Сегодня \(firstName) \(lastName) празднует День Рождения!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default()
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthDate)
            dateComponents.hour = 8
            //dateComponents.hour = 19
            //dateComponents.minute = 5
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            if let indentifier = newBirthday.birthdayId {
                let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
            
        } catch let error {
            print("Not save error is \(error)")
        }
        
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }


}

