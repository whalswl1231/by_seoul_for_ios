//
//  StampViewController.swift
//  test
//
//  Created by user on 29/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class StampViewController: BaseViewController {
   
   
    
    @IBOutlet var stamp1: UIImageView!
    @IBOutlet var stamp2: UIImageView!
    @IBOutlet var stamp3: UIImageView!
    @IBOutlet var stamp4: UIImageView!
    @IBOutlet var stamp5: UIImageView!
    @IBOutlet var stamp6: UIImageView!
    
    @IBOutlet var stampBtn: UIButton!
    
    @IBAction func stampBtn_Click(_ sender: UIButton) {
        let alert = UIAlertController(title: "스탬프 페이지", message: "따릉이를 1시간 주행하시면 스탬프를 1개 적립해드립니다.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            print("알람 뜬다 키키")
            //performSegue(withIdentifier: "back", sender: self)

            
            
        }
        alert.addAction(defaultAction)
        present(alert, animated: false, completion: nil)
    }
    var list:[List]?
    
    var time_data:[JSON] = [JSON]()
    var url_id:Int = 0
    
    @objc private func buttonPressed(_sender: Any){
        let alert = UIAlertController(title: "스탬프 페이지", message: "따릉이를 1시간 주행하시면 스탬프 1개를 적립해드립니다!", preferredStyle: UIAlertController
            .Style.actionSheet)
        
    }
    
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
                let time = json["record_time"].stringValue
                print(time)
                let Inttime = Int(time)
                if Inttime! >= 360 {
                    self.stamp1.image = UIImage(named: "stamp_after")
                    self.stamp2.image = UIImage(named: "stamp_after")
                    self.stamp3.image = UIImage(named: "stamp_after")
                    self.stamp4.image = UIImage(named: "stamp_after")
                    self.stamp5.image = UIImage(named: "stamp_after")
                    self.stamp6.image = UIImage(named: "stamp_after")
                } else if Inttime! >= 300{
                    self.stamp1.image = UIImage(named: "stamp_after")
                    self.stamp2.image = UIImage(named: "stamp_after")
                    self.stamp3.image = UIImage(named: "stamp_after")
                    self.stamp4.image = UIImage(named: "stamp_after")
                    self.stamp5.image = UIImage(named: "stamp_after")
                } else if Inttime! >= 240{
                    self.stamp1.image = UIImage(named: "stamp_after")
                    self.stamp2.image = UIImage(named: "stamp_after")
                    self.stamp3.image = UIImage(named: "stamp_after")
                    self.stamp4.image = UIImage(named: "stamp_after")
                } else if Inttime! >= 180{
                    self.stamp1.image = UIImage(named: "stamp_after")
                    self.stamp2.image = UIImage(named: "stamp_after")
                    self.stamp3.image = UIImage(named: "stamp_after")
                } else if Inttime! >= 120 {
                    self.stamp1.image = UIImage(named: "stamp_after")
                    self.stamp2.image = UIImage(named: "stamp_after")
                } else if Inttime! >= 60 {
                    self.stamp1.image = UIImage(named: "stamp_after")
                }
            }
        }
    }
    
}
