//
//  BeerListViewController.swift
//  BreweryApp
//
//  Created by seob_jj on 2021/10/21.
//

import UIKit


class BeerListViewController: UITableViewController{
    var beerList = [Beer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationBar
        title = "Brewery App"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // UITableView
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
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
