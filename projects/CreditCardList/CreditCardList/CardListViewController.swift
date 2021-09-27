//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by seob_jj on 2021/09/07.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseFirestore

class CardListViewController: UITableViewController {
    // Firebase realtime database
    //    var ref: DatabaseReference!
    
    // Firebase firestore
    var db = Firestore.firestore()
    
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        // realtime database 읽기
        //        ref = Database.database().reference()
        //        ref.observe(.value){ snapshot in
        //            guard let value = snapshot.value as? [String : [String : Any]] else { return }
        //            do {
        //                let jsonData = try JSONSerialization.data(withJSONObject: value)
        //                let cardData = try JSONDecoder().decode([String : CreditCard].self, from: jsonData)
        //                let cardList = Array(cardData.values)
        //                self.creditCardList = cardList.sorted{ $0.rank < $1.rank }
        //
        //                DispatchQueue.main.async {
        //                    self.tableView.reloadData()
        //                }
        //
        //            } catch let error {
        //                print("ERROR JSON PARSING \(error.localizedDescription)")
        //            }
        //        }
        
        // Firestore 읽기
        db.collection("creditCardList").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents
            else { return }
            self.creditCardList = documents.compactMap{ doc -> CreditCard? in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                }catch let error {
                    print("\(error.localizedDescription)")
                    return nil
                }
            }.sorted{$0.rank < $1.rank}
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell  else {
            return UITableViewCell()
        }
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        // 실시간 데이터베이스 쓰기
        // 경로를 알때
        //        let cardID = creditCardList[indexPath.row].id
        //        ref.child("Item\(cardID)/isSelected").setValue(true)
        
        
        // 경로를 모를때
        //        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value){[weak self] snapshot in
        //            guard let self = self,
        //                  let value = snapshot.value as? [String : [String : Any]],
        //                  let key = value.keys.first else { return }
        //            self.ref.child("\(key)/isSelected").setValue(true)
        //        }
        
        // 파이어 스토어 쓰기
        // 경로를 알 때
        let cardID = creditCardList[indexPath.row].id
        //        db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected" : true])
        // 경로를 모를 때
        db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
            guard let document = snapshot?.documents.first else { return }
            document.reference.updateData(["isSelected" : true])
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Realtime database
            // 경로를 알 때
            //            let cardID = creditCardList[indexPath.row].id
            //            ref.child("Item\(cardID)").removeValue()
            
            // 경로를 모를 때
            //            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value){ [weak self] snapshot in
            //                guard let self = self,
            //                      let value = snapshot.value as? [String : [String : Any]],
            //                      let key = value.keys.first else { return }
            //                self.ref.child("\(key)").removeValue()
            //            }
            
            // Firestore
            // 경로를 알 때
            let cardID = creditCardList[indexPath.row].id
            db.collection("creditCardList").document("card\(cardID)").delete()
            
            // 경로를 모를 때
            db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments { snapshot, _ in
                guard let document = snapshot?.documents.first else { return }
                document.reference.delete()
            }
        }
    }
    
}
