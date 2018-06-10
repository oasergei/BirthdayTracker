//
//  BirthdaysTableViewController.swift
//  BirthdayTracker
//
//  Created by Sergey on 08.06.18.
//  Copyright © 2018 Sergey. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class BirthdaysTableViewController: UITableViewController {
    
    var birthdays = [Birthday]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        
        let sortDescriptorLastName = NSSortDescriptor(key: "lastName", ascending: true)
        let sortDescriptorFirstName = NSSortDescriptor(key: "firstName", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptorLastName, sortDescriptorFirstName]
        
        do {
            birthdays = try context.fetch(fetchRequest)
        } catch {
            print("Not loading data is error: \(error)")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return birthdays.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "birthdayCellIdentier", for: indexPath)

        let birthday = birthdays[indexPath.row]
        //cell.textLabel?.text = birthday.firstName + " " + birthday.lastName
        //cell.detailTextLabel?.text = dateFormatter.string(from: birthday.birthDate)
        let firstName = birthday.firstName ?? ""
        let lastName = birthday.lastName ?? ""
        cell.textLabel?.text = firstName + " " + lastName
        
        if let date = birthday.birthdate as Date? {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
   
//    // MARK: - AddBirthdayViewControllerDelegate
//    func addBirthdayViewController(_ addBirthdaysViewController: AddBirthdayViewController, didAddBirthday birthday: Birthday) {
//
//        birthdays.append(birthday)
//        tableView.reloadData()
//    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if birthdays.count > indexPath.row {
            let birhtday = birthdays[indexPath.row]
            
            //удаляем уведомление
            if let identifier = birhtday.birthdayId {
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(birhtday)
            birthdays.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error {
                print("Not save context, error is \(error)")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let navigationController = segue.destination as! UINavigationController
//        let addBirthdayViewController = navigationController.topViewController as! AddBirthdayViewController
//        addBirthdayViewController.delegate = self
//    }

}
