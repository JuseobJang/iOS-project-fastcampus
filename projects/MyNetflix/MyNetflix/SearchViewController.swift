//
//  SearchViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/02.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    // 검색 버튼 눌렸을 때 처리 구현
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 키보드가 올라와 있을떄, 내려가게 처리
        dismissKeyboard()
        
        // 검색어가 있는 지 확인
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else {
            return
        }
        
        
        // 네트워킹을 통한 검색
        
        print("---> \(searchBar.text)")
    }
    
    private func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
}
