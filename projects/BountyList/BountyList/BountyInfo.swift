//
//  BountyInfo.swift
//  BountyList
//
//  Created by seob_jj on 2021/07/14.
//

import UIKit

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
