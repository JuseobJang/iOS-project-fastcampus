//
//  ViewController.swift
//  PomodoroApp
//
//  Created by seob_jj on 2021/10/14.
//

import UIKit

enum TimerStatus {
    case start
    case pause
    case end
}


class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var duration = 60
    var timerStatus: TimerStatus = .end
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStartButton()
    }
    
    func setTimerInfoViewVisible(isHidden: Bool)  {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }

    func configureStartButton() {
        self.startButton.setTitle("시작", for: .normal)
        self.startButton.setTitle("일시정지", for: .selected)
    }
    
    func startTimer(){
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                self?.currentSeconds -= 1
                debugPrint(self?.currentSeconds)
                if self?.currentSeconds ?? 0 <= 0 {
                    self?.stopTimer()
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer(){
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        self.setTimerInfoViewVisible(isHidden: true)
        self.datePicker.isHidden = false
        self.startButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause :
            self.stopTimer()
            
        default:
            break
        }
    }
    @IBAction func startButtonTapped(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        case.end :
            
            self.currentSeconds = self.duration
            
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false)
            self.datePicker.isHidden = true
            self.startButton.isSelected = true
            self.cancelButton.isEnabled = true
            
            self.startTimer()
            
        case .start :
            self.timerStatus = .pause
            self.startButton.isSelected = false
            self.timer?.suspend()
            
        case .pause :
            self.timerStatus = .start
            self.startButton.isSelected = true
            self.timer?.resume()
        }
    }
}

