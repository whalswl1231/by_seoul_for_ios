//
//  ViewController.swift
//  test
//
//  Created by 111 on 26/08/2019.
//  Copyright © 2019 111. All rights reserved.
//

//================로그인 화면================



import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var id_field: UITextField!
    @IBOutlet var pwd_field: UITextField!
    @IBOutlet weak var autoLogin: UIButton!
    @IBOutlet var token_field: UILabel!
    @IBOutlet var login_btn: UIButton!
    
    var id : String!
    var pwd : String!
    
    @IBAction func doLogin(_ sender: UIButton) {
        if self.autoLogin.isSelected == true {
            let dataSave = UserDefaults.standard
            dataSave.setValue(true, forKey: "autoLogin")
            dataSave.setValue(self.id, forKey:"save_id")
            dataSave.setValue(self.pwd, forKey: "save_pwd")
        } else {
            let dataSave = UserDefaults.standard
            dataSave.setValue("nil", forKey: "save_id")
            dataSave.setValue("nil", forKey: "save_pwd")
            UserDefaults.standard.synchronize()
        }
        print("\(UserDefaults.standard.value(forKey: "save_id")!)")
        print("\(UserDefaults.standard.value(forKey: "save_pwd")!)")
        
        if let id = id_field.text, let pwd = pwd_field.text {
            if id != "" && pwd != "" {
                self.getToken(id:id, pwd:pwd)
                
            } else {
                print("null data")
            }
        }
    }
    
    func runLogin() {
        
        //token_field.text = "Now login..."
        print("로그인 성공")
        guard let vc = self.storyboard?
            .instantiateViewController(withIdentifier: "mainpage") as? Main else {
                return
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let dataSave = UserDefaults.standard
        guard let isAutoLogin = dataSave.value(forKey: "autoLogin") as? Bool else {
            return
        }
        
        if isAutoLogin {
            guard let id = dataSave.value(forKey:"save_id") as? String, let pwd = dataSave.value(forKey:"save_pwd") as? String else {
                return
            }
            print("autologin", id, pwd)
            self.getToken(id:id, pwd:pwd)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    
    
    func getToken(id:String, pwd:String){
        let parameters:Parameters = [
            "username":id,
            "password":pwd
        ]
        let login_url = AppDelegate.server_url+"api/get_token/"
        Alamofire.request(login_url, method: .post, parameters: parameters).responseData{
            response in
            
            switch response.result{
            case .success:
                print("접속 성공")
                if let data = response.data, let utf8Text = String(data:data, encoding: .utf8){
                    print("Data", utf8Text)
                    
                    let decoder = JSONDecoder()
                    do{
                        let token_data = try decoder.decode(Token.self, from: data)
                        //id, pwd 일치
                        print("id, pwd 일치")
                        print(token_data.token)
                        self.token_field.text = token_data.token
                        self.saveToken(token: token_data.token)
                        let userDefault = UserDefaults.standard
                        userDefault.setValue(id, forKey: "id")
                        userDefault.setValue(pwd, forKey: "pwd")
                        
                        self.runLogin()
                        
                    } catch {
                        //id, pwd 불일치
                        print("id, pwd 불일치")
                        print(error.localizedDescription)
                        var alert = UIAlertView()
                        alert.title = "로그인 실패"
                        alert.message = "잘못된 아이디 또는 비밀번호 입니다."
                        alert.addButton(withTitle: "OK")
                        alert.show()
                        
                    }
                }
            case .failure:
                print("접속 실패")
            }
        }
    }
    func saveToken(token:String){
        let userDefault = UserDefaults.standard
        userDefault.setValue(token, forKey: "token")
        userDefault.synchronize()
    }
    
    func getSavedToken() -> String{
        let userDefault = UserDefaults.standard
        if let token = userDefault.string(forKey: "token"){
            return token
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func autoLogin(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}

