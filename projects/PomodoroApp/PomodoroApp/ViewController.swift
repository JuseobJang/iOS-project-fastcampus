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

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause :
            self.timerStatus = .end
            self.cancelButton.isEnabled = false
            self.setTimerInfoViewVisible(isHidden: true)
            self.datePicker.isHidden = false
            self.startButton.isSelected = false
        default:
            break
        }
    }
    @IBAction func startButtonTapped(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        case.end :
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false)
            self.datePicker.isHidden = true
            self.startButton.isSelected = true
            self.cancelButton.isEnabled = true
            
        case .start :
            self.timerStatus = .pause
            self.startButton.isSelected = false
            
        case .pause :
            self.timerStatus = .start
            self.startButton.isSelected = true
        }
    }
}

