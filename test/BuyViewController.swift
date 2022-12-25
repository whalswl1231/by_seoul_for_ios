//
//  BuyViewController.swift
//  test
//
//  Created by user on 18/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BuyViewController: BaseViewController{
    
    @IBOutlet var mypage_time: UILabel!
    @IBOutlet var ahour_btn: UIButton!
    @IBOutlet var twohour_btn: UIButton!
    @IBOutlet var thrhour_btn: UIButton!
    @IBOutlet var remain_time: UILabel!
    
    
    var list:[List]?
    
    var time_data:[JSON] = [JSON]()
    var url_id:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getidData()
        //네비게이션바 색
        
        guard
            let navigationController = navigationController,
            let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
        }
        
        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
        
        //네비게이션바 로고
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "app"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 110, bottom: 10, right: 120)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button
        
        //네비게이션바에 햄버거 아이콘 추가
        addSlideMenuButton()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func clickOnButton(){
        let mainStoryboard:UIStoryboard = UIStoryboard(name : "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "mainpage") as! Main
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    
    @IBAction func buy_ahour(_ sender: Any) {
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        
        let headers:HTTPHeaders = [
            "Authorization" : "Token \(token)", "Accept" : "application/json"]
        let userDefault = UserDefaults.standard
        
        let id = userDefault.value(forKey: "id") as! String
        let id_data:Data = id.data(using: .utf8)!
        let hour : String = "60"
        let hour_data:Data = hour.data(using: .utf8)!
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var dateString = dateFormatter.string(from: today as Date)
        print(dateString)
        let date_data:Data = dateString.data(using: .utf8)!
        print(id_data, hour_data, id, hour)
        
        Alamofire.upload(multipartFormData:{
            (multipartFormData) in multipartFormData.append(id_data, withName: "mypage_id")
            multipartFormData.append(date_data, withName: "buy_date")
            multipartFormData.append(hour_data, withName: "mypage_time")
        }, to: AppDelegate.server_url+"bicycle/booking/",method:.post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    debugPrint(response)
                    print("시간저장성공")
                    self.getData()
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    @IBAction func buy_twohour(_ sender: Any) {
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        
        let headers:HTTPHeaders = [
            "Authorization" : "Token \(token)", "Accept" : "application/json"]
        let userDefault = UserDefaults.standard
        
        let id = userDefault.value(forKey: "id") as! String
        let id_data:Data = id.data(using: .utf8)!
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var dateString = dateFormatter.string(from: today as Date)
        print(dateString)
        let date_data:Data = dateString.data(using: .utf8)!
        let hour : String = "120"
        let hour_data:Data = hour.data(using: .utf8)!
        print(id_data, hour_data, id, hour)
        
        Alamofire.upload(multipartFormData:{
            (multipartFormData) in multipartFormData.append(id_data, withName: "mypage_id")
            multipartFormData.append(date_data, withName: "buy_date")
            multipartFormData.append(hour_data, withName: "mypage_time")
        }, to: AppDelegate.server_url+"bicycle/booking/",method:.post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    debugPrint(response)
                    print("시간저장성공")
                    self.getData()
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    @IBAction func buy_thrhour(_ sender: Any) {
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        
        let headers:HTTPHeaders = [
            "Authorization" : "Token \(token)", "Accept" : "application/json"]
        let userDefault = UserDefaults.standard
        
        let id = userDefault.value(forKey: "id") as! String
        let id_data:Data = id.data(using: .utf8)!
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var dateString = dateFormatter.string(from: today as Date)
        print(dateString)
        let date_data:Data = dateString.data(using: .utf8)!
        let hour : String = "180"
        let hour_data:Data = hour.data(using: .utf8)!
        print(id_data, hour_data, id, hour)
        
        Alamofire.upload(multipartFormData:{
            (multipartFormData) in multipartFormData.append(id_data, withName: "mypage_id")
            multipartFormData.append(date_data, withName: "buy_date")
            multipartFormData.append(hour_data, withName: "mypage_time")
        }, to: AppDelegate.server_url+"bicycle/booking/",method:.post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    debugPrint(response)
                    print("시간저장성공")
                    self.getData()
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
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
        
        let url = AppDelegate.server_url+"app_default/list/"
        Alamofire.request(url, method: .get,parameters: parameters, headers: headers).responseData{
            response in switch response.result{
            case .failure:
                print("구매/내 id 조회 실패")
            case .success:
                print("구매/내 id 조회 성공")
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
                            let url = AppDelegate.server_url+"bicycle/gettime/"+"\(self.url_id)"+"/"
                            print(url)
                            self.get_time(url: url)
                        } else {
                            print("아이디 다름")
                        }
                    }
                } catch{
                    print(error)
                    
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    @objc func getData(){
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
        
        let url = AppDelegate.server_url+"app_default/list/"
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
                            let url = AppDelegate.server_url+"bicycle/gettime/"+"\(self.url_id)"+"/"
                            print(url)
                            self.getremain_time(url: url)
                        } else {
                            print("아이디 다름")
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
                self.mypage_time.text = time
            }
        }
    }
    func getremain_time(url:String) {
        Alamofire.request(url).responseJSON { response in
            if response.data != nil {
                let data = response.data
                let json = JSON(data)
                let time = json["time"].stringValue
                self.remain_time.text = time
            }
        }
    }
    
    
    
}
