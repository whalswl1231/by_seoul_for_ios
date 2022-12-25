//
//  Main.swift
//  test
//
//  Created by 111 on 26/08/2019.
//  Copyright © 2019 111. All rights reserved.
//

//================메인 홈화면================

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import CoreMotion


protocol sendBackDelegate {
    func dataReceived(data: String)
}


class Main: BaseViewController, CLLocationManagerDelegate{
    var motionManager: CMMotionManager!
    
    @IBOutlet var kcalLabel: UILabel!
    @IBOutlet var kmLabel: UILabel! //이름label
    
    
    var data = ""
    
    var RealTime = 0
 
    var flag : Bool = false
    @IBOutlet var second_label: UILabel!//시간label
    @IBOutlet var location: UILabel!//현재위치label
    @IBOutlet var help: UILabel!//잔여시간label
    var list:[List]?
    var acceler_arr = Array<Double>()
    var time_data:[JSON] = [JSON]()
    var mTimer : Timer?
    var number = 0
    var myInt = 0
    var url_id:Int = 0
    //var kcal = 0
    var kg : String = ""
    var dustInfo:DustInfo?
    var menu_vc : MenuViewController!
    let dust_url:String = "http://openapi.seoul.go.kr:8088/4756724c44776c67383145626e4d76/json/RealtimeCityAir/1/25"
    var dust_data:[JSON] = [JSON]()
    let add:String = ""
    var locationManager:CLLocationManager!
    var current_location = "dd" //현재 주소의 구 위치
    
    @IBOutlet var accelerLabel: UILabel!//속도label
    @IBOutlet var dustLabel: UILabel!//미세먼지label
    @IBOutlet var returnBtn: UIButton!//반납하기btn
    
    var delegate: Map?
    
    //반납 버튼을 눌렀을 때
    @IBAction func returnBtn(_ sender: UIButton) {
        
        motionManager.stopAccelerometerUpdates()
        
        if let timer = mTimer {
            if(timer.isValid){
                timer.invalidate()
            }
        }
        //number = 0
        
        
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        let headers:HTTPHeaders = [
            "Authorization" : "Token \(token)", "Accept" : "application/json"]
        

        let userDefault = UserDefaults.standard
        
        let id = userDefault.value(forKey: "id") as! String
        let id_data:Data = id.data(using: .utf8)!
        
        let today = NSDate() //현재 시각 구하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        var dateString = dateFormatter.string(from: today as Date)
        print(dateString)
        let date_data:Data = dateString.data(using: .utf8)!
        
        let hour : String = "\(number / 60)"
        let hour_data:Data = hour.data(using: .utf8)!
        
        let kcal:String! = "10"
        let kcal_data:Data = kcal.data(using: .utf8)!
       
        
        var acceler_avg : Double = 0
        
        for i in 0..<acceler_arr.count{
            acceler_avg += acceler_arr[i]
            if (i == acceler_arr.count-1){
                acceler_avg = round((acceler_avg/Double(acceler_arr.count))*1000)/1000
                
            }
        }
        print("속도 평균 : \(acceler_avg)")
        var km : String = "\(Double((number / 60)) * acceler_avg)"
        print("km============:\(km)")
        let km_data : Data = km.data(using: .utf8)!
        
        
        
        Alamofire.upload(multipartFormData:{
            (multipartFormData) in multipartFormData.append(id_data, withName: "record_id")
            multipartFormData.append(hour_data, withName: "time") //db에 소요시간 저장
            multipartFormData.append(date_data, withName: "date") //db에 날짜 저장
            multipartFormData.append(kcal_data, withName: "kal") //db에 칼로리 저장
            multipartFormData.append(km_data, withName: "km") //db에 km 저장
        }, to: AppDelegate.server_url+"bicycle/record/",method:.post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    debugPrint(response)
                    print("시간저장성공")
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //속도 구하기
    func outputAccelerationData(acceleration: CMAcceleration){
        let ouracceleration = floor((acceleration.x) * 100)/100
        print("x = \(ouracceleration)")
        if(ouracceleration>0){ //가속도가 0 이상일때만 저장&보여줌(핸드폰이 뒤로 가면 x값이 음수가 나올수있기때문)
            self.accelerLabel.text = "\(ouracceleration)"
            
            acceler_arr.append(ouracceleration)//속도평균을 구하기 위해서 배열에 속도들을 추가
            
        }else{
            self.accelerLabel.text = "0"
        }
    }
    
    
    //var locationManager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.getidData()
        
        
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        let headers:HTTPHeaders = [
            "Authorization" : "Token \(token)", "Accept" : "application/json"]
        let userDefault = UserDefaults.standard
        let id = userDefault.value(forKey: "id") as! String
        kmLabel.text = id

        
        
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 3
        
        
        //네비게이션바 색
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 89/255, green: 187/255, blue: 74/255, alpha: 1.0)
        
        guard
            let navigationController = navigationController,
            let flareGradientImage = CAGradientLayer.primaryGradient(on: navigationController.navigationBar)
            else {
                print("Error creating gradient color!")
                return
        }
        
        navigationController.navigationBar.barTintColor = UIColor(patternImage: flareGradientImage)
        
        
        //로고
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "app"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 110, bottom: 10, right: 120)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button
        
        
        self.get_dust(url:"http://openapi.seoul.go.kr:8088/4756724c44776c67383145626e4d76/json/RealtimeCityAir/1/25")
        
