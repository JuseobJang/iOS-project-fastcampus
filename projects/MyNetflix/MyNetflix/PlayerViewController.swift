//
//  PlayerViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/01.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // 기본 오리엔테이션 설정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

//extension AVPlayer {
//    var isPlaying: Bool {
//        guard self.currentItem != nil else { return false }
//        return self.rate != 0
//    }
//}
