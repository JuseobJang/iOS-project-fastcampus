//
//  BeerListViewController.swift
//  BreweryApp
//
//  Created by seob_jj on 2021/10/21.
//

import UIKit


class BeerListViewController: UITableViewController{
    var beerList = [Beer]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationBar
        title = "Brewery App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // UITableView
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
                
        fetchBeer(of: currentPage)
        
    }
    
}

// UITableVIew DataSource
extension BeerListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        
        cell.configure(with: beerList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        detailViewController.beer = selectBeer
        self.show(detailViewController, sender: nil)
    }
}

// Data Fetching
extension BeerListViewController {
    private func fetchBeer(of page: Int){
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                      print("Error URLSession")
                      return
                  }
            switch response.statusCode {
            case 200...299:
                print("GOOD")
                self.beerList += beers
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case 400...499:
                print("Client Error")
            case 500...599:
                print("Server Error")
            default:
                print("ERROR")
            }
        }
        
        dataTask.resume()
    }
}
