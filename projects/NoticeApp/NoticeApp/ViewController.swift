//
//  ViewController.swift
//  NoticeApp
//
//  Created by seob_jj on 2021/09/28.
//

import UIKit
import FirebaseRemoteConfig

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        
        remoteConfig?.configSettings = setting
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotice()
    }


}

// RemoteConfig
extension ViewController {
    func getNotice(){
        guard let remoteConfig = remoteConfig else { return }
        
        remoteConfig.fetch { [weak self] status, _ in
            if status == .success {
                remoteConfig.activate(completion: nil)
            } else {
                print("ERROR: Config not fetched")
            }
            
            guard let self = self else { return }
            if !self.isNoticeHidden(remoteConfig) {
                let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                
                noticeVC.modalPresentationStyle = .custom
                noticeVC.modalTransitionStyle = .crossDissolve
                
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                noticeVC.noticeContents = (title, detail, date)
                self.present(noticeVC, animated: true, completion: nil)
            }
            
        }
    }
    
    func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
        return remoteConfig["isHidden"].boolValue
    }
    
}
