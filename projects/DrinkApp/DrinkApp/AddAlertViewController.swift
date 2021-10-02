//
//  AddAlertViewController.swift
//  DrinkApp
//
//  Created by seob_jj on 2021/10/02.
//

import UIKit

class AddAlertViewController: UIViewController {
    var pickedDate: ((_ date: Date) -> Void)?

    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        pickedDate?(datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
}
