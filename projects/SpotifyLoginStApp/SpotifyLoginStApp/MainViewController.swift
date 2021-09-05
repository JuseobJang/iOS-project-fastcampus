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
    @IBOutlet weak var resetPasswordButton: UIButton!
    
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
        
        // 이메일/비밀번호 로그인 인지 아니면 소셜 로그인인지 확인
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        resetPasswordButton.isHidden = !isEmailSignIn
        
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print("Error: signout \(signOutError.localizedDescription)")
        }
        
        
        
    }
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        // 해당 이메일로 비밀번호 변경 이메일을 보냄
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
}
