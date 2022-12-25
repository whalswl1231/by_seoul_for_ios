//
//  buypgViewController.swift
//  test
//
//  Created by user on 18/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit

class TimeshareViewController: BaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 89/255, green: 187/255, blue: 74/255, alpha: 1.0)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //let image = UIImage(named: "app")
        button.setImage(UIImage(named: "app"), for: .normal)
        //button.backgroundColor = .green
        //button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @objc func clickOnButton(){
        guard let vc = self.storyboard?
            .instantiateViewController(withIdentifier: "mainpage") else {
                return
        }
        self.present(vc, animated: false)
    }
}
