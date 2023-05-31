//
//  ViewController.swift
//  DI Part 3 - GCD
//
//  Created by 簡莉芯 on 2023/5/30.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    
    @IBOutlet weak var districtTopLabel: UILabel!
    @IBOutlet weak var locationTopLabel: UILabel!
    @IBOutlet weak var districtMiddleLabel: UILabel!
    @IBOutlet weak var locationMiddleLabel: UILabel!
    @IBOutlet weak var districtBottomLabel: UILabel!
    @IBOutlet weak var locationBottomLabel: UILabel!
    
    //用來裝從API抓下來的result (因為到時候要一起更新）
    var districtResultArray: [String] = []
    var locationResultArray: [String] = []
    
    //把label放進array，讓他們可以用loop裝進去
    var districtLabelArray: [UILabel]?
    var locationLabelArray: [UILabel]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //直接定義在外面會爆錯
        districtLabelArray = [districtTopLabel, districtMiddleLabel, districtBottomLabel]
        locationLabelArray = [locationTopLabel, locationMiddleLabel, locationBottomLabel]
        
       getData()
    }


    func getData() {
        
        let urlString = "https://data.taipei/api/v1/dataset/c7784a9f-e11e-4145-8b72-95b44fdc7b83"
        
        let offsets = [0, 10, 20]
        
        
    //Dispatch Semaphore
        let semaphore = DispatchSemaphore(value: 1) // value>0，semaphore有資源去執行非同步程式
//        let queue = DispatchQueue(label: "hello")

        
        //用loop去拿三個url資料
        for i in 0 ..< offsets.count  {
            
            // 要被放入“非同步”queue裡
            DispatchQueue.global().async {
                
                var parameters:Parameters = ["scope": "resourceAquire", "limit": "1", "offset": String(offsets[i])]
                
                // wait 等待資源，有資源（value>0）的話就繼續執行，若value<=0時，則程式無法執行（擺在queue裡面繼續等資源），
                // 當開始實行時，會將semaphore的資源-1，
                semaphore.wait()
                
                AF.request(urlString, parameters: parameters).responseDecodable(of: Response.self) { response in
                    
                    //拿到成果報告
                    switch response.result {
                    case .success(let response):
                        //(解碼成功，獲得資料) -> 放入district和location資訊
                        print(response.result.results[0].district)
                        
                        //直接修改label text
                        DispatchQueue.main.async {
                            self.districtLabelArray?[i].text = response.result.results[0].district
                            self.locationLabelArray?[i].text = response.result.results[0].location
                        }
                        
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                    semaphore.signal()
                }
            }
            
        }
        
    }
    
    
}

