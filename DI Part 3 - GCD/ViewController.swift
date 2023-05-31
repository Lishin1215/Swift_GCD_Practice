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
        
        
    //Dispatch Group
        let group = DispatchGroup()
        
        //用loop去拿三個url資料
        for i in 0 ..< offsets.count  {
            var parameters:Parameters = ["scope": "resourceAquire", "limit": "1", "offset": String(offsets[i])]
            
            //進入group
            group.enter()
            AF.request(urlString, parameters: parameters).responseDecodable(of: Response.self) { response in
                
                //拿到成果報告
                switch response.result {
                case .success(let response):
                    //(解碼成功，獲得資料) -> 放入district和location資訊
                    print(response.result.results[0].district)
                    
                    //result存到result array
//                    self.districtResultArray[i] = response.result.results[0].district
//                    self.locationResultArray[i] = response.result.results[0].location
                    self.districtResultArray.append(response.result.results[0].district)//用append出現順序會不一定
                    self.locationResultArray.append(response.result.results[0].location)
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                group.leave() //結束離開group
            }
//            //等3個API都取得資料，再一起放入label
//            group.notify(queue: DispatchQueue.global()) {
//                print("all done, start changing label name")
//
//                    DispatchQueue.main.async { //更新UI
//
//                        print(self.districtResultArray)
//                        self.districtLabelArray?[i].text = self.districtResultArray[i]
//                        self.locationLabelArray?[i].text = self.locationResultArray[i]
//                    }
//
//            }
            
        }
        
        //等3個API都取得資料，再一起放入label
        group.notify(queue: DispatchQueue.global()) {
            print("all done, start changing label name")

            for i in 0 ..< (self.districtResultArray.count) {
                DispatchQueue.main.async { //更新UI

                    print(self.districtResultArray)
                    self.districtLabelArray?[i].text = self.districtResultArray[i]
                    self.locationLabelArray?[i].text = self.locationResultArray[i]
                }
            }

        }
    }
    
    
}

