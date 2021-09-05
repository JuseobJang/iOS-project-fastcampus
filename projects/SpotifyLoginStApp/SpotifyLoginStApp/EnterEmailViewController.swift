//
//  EnterEmailViewController.swift
//  SpotifyLoginStApp
//
//  Created by seob_jj on 2021/09/05.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 다음 버튼 라디우스 및 비활성화 설정
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false
        
        // delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // emailTextField에 바로 커서가 갈 수 있도록 해줌
        emailTextField.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 보이기
        navigationController?.navigationBar.isHidden = false
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // 파이어베이스 이메일/비밀번호 인증
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password){[weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: // 이미 가입한 계정
                    // 로그인 하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                self.showMainViewController()
            }
        }
        
    }
    
    private func showMainViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
    private func loginUser(withEmail email:String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            }else {
                self.showMainViewController()
            }
            
        }
    }
}

extension EnterEmailViewController: UISearchTextFieldDelegate {
    // 리턴 버튼을 누르면 키보드를 내려줌
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    // 각 텍스트 필드 상태를 체크해 둘다 비어 있지 않으면 다음 버튼 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}

