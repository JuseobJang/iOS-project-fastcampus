//
//  TodayCollectionViewCell.swift
//  AppStore
//
//  Created by seob_jj on 2021/10/30.
//

import SnapKit
import UIKit
import SwiftUI

final class TodayCollectionViewCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let imageView = UIImageView()
    
    

    override func layoutSubviews() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        
        titleLabel.text = "제에목"
        subTitleLabel.text = "부제목"
        descriptionLabel.text = "설명설명"
        
        [imageView, titleLabel, subTitleLabel, descriptionLabel].forEach{
            self.addSubview($0)
        }
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        subTitleLabel.textColor = .white
        
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .bold)
        descriptionLabel.textColor = .white
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12.0
        imageView.backgroundColor = .gray
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalTo(subTitleLabel)
        }
        
        subTitleLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview().inset(24)
        
        }
        
        descriptionLabel.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview().inset(24)
        }
        
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        

    }
    
}
