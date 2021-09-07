//
//  CardDetailViewController.swift
//  CreditCardList
//
//  Created by seob_jj on 2021/09/07.
//

import UIKit
import Lottie

class CardDetailViewController: UIViewController {
    
    var promotionDetail: PromotionDetail?

    @IBOutlet weak var lottieView: AnimationView!
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var benefitConditionLabel: UILabel!
    @IBOutlet weak var benefitDetailLabel: UILabel!
    @IBOutlet weak var benefitDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = AnimationView(name: "money")
        lottieView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let detail = promotionDetail else { return }
        
        titleLabel.text = """
            \(detail.companyName) 카드 쓰면
            \(detail.amount) 민원을 드려요
            """
        periodLabel.text = detail.period
        conditionLabel.text = detail.condition
        benefitConditionLabel.text = detail.benefitCondition
        benefitDateLabel.text = detail.benefitDetail
        
    }
}
