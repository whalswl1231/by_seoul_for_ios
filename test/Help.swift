//
//  Help.swift
//  test
//
//  Created by user on 25/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Help: BaseViewController{
    
    @IBOutlet var help: UILabel!
    var list:[List]?
    
    var time_data:[JSON] = [JSON]()
    var url_id:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getidData()
        self.get_time(url:"url")
        
    }
    //id찾기
    @objc func getidData(){
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        let headers:HTTPHeaders = [
            "Authorization" : "Token \(token)", "Accept" : "application/json"]
        let userDefault = UserDefaults.standard
        var id = userDefault.value(forKey: "id")
        var pwd = userDefault.value(forKey: "pwd")
        let parameters:Parameters = [
            "id": id!,
            "pwd":pwd!
        ]
        
        let url = "http://127.0.0.1:8000/app_default/list/"
        Alamofire.request(url, method: .get,parameters: parameters, headers: headers).responseData{
            response in switch response.result{
            case .failure:
                print("내 id 조회 실패")
            case .success:
                print("내 id 조회 성공")
                guard let data = response.result.value else {
                    return
                }
                let decoder = JSONDecoder()
                do{
                    print(String(data:data, encoding: .utf8))
                    self.list = try decoder.decode([List].self, from: data)
                    
                    print(self.list)
                    
                    for i in 0..<self.list!.count {
                        if self.list![i].username == id as! String {
                            print(self.list![i].id)
                            self.url_id = self.list![i].id
                            let url="http://127.0.0.1:8000/bicycle/gettime/"+"\(self.url_id)"+"/"
                            print(url)
                            self.get_time(url: url)
                        } else {
                            print("아이디 조회 실패")
                        }
                    }
                } catch{
                    print(error)
                    
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
    func get_time(url:String) {
        Alamofire.request(url).responseJSON { response in
            if response.data != nil {
                let data = response.data
                let json = JSON(data)
                let time = json["time"].stringValue
                self.help.text = time
            }
        }
    }
}
