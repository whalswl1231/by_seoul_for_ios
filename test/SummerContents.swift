//
//  SummerContents.swift
//  test
//
//  Created by user on 2020/11/19.
//  Copyright © 2020 111. All rights reserved.
//

import Foundation
import UIKit

class SummerContents: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let elements = ["경의선숲길", "세빛섬", "올림픽공원"]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
    
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsets(top: 220,left: 0,bottom: 0,right: 0) // tableView에 margin 주고 싶을 때
        
        super.viewDidLoad()
    }
    
    // tableViewCell 배경 없애기
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummerCell") as! SummerTableViewCell
        
        cell.selectionStyle = .none
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        cell.summerLabel.text = elements[indexPath.row]
        cell.summerImage.image = UIImage(named: elements[indexPath.row])
        cell.summerImage.layer.cornerRadius = cell.summerImage.frame.height / 2
        return cell
    }

}


    
