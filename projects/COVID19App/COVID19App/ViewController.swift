//
//  ViewController.swift
//  COVID19App
//
//  Created by seob_jj on 2021/10/14.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseCell: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverview { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                debugPrint("success : \(data)")
            case .failure(let error):
                debugPrint("failure : \(error.localizedDescription)")
            }
        }
    }
    
    func fetchCovidOverview(completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = ["serviceKey": "8ytkocahpzLx1l79rMiHGemYCF5XgD26K"]
        AF.request(url, method: .get, parameters: param)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case .failure(let error) :
                    completionHandler(.failure(error))
                }
            }
    }

}

