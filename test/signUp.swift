//
//  signUp.swift
//  test
//
//  Created by user on 20/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit
import Alamofire

class signUp : UIViewController {
    //회원가입 페이지
    
    @IBOutlet var id_field: UITextField!
    @IBOutlet var pwd_field: UITextField!
    @IBOutlet var signUp_btn: UIButton!
    
    var id:String!
    var pwd:String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }

    
    @IBAction func doSignup(_ sender: UIButton) {
        
        self.id = (self.id_field.text != nil) ? self.id_field.text : ""
        self.pwd = (self.pwd_field.text != nil) ? self.pwd_field.text : ""
        
        guard let username = self.id_field.text, let id_data:Data = username.data(using: .utf8) else {
            return
        }
        guard let password = self.pwd_field.text, let pwd_data:Data = password.data(using: .utf8) else {
            return
        }
        
        Alamofire.upload(multipartFormData:{
            (multipartFormData) in multipartFormData.append(id_data, withName: "username")
            multipartFormData.append(pwd_data, withName: "password")
        }, to: AppDelegate.server_url+"app_default/signup/", encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    debugPrint(response)
                    print("회원가입 성공")
                    
                    
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
    }
    
    
}
