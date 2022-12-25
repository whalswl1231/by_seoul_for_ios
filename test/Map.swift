//
//  Map.swift
//  test
//
//  Created by 111 on 26/08/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class Map: UIViewController, MTMapViewDelegate {
    var mapView: MTMapView!
    
    
    @IBOutlet var borrow_btn: UIButton!
    @IBOutlet var mapWrapperView: UIView!
    @IBOutlet var btnDrop: UIButton!
    @IBOutlet var tblView: UITableView!
    
    var mTimer : Timer?
    var number : Int = 0
    var restTime : Int = 20
    var kgText : String? // 몸무게 전역변수
    

    
    var locationList = ["강남구", "강동구", "강서구", "강북구", "관악구", "광진구", "구로구", "금천구", "노원구", "동대문구", "도봉구", "동작구", "마포구", "서대문구", "성동구", "성북구", "서초구", "송파구", "영등포구", "용산구", "양천구", "은평구", "종로구", "중구", "중랑구"]
    
    var json_data:[JSON] = [JSON]()
    


    
    
    @IBAction func borrow(_ sender: UIButton) {
        let alert = UIAlertController(title: "몸무게를 입력해주세요", message: "칼로리 측정을 위해서는 몸무게가 필요합니다. 몸무게를 입력해주세요.", preferredStyle: .alert)
                
        alert.addTextField { (myTextField) in // alert 창 안에 textField 넣기
            myTextField.placeholder = "몸무게 kg"
        }
        let textField = alert.textFields![0] // 입력받은 몸무게 text
                
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in // ok 버튼
            print("————————0000")
            print(textField.text!)
            self.kgText = textField.text!

            //Main으로 이동
            self.performSegue(withIdentifier: "go", sender: self)
        }
                
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil) // cancel 버튼
                
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil) // alert 창 보여주기
    }
    

    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "go"{
            
            let MainVC = segue.destination as! Main
            MainVC.data = String(number)
            MainVC.delegate = self
            MainVC.flag = true
            MainVC.kg = self.kgText! // 몸무게 데이터 Main 페이지로 보내기
            
        }

    }
 

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnDrop.layer.cornerRadius = btnDrop.frame.size.height/2
        btnDrop.layer.masksToBounds = true
        btnDrop.setGradientBackground(colorOne: UIColor(displayP3Red: 255.0/255.0, green: 175.0/255.0, blue: 189.0/255.0, alpha: 1.0), colorTwo: UIColor(displayP3Red: 255.0/255.0, green: 195.0/255.0, blue: 160.0/255.0, alpha: 1.0))
        // Do any additional setup after loading the view.
        //mapView = MTMapView(frame: self.view.frame)
        self.mapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.mapWrapperView.frame.size.width, height: self.mapWrapperView.frame.size.height))
        self.mapView.delegate = self
        self.mapView.baseMapType = .standard
        //self.mapView.showCurrentLocationMarker = true
        //self.mapView.currentLocationTrackingMode = .onWithoutHeading
        
        self.mapWrapperView.insertSubview(mapView, at: 0)
        self.get_data(url:"http://openapi.seoul.go.kr:8088/4a58695859776c673734666d457554/json/bikeList/1/1000/")
        self.get_data(url:"http://openapi.seoul.go.kr:8088/4a58695859776c673734666d457554/json/bikeList/1001/2000/")
        tblView.isHidden = true
        print(1111)
        
    }
    
    @IBAction func onClickDropButton(_ sender: Any) {
        if tblView.isHidden {
            animate(toogle: true)
        } else {
            animate(toogle: false)
        }
    }
    func animate(toogle: Bool){
        if toogle{
            UIView.animate(withDuration: 0.3){
                self.tblView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3){
                self.tblView.isHidden = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var items = [MTMapPOIItem]()
        for center in self.json_data {
            let names = center["stationName"].stringValue
            let bikes = center["parkingBikeTotCnt"].intValue
            let latitudes = center["stationLatitude"].doubleValue
            let longitudes = center["stationLongitude"].doubleValue
            let count = center["parkingBikeTotCnt"].intValue
            
            items.append(poiItem(name: names, latitude: latitudes, longitude: longitudes,count:count))
            func mapView(_ mapView:MTMapView!, selectedPOIItem: MTMapPOIItem!){
                
            }
        }
        
        mapView.addPOIItems(items)
        print(22222)
    }
    
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        print(poiItem.itemName)
    }
    
    func testBalloon(name:String,count:Int) -> UIView {
        let cumView = BInfo(frame: CGRect(x:0, y:0, width:self.mapWrapperView.frame.size.width/2 , height: ( 130 / 667) * self.mapWrapperView.frame.size.height))
        cumView.title.text = name
        cumView.count.text = "\(count)"
        
        return cumView
    }
    
    func poiItem(name: String, latitude: Double, longitude: Double, count:Int) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .bluePin
        item.markerSelectedType = .redPin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .springFromGround
        //item.customImageAnchorPointOffset = .init(offsetX: 0, offsetY: 0)    // 마커 위치 조정
        item.customCalloutBalloonView = self.testBalloon(name: name,count:count)
        item.tag = 11
        
        return item
    }
    
    func get_data(url:String) {
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                self.json_data += JSON(json)["rentBikeStatus"]["row"].arrayValue
                
                print("조회완료")
            }
        }
    }
}

