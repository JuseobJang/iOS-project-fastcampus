//
//  DetailViewController.swift
//  BountyList
//
//  Created by seob_jj on 2021/07/12.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil) // dismiss() 현재 페이지를 닫는 함수
    }
     

}
