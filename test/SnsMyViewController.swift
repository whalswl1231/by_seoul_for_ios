//
//  SnsMyViewController.swift
//  test
//
//  Created by user on 27/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import AlamofireImage

class SnsMyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet var SnsMy: UITableView!
    var snss = [Sns]()
    var mysns = [Sns]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mysns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        let sns: Sns
        sns = mysns[indexPath.row]
        
        cell.myText.text = sns.text
        
        if sns.picture != nil {
            let url = URL(string: sns.picture!)!
            cell.myImage.af_setImage(withURL: url)
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        Alamofire.request(AppDelegate.server_url+"bicycle/sns/", method: .get,parameters: parameters, headers: headers).responseData{
            response in switch response.result{
            case .failure:
                print("내 sns 조회 실패")
            case .success:
                print("내 sns 조회 성공")
                guard let data = response.result.value else {
                    return
                }
                let decoder = JSONDecoder()
                do{
                    print(String(data:data, encoding: .utf8))
                    self.snss = try decoder.decode([Sns].self, from: data)
                    
                    for i in 0..<self.snss.count{
                        if self.snss[i].sns_id == id as! String{
                            self.mysns.append(self.snss[i])
                        }
                    }
                    self.mysns.reverse()
                    print(self.mysns)
                    
                    self.SnsMy.reloadData()
                } catch{
                    print(error)
                    
                    print(error.localizedDescription)
                }
            }
        }
        
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
    
    //네비게이션 로고 눌렀을때
    @objc func clickOnButton(){
        let mainStoryboard:UIStoryboard = UIStoryboard(name : "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "mainpage") as! Main
        self.navigationController?.pushViewController(DVC, animated: true)
    }
}
