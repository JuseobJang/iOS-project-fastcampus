//
//  AlertListViewController.swift
//  DrinkApp
//
//  Created by seob_jj on 2021/10/02.
//

import UIKit
import UserNotifications

class AlertListViewController: UITableViewController {
    
    var alerts: [Alert] = []
    let userNotificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "AlertListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alerts = alertList()
    }
    
    @IBAction func addAlertButtonAction(_ sender: UIBarButtonItem) {
        guard let addAlertVC = storyboard?.instantiateViewController(withIdentifier: "AddAlertViewController") as? AddAlertViewController else {return}
        
        addAlertVC.pickedDate = { [weak self] date in
            guard let self = self else {return}
            var alertList = self.alertList()
            let newAlert = Alert(date: date, isOn: true)
            alertList.append(newAlert)
            alertList.sort{ $0.date < $1.date }
            
            self.alerts = alertList

            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            
            self.userNotificationCenter.addNotificationRequest(by: newAlert)
            
            self.tableView.reloadData()
        }
        self.present(addAlertVC, animated: true, completion: nil)
    }
    
    func alertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return [] }
        return alerts
    }
    
}

extension AlertListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "물 마실 시간"
        default:
            return nil
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else { return UITableViewCell() }
        cell.alertSwitch.isOn = alerts[indexPath.row].isOn
        cell.timeLabel.text = alerts[indexPath.row].time
        cell.meridiemLabel.text = alerts[indexPath.row].meridiem
        cell.alertSwitch.tag = indexPath.row
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.alerts.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
            self.tableView.reloadData()
            return
        default:
            break
        }
    }
}
