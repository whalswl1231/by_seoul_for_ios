//
//  WinterContents.swift
//  test
//
//  Created by user on 2020/11/19.
//  Copyright © 2020 111. All rights reserved.
//


import Foundation
import UIKit

class WinterContents: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    let elements = ["노원 불빛정원", "경복궁", "롯데월드 아이스링크", "북촌 한옥마을"]
     
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
         let cell = tableView.dequeueReusableCell(withIdentifier: "WinterCell") as! WinterTableViewCell
         
         cell.selectionStyle = .none
         cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
         cell.winterLabel.text = elements[indexPath.row]
         cell.winterImage.image = UIImage(named: elements[indexPath.row])
         cell.winterImage.layer.cornerRadius = cell.winterImage.frame.height / 2
         return cell
     }

 }