        //햄버거버튼
        addSlideMenuButton()
    }
    
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
                        }
                    }
                } catch{
                    print(error)
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
    
    
    //로고버튼 눌렀을때
    @objc func clickOnButton(){
        let mainStoryboard:UIStoryboard = UIStoryboard(name : "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "mainpage") as! Main
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("시작")
        
        second_label.text = data
        if flag == true {
            print("TRUE")
            if let timer = mTimer {
                //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
                if !timer.isValid {
                    /** 1초마다 timerCallback함수를 호출하는 타이머 */
                    mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
                }
            }else{
                //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
                /** 1초마다 timerCallback함수를 호출하는 타이머 */
                mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            }
        }
    }
    
    
    @objc func timerCallback(){
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {accelerometerData, error in self.outputAccelerationData(acceleration: (accelerometerData?.acceleration)!)})
        
        
        var kcal : Double // 칼로리 계산 때문에 double 형으로
        var doubleKg = Int(kg)! // String인 kg을 계산을 위해 int 형으로
        var realKcal : String // 칼로리 String으로 받기
        
        number += 1
        data = String(number)
        second_label.text = data
        
        kcal = Double(doubleKg * number) * 0.17 / 3600 // 칼로리 계산
        realKcal = String(format: "%.1f",  kcal) // 소수점 1자리까지
        print(realKcal)
        kcalLabel.text = String(realKcal)
        

        // 1분씩 감소
        if number % 60 == 0 {
            RealTime - (number / 60)
            help.text = String(RealTime - (number / 60))
            
            if help.text == "10"{
                let alert = UIAlertController(title: "알림", message: "따릉이 시간이 10분 남았습니다.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
                    print("알람 뜬다 키키")
                    //performSegue(withIdentifier: "back", sender: self)
                    let webPage = self.storyboard?.instantiateViewController(withIdentifier: "map")
                    self.present(webPage!, animated: true, completion: nil)
                    

                }
                alert.addAction(defaultAction)
                present(alert, animated: false, completion: nil)
                
            }
        }
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get_dust(url:String) { //미세먼지 api
        
       
        // Do any additional setup after loading the view, typically from a nib.
                // 현재 위치 가져오기
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization() //권한 요청
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation() //위치 업데이트
                
                let coor = locationManager.location?.coordinate
                let latitude = 37.548757
                let longitude = 127.053639
                 
                let findLocation = CLLocation(latitude: latitude, longitude: longitude)
                let geocoder = CLGeocoder()
                let locale = Locale(identifier: "Ko-kr")
                geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
                    if let address: [CLPlacemark] = placemarks {
                        if let name: String = address.last?.name {
                            print(name)
                            self.location.text = name
                        }
                        print("시 : \(address.last?.administrativeArea)")
                        print("구 : \(address.last?.locality)")
                        self.current_location = address.last?.locality as! String
                        
                        
                        Alamofire.request(url).responseJSON { response in
                            if let json = response.result.value {
                                self.dust_data += JSON(json)["RealtimeCityAir"]["row"].arrayValue
                                print("현재 위치 미세먼지")
                                print(self.dust_data[1]["PM10"])
                                print(self.dust_data[7]["MSRSTE_NM"])
                            }
                            print("위치 : " + self.current_location)
                            for i in 0..<(self.dust_data.count) {
                                
                                if self.dust_data[i]["MSRSTE_NM"].string == self.current_location {
                                    print("일치합니다")
                                    print(self.dust_data[i]["PM10"])
                                    //미세먼지레이블에 텍스트 대입
                                    self.dustLabel.text = "\(self.dust_data[i]["PM10"])"
                                }
                            }
                            
                            
                            guard let data: Data = response.data else {
                                return
                            }
                            let decoder = JSONDecoder()
                            do{
                                //print(String(data:data, encoding: .utf8))
                                print("\(self.dust_data[1]["PM10"])")
                                self.dustInfo = try decoder.decode(DustInfo.self, from: data)
                                //미세먼지레이블에 텍스트 대입
                                //self.dustLabel.text = "\(self.dust_data[1]["PM10"])"
                                print("")
                                
                            } catch{
                                print(error)
                                print(error.localizedDescription)
                            }
                        }
                        
                    }
                })
            
            
        }
    
    
    //시간 가져와서 레이블에 표시하기
    func get_time(url:String) {
        Alamofire.request(url).responseJSON { response in
            if response.data != nil {
                let data = response.data
                let json = JSON(data)
                let time = json["time"].stringValue
                var realtime = Int(time)
                if realtime != nil {
                    realtime = realtime!
                    self.help.text = "\(realtime!)"
                }
                self.RealTime = realtime!
            }
        }
    }
    
}
    


extension CAGradientLayer {
    
    class func primaryGradient(on view: UIView) -> UIImage? {
        let gradient = CAGradientLayer()
        let flareRed = UIColor(displayP3Red: 171.0/255.0, green: 203.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        let flareOrange = UIColor(displayP3Red: 138.0/255.0, green: 221.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        var bounds = view.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        gradient.colors = [flareRed.cgColor, flareOrange.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        return gradient.createGradientImage(on: view)
    }
    
    private func createGradientImage(on view: UIView) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}
