//
//  ViewController.swift
//  Firebase101
//
//  Created by seob_jj on 2021/07/29.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    var customers: [Customer] = []
    let db = Database.database().reference()
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numOfCustomer: UILabel!
    
    @IBAction func createCustomer(_ sender: Any) {
        saveCustomers()
    }
    @IBAction func fetchCustomer(_ sender: Any) {
        fetchCustomers()
    }
    @IBAction func updateCustomer(_ sender: Any) {
        updateCustomers()
    }
    @IBAction func deleteCustomer(_ sender: Any) {
        deleteCustomers()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
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

// MARK: Customer save fetch update delete
extension ViewController {
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
    
    func fetchCustomers(){
        db.child("customers").observeSingleEvent(of: .value){ snapshot in
            print("\(snapshot.value)")
            do {
                let data = try JSONSerialization.data(withJSONObject: snapshot.value, options: [])
                let decoder = JSONDecoder()
                let customers: [Customer] = try decoder.decode([Customer].self,  from: data)
                self.customers = customers
                DispatchQueue.main.async {
                    self.numOfCustomer.text = "# of Customer: \(customers.count)"
                }
            } catch {
                print("error")
            }
        }
    }
    
    func updateCustomers(){
        guard customers.isEmpty == false else { return }
        customers[0].name = "Min"
        
        let dictionaries = customers.map{ $0.toDict }
        db.updateChildValues(["customers" : dictionaries])
    }
    
    func deleteCustomers(){
        db.child("customers").removeValue()
    }
}

// MARK: Basic types : save update delete
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
    
    func updateBasicTypes(){
        db.updateChildValues(["int": 6])
        db.updateChildValues(["double": 5.4])
        db.updateChildValues(["str": "변경된 str"])
    }
    
    func deleteBasicTypes(){
        db.child("int").removeValue();
        db.child("double").removeValue()
        db.child("str").removeValue()
    }
}

struct Customer: Codable{
    static var id = 0
    
    var id: String
    var name: String
    var books: [Book]
    
    var toDict: [String: Any] {
        let booksArray = books.map{$0.toDict}
        let dict: [String: Any] = ["id": id, "name": name, "books": booksArray]
        return dict
    }
}

struct Book: Codable {
    let title: String
    let author: String
    
    var toDict: [String: Any]{
        let dict: [String: Any] = ["title": title, "author": author]
        return dict
    }
}