extension Map:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = locationList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnDrop.setTitle("\(locationList[indexPath.row])", for: .normal)
        animate(toogle: false)
        switch indexPath.row {
        case 0: // 강남구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude:37.51793751034589, longitude:127.04710178656005)), animated: true)
            
        case 1: // 강동구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude:37.53056834864736, longitude:127.1235894768229)), animated: true)
            
        case 2: // 강서구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude:37.55080964425156, longitude:126.84953407105134)), animated: true)
        case 3: // 강북구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude:37.63974952685007, longitude:127.02553240618167)), animated: true)
        case 4: // 관악구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude:37.478869190183474, longitude:126.9512042680911)), animated: true)
        case 5: // 광진구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.538564618300185, longitude:127.08238859082853)), animated: true)
        case 6: // 구로구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.495399743799666, longitude:126.8874997103906)), animated: true)
        case 7: // 금천구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.457312428413346, longitude:126.89551376688034)), animated: true)
        case 8: // 노원구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.65442933090739, longitude:127.05642939312048)), animated: true)
        case 9: // 동대문구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.574426088441584, longitude:127.0397650576841)), animated: true)
        case 10: // 도봉구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.66870492677454 , longitude:127.04720540739244)), animated: true)
        case 11: // 동작구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.51246667266131, longitude:126.93921270567112)), animated: true)
        case 12: // 마포구청
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.566267365235426, longitude:126.9019748796006)), animated: true)
        case 13: // 서대문구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.57922943213151, longitude:126.93680371632269)), animated: true)
        case 14: // 성동구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.56344612998095, longitude:127.03691826605468)), animated: true)
        case 15: // 성북구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.58935656363751, longitude:127.01669781003729)), animated: true)
        case 16: // 서초구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.483629826408794, longitude:127.03266163490697)), animated: true)
        case 17: // 송파구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.5146535598066, longitude:127.10590366840312)), animated: true)
        case 18: // 영등포구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.526386561424935, longitude:126.89629142692507)), animated: true)
        case 19: // 용산구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.53241436984936, longitude:126.9905727306506)), animated: true)
        case 20: // 양천구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.51705378186342, longitude:126.86648715391262)), animated: true)
        case 21: // 은평구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.6029187680761, longitude:126.92889049096134)), animated: true)
        case 22: // 종로구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.57313352118979, longitude:126.97920230855199)), animated: true)
        case 23: // 중구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.563837052454275, longitude:126.9975410330794)), animated: true)
        case 24: // 중랑구
            self.mapView.setMapCenter(MTMapPoint.init(geoCoord: MTMapPointGeo(latitude: 37.60672391555988, longitude:127.0927837049557)), animated: true)
        default:
            break
        }
    }
}
extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x:1.0, y:1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
