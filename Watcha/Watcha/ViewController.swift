//
//  ViewController.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let rp = GifRepository(network: GifNetwork(manager: NetworkManager(session: URLSession.shared)))
        
        Task {
            
            let result = await rp.fetchDutchResult(query:"cheess", limit: 20, offset:0)
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
    }


}

