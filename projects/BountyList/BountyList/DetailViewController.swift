//
//  DetailViewController.swift
//  BountyList
//
//  Created by seob_jj on 2021/07/12.
//

/*
 MVVM pattern
 
 Model
 - Bounty Info
 BountyInfo 만들어야함
 
 View
 - imgView, nameLabel, bountyLabel
 view들은 viewModel을 통해서 구성 되어야함
 
 ViewModel
 - DetailViewModel
 View에서 필요한 메서드 만들기
 모델 가지고 있기 => BountyInfo
 */
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
//    @IBOutlet weak var nameLabelCenterX: NSLayoutConstraint!
//    @IBOutlet weak var bountyLabelCenterX: NSLayoutConstraint!
    
    let viewModel = DetailViewModel()
    
    // 뷰가 보여지기 직전
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareAnimation()
    }
    
    // 뷰가 보여지고 나서
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    func updateUI(){
        if let bountyInfo = self.viewModel.bountyInfo {
            imgView.image = bountyInfo.image
            nameLabel.text = bountyInfo.name
            bountyLabel.text = "\(bountyInfo.bounty)"
        }
    }
    
    func prepareAnimation(){
        //        nameLabelCenterX.constant = view.bounds.width
        //        bountyLabelCenterX.constant = view.bounds.width
        
        nameLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        bountyLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        
        nameLabel.alpha = 0
        bountyLabel.alpha = 0
    }
    
    func showAnimation(){
        //        nameLabelCenterX.constant = 0
        //        bountyLabelCenterX.constant = 0
        
        //        UIView.animate(withDuration: 0.3){
        //            self.view.layoutIfNeeded() // constant 값이 변경 되었으므로 layout을 다시 해줘야함
        //        }
        //        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
        
        //        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {self.view.layoutIfNeeded()}, completion: nil)
        //
        //        UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        
        // identity 로 transform 이전 속성을 가져 올 수 있음
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
            self.nameLabel.transform = CGAffineTransform.identity
            self.nameLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
            self.bountyLabel.transform = CGAffineTransform.identity
            self.bountyLabel.alpha = 1
        }, completion: nil)
        
        UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil) // dismiss() 현재 페이지를 닫는 함수
    }
}


class DetailViewModel{
    var bountyInfo: BountyInfo?
    
    func update(model: BountyInfo){
        bountyInfo = model
    }
}
