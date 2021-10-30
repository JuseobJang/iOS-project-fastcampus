//
//  TodayCollectionHeaderView.swift
//  AppStore
//
//  Created by seob_jj on 2021/10/30.
//

import SnapKit
import UIKit

final class TodayCollectionHeaderView: UICollectionReusableView {
    
    private var dateLabel = UILabel()
    private var titleLabel = UILabel()
    
    override func layoutSubviews() {
        
        [dateLabel, titleLabel].forEach {
            self.addSubview($0)
        }
        
        dateLabel.text = "6월 28일 월요일"
        titleLabel.text = "투데이"

        dateLabel.font = .systemFont(ofSize: 14.0, weight: .semibold)
        dateLabel.textColor = .secondaryLabel
        
        titleLabel.font = .systemFont(ofSize: 36.0, weight: .black)
        titleLabel.textColor = .label
        
        dateLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(32.0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(dateLabel)
            $0.top.equalTo(dateLabel.snp.bottom).offset(8.0)
        }
    }
}
