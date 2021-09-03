//
//  ViewController.swift
//  QuotesGenerator
//
//  Created by seob_jj on 2021/09/03.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let quotes = [
        Quote(contents: "소년기란 홍역처럼 어릴 때 앓고 지나가야하는 것이다. 중년이 되어 소년기가 찾아오면 심각한 증상이 될 가능성이 높다.", name: "P. G. Wodehouse"),
        Quote(contents: "모두가 오래 살고 싶어 하지만 아무도 늙고 싶어 하지는 않는다.", name: "Benjamin Franklin"),
        Quote(contents: "이 순간 살아 있으매 모든 삶의 축복에 대한 경외심을 느끼곤 합니다.", name: "Oprah Winfrey"),
        Quote(contents: "항상 내세워지는 모습이 젊음의 전부는 아니다.", name: "Lawana Blackwell"),
        Quote(contents: "바삐 태어나지 않은 자는 바삐 죽는다.", name: "Bob Dylan")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapQuoteGeneratorButton(_ sender: UIButton) {
        let random = Int(arc4random_uniform(5)) // 0 ~ 4 사이 난수 생성
        let quote = quotes[random]
        self.quoteLabel.text = quote.contents
        self.nameLabel.text = quote.name
    }
}

