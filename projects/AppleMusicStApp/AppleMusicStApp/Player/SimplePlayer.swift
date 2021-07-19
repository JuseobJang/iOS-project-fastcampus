//
//  SimplePlayer.swift
//  AppleMusicStApp
//
//  Created by joonwon lee on 2020/03/15.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import AVFoundation

class SimplePlayer {
    // TODO: 싱글톤 만들기, 왜 만드는가?
    
    
    private let player = AVPlayer()

    var currentTime: Double {
        // TODO: currentTime 구하기
        return 0.0
    }
    
    var totalDurationTime: Double {
        // TODO: totalDurationTime 구하기
        return 0.0
    }
    
    var isPlaying: Bool {
        // TODO: isPlaying 구하기
        return false
    }
    
    var currentItem: AVPlayerItem? {
        // TODO: currentItem 구하기
        return nil
    }
    
    init() { }
    
    func pause() {
        // TODO: pause구현
        
    }
    
    func play() {
        // TODO: play구현
        
    }
    
    func seek(to time:CMTime) {
        // TODO: seek구현
        
    }
    
    func replaceCurrentItem(with item: AVPlayerItem?) {
        // TODO: replace current item 구현
        
    }
    
    func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
        player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
    }
}
