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
        // - 서치텀을 가지고 네트워킹을 통해서 영화검색
        // - 검색 API  필요
        // - 결과를 받아올 모델 Movie, Response
        // - 결과를 받아와서 CollectionView에 표현
        
        SearchApi.search(searchTerm){ movies in
            // collection view 로 표현
            
        }
        
        print("---> \(searchTerm)")
    }
    
    private func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
}

class SearchApi{
    static func search(_ term: String, completion: @escaping ([Movie]) -> Void){
        let session = URLSession(configuration: .default)
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
                
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL){ data, response, error in
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                completion([])
                return
            }
            
            guard let resultData = data else {
                completion([])
                return
            }
            
            let str = String(data: resultData, encoding: .utf8)
            print(str)
            
//            completion([Movie])
            
        }
        dataTask.resume()
        
        
    }
    
}

struct Response{
    
    
}

struct Movie {
    
}
