//
//  ViewController.swift
//  Firebase101
//
//  Created by seob_jj on 2021/07/29.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let db = Database.database().reference()
    @IBOutlet weak var dataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        saveBasicTypes()
        saveCustomers()
        
    }
    func updateLabel(){
        db.child("firstData").observeSingleEvent(of: .value){ snapshot in
            print("\(snapshot)")
            let value = snapshot.value as? String ?? ""
            
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
}

extension ViewController {
    func saveBasicTypes(){
        // Firebase child("key").setValue(Value)
        // - string, number, dict, array
        db.child("int").setValue(3);
        db.child("double").setValue(3.5)
        db.child("str").setValue("hihi")
        db.child("array").setValue(["a","b","c"])
        db.child("dict").setValue(["id": "anyId", "age": 10, "city": "seoul"])
    }
    
    func saveCustomers(){
        let books = [Book(title: "해리포터와 불의 잔", author: "J.K.롤링"),
                     Book(title: "해리포터와 마법사의 돌", author: "J.K.롤링")]
        let newCustomer1 = Customer(id: "\(Customer.id)", name: "Jang", books: books)
        Customer.id += 1
        let newCustomer2 = Customer(id: "\(Customer.id)", name: "Kang", books: books)
        Customer.id += 1
        let newCustomer3 = Customer(id: "\(Customer.id)", name: "Bae", books: books)
        Customer.id += 1
        
        db.child("customers").child(newCustomer1.id).setValue(newCustomer1.toDict)
        db.child("customers").child(newCustomer2.id).setValue(newCustomer2.toDict)
        db.child("customers").child(newCustomer3.id).setValue(newCustomer3.toDict)
    }
}

struct Customer{
    static var id = 0
    
    let id: String
    let name: String
    let books: [Book]
    
    var toDict: [String: Any] {
        let booksArray = books.map{$0.toDict}
        let dict: [String: Any] = ["id": id, "name": name, "books": booksArray]
        return dict
    }
}

struct Book {
    let title: String
    let author: String
    
    var toDict: [String: Any]{
        let dict: [String: Any] = ["title": title, "author": author]
        return dict
    }
    
}
