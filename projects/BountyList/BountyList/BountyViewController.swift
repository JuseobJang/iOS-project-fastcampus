//
//  BountyViewController.swift
//  BountyList
//
//  Created by seob_jj on 2021/07/06.
//

/*
 MVVM pattern
 
 Model
  - Bounty Info
    BountyInfo 만들어야함
 
 View
  - ListCell
    ListCell 필요한 정보를 ViewModel에서 받야한다.
    ListCell은 ViewModel로 부터 받은 정보로 뷰 얻데이트
 
 ViewModel
  - BountyViewModel
    BountyViewModel 만들기 + 뷰에서 필요한 메서드 만들기
    모델을 가지고 있어야 함 => BountyInfo
 */

import UIKit

class BountyViewController: UIViewController
                            , UITableViewDataSource, UITableViewDelegate {
    
    
//    let nameList = ["brook","chopper","franky","luffy","nami","robin","sanji","zoro"]
//    let bountyList = [33000000,50,44000000,300000000,16000000,80000000,77000000,120000000]
    
    let bountyInfoList : [BountyInfo] = [
        BountyInfo(name: "brook", bounty: 33000000),
        BountyInfo(name: "chopper", bounty: 50),
        BountyInfo(name: "franky", bounty: 44000000),
        BountyInfo(name: "luffy", bounty: 300000000),
        BountyInfo(name: "nami", bounty: 16000000),
        BountyInfo(name: "robin", bounty: 80000000),
        BountyInfo(name: "sanji", bounty: 77000000),
        BountyInfo(name: "zoro", bounty: 120000000),
    ]
    
    
    // performSegue() 함수 실행후에 실행됨 sender를 받아옴
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController // segue 목적지인 DetailViewController를 불러옴
            if let index = sender as? Int {
                
                let bountyInfo = bountyInfoList[index]
                
//                vc?.name = nameList[index] // name 설정
//                vc?.bounty = bountyList[index] // bounty 설정
                
//                vc?.name = bountyInfo.name
//                vc?.bounty = bountyInfo.bounty
                
                vc?.bountyInfo = bountyInfo
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bountyList.count
        return bountyInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else{
            return UITableViewCell()
        }
//        let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
//        cell.imgView.image = img
//        cell.nameLabel.text = nameList[indexPath.row]
//        cell.bountyLabel.text = "\(bountyList[indexPath.row])"
        
        let bountyInfo = bountyInfoList[indexPath.row]
        cell.imgView.image = bountyInfo.image
        cell.nameLabel.text = bountyInfo.name
        cell.bountyLabel.text = "\(bountyInfo.bounty)"

        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("--> \(indexPath.row)")
        performSegue(withIdentifier: "showDetail", sender: indexPath.row) // prepare()함수에 sender에 indexPath.row를 넘겨줌
        
    }
}

class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
}

struct BountyInfo {
    let name: String
    let bounty: Int
    
    var image: UIImage? {
        return UIImage(named: "\(name).jpg")
    }
    
    init(name: String, bounty: Int){
        self.name = name
        self.bounty = bounty
    }
}
