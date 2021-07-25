//
//  PlayerViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/01.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    let player = AVPlayer()
    
    // 기본 오리엔테이션 설정
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = player
    }
    
    // 보여지기 직전
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        play()
    }
    
    @IBAction func togglePlayButton(_ sender: Any) {
        if player.isPlaying {
            pause()
        }else{
            play()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        reset()
        dismiss(animated: false, completion: nil)
    }
    
    func play(){
        player.play()
        playButton.isSelected = true
    }
    
    func pause(){
        player.pause()
        playButton.isSelected = false
    }
    
    func reset(){
        player.replaceCurrentItem(with: nil)
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
