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
    
//    var name: String?
//    var bounty: Int?
    
    var bountyInfo: BountyInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI(){
        if let bountyInfo = self.bountyInfo {
            imgView.image = bountyInfo.image
            nameLabel.text = bountyInfo.name
            bountyLabel.text = "\(bountyInfo.bounty)"
        }
        
//        if let name = self.name, let bounty = self.bounty {
//            imgView.image = UIImage(named: "\(name).jpg")
//            nameLabel.text = name
//            bountyLabel.text = "\(bounty)"
//        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil) // dismiss() 현재 페이지를 닫는 함수
    }
     

}
