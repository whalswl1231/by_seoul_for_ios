//
//  MypgViewController.swift
//  test
//
//  Created by user on 10/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MypgViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var mypage_time: UILabel!
    @IBOutlet var mypg_Table: UITableView!
    @IBOutlet var record_Table: UITableView!
    
    var buys = [Booking]()
    var mybuy = [Booking]()
    var records = [Record]()
    var myrecord = [Record]()
    
    var list:[List]?
    
    var time_data:[JSON] = [JSON]()
    var url_id:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getidData()
        mypg_Table.delegate = self
        mypg_Table.dataSource = self
        mypg_Table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        record_Table.delegate = self
        record_Table.dataSource = self
        record_Table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        Alamofire.request(AppDelegate.server_url+"bicycle/booking/", method: .get,parameters: parameters, headers: headers).responseData{
            response in switch response.result{
            case .failure:
                print("내 구매내역 조회 실패")
            case .success:
                print("내 구매내역 조회 성공")
                guard let data = response.result.value else {
                    return
                }
                let decoder = JSONDecoder()
                do{
                    //print(String(data:data, encoding: .utf8))
                    self.buys = try decoder.decode([Booking].self, from: data)
                    
                    for i in 0..<self.buys.count{
                        if self.buys[i].mypage_id == id as! String{
                            self.mybuy.append(self.buys[i])
                        }
                    }
                    self.mybuy.reverse()
                    
                    self.mypg_Table.reloadData()
                } catch{
                    print(error)
                    
                    print(error.localizedDescription)
                }
            }
        }
        //여기부터
        
        Alamofire.request(AppDelegate.server_url+"bicycle/record/", method: .get,parameters: parameters, headers: headers).responseData{
            response in switch response.result{
            case .failure:
                print("내 기록 조회 실패")
            case .success:
                print("내 기록 조회 성공")
                guard let data = response.result.value else {
                    return
                }
                let decoder = JSONDecoder()
                do{
                    
                    self.records = try decoder.decode([Record].self, from: data)
                    
                    for i in 0..<self.records.count{
                        if self.records[i].record_id == id as! String{
                            self.myrecord.append(self.records[i])
                        }
                    }
                    self.myrecord.reverse()
                    
                    self.record_Table.reloadData()
                } catch{
                    print(error)
                    
                    print(error.localizedDescription)
                }
            }
        }
        
        
        //여기까지
        
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
        //button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
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
    
    //로고 버튼 눌렀을때
    @objc func clickOnButton(){
        let mainStoryboard:UIStoryboard = UIStoryboard(name : "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "mainpage") as! Main
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    //시간 가져올때 필요한 아이디번호 얻기
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
                            let url=AppDelegate.server_url+"bicycle/gettime/"+"\(self.url_id)"+"/"
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
    
    //시간 가져오기
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
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView == mypg_Table){
            return mybuy.count
        } else {
            return myrecord.count
        }
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == mypg_Table){
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! BuyTableViewCell
            let buy: Booking
            buy = mybuy[indexPath.row]
            
            cell.buy_date.text = buy.buy_date
            cell.buy_time.text = buy.mypage_time
            cell.buy_price.text = "1000"
            
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! RecordTableViewCell
            let record: Record
            record = myrecord[indexPath.row]
            
            cell.record_date.text = record.date
            cell.record_time.text = record.time
            cell.record_kcal.text = record.kal
            cell.record_km.text = record.km
            
            return cell
        }
    }
    
}
