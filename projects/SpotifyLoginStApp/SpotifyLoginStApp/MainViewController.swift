//
//  MainViewController.swift
//  SpotifyLoginStApp
//
//  Created by seob_jj on 2021/09/05.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 제스처를 통한 화면 전환 비활성화
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.navigationBar.isHidden = true
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
            환영합니다
            \(email) 님
            """
        
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
