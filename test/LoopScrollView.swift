//
//  LoopScrollView.swift
//  test
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 111. All rights reserved.
//

import UIKit

class LoopScrollView: UIViewController{
    
    @IBOutlet var sliderCollectionView: UICollectionView!
    @IBOutlet var pageControll: UIPageControl!
    
    @IBOutlet var spring_btn: UIButton! //봄 테마 관광지 버튼
    @IBOutlet var summer_btn: UIButton! //여름 테마 관광지 버튼
    @IBOutlet var fall_btn: UIButton! //가을 테마 관광지 버튼
    @IBOutlet var winter_btn: UIButton! //겨울 테마 관광지 버튼
    @IBOutlet var recom_btn: UIButton! //가볼만한곳 버튼
    
    
    var imgArr = [ UIImage(named: "여행슬라이드1"),
                   UIImage(named: "여행슬라이드2"),
                   UIImage(named: "여행슬라이드3")
    ]
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        
        pageControll.numberOfPages = imgArr.count
        pageControll.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
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
        button.setImage(UIImage(named: "app"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 110, bottom: 10, right: 120)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button
        
        //네비게이션바에 햄버거 아이콘 추가
        //addSlideMenuButton()
        
    }
    
    //로고 버튼 눌렀을때
    @objc func clickOnButton(){
        let mainStoryboard:UIStoryboard = UIStoryboard(name : "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "mainpage") as! Main
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    //한국관광공사 버튼 눌렀을때
    @IBAction func ktour_click(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string:"http://www.visitkorea.or.kr")! as URL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func changeImage(){
        if counter < imgArr.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControll.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControll.currentPage = counter
        }
    }
    
}

extension LoopScrollView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! viewControllerCollectionViewCell
        cell.IMG.image = imgArr[indexPath.row]
        
        return cell
    }
    
}



extension LoopScrollView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
 

class viewControllerCollectionViewCell: UICollectionViewCell {
    @IBOutlet var IMG: UIImageView!
}
