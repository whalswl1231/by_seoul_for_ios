//
//  MenuViewController.swift
//  test
//
//  Created by user on 09/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

//================슬라이드메뉴================

import UIKit
protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    var TableArray = [String]()
    
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    @IBOutlet var btnCloseMenuOverlay: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        TableArray = ["Mypage","시간공유","결제페이지","추천 관광지"]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        btnMenu.tag = 0
        btnMenu.isHidden = false
        if (self.delegate != nil){
            var index = Int32(sender.tag)
            if(sender == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let Mypg = mainStoryboard.instantiateViewController(withIdentifier: "MypgViewController") as! MypgViewController
        let Time = mainStoryboard.instantiateViewController(withIdentifier: "TimeshareViewController") as! TimeshareViewController
        let Buy = mainStoryboard.instantiateViewController(withIdentifier: "BuyViewController") as! BuyViewController
        //let Sns = mainStoryboard.instantiateViewController(withIdentifier: "SnsHomeViewController") as! SnsHomeViewController
        let Tour = mainStoryboard.instantiateViewController(withIdentifier: "LoopScrollView") as! LoopScrollView
       
        
        
        if indexPath.row == 0{
            self.navigationController?.pushViewController(Mypg, animated: true)
        }else if indexPath.row == 1{
            self.navigationController?.pushViewController(Time, animated: true)
        }else if indexPath.row == 2{
            self.navigationController?.pushViewController(Buy, animated: true)
        }else{
            self.navigationController?.pushViewController(Tour, animated: true)
        }
        
    }
}
