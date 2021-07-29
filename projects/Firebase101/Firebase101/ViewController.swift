//
//  ViewController.swift
//  Firebase101
//
//  Created by seob_jj on 2021/07/29.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let db = Database.database().reference()
    @IBOutlet weak var dataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        // Do any additional setup after loading the view.
    }
    func updateLabel(){
        db.child("firstData").observeSingleEvent(of: .value){ snapshot in
            print("\(snapshot)")
            let value = snapshot.value as? String ?? ""
            
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
}

