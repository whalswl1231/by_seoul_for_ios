//
//  SnsViewController.swift
//  test
//
//  Created by user on 18/09/2019.
//  Copyright © 2019 111. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class SnsViewController: BaseViewController{
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var upload_btn: UIButton!
    @IBOutlet var add_btn: UIButton!
    @IBOutlet var imageView1: UIImageView!
    //이미지 골라주는 애
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.backgroundColor = .white
        textView.delegate = self
        
        if (textView.text == ""){
            textViewDidEndEditing(textView)
        }
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
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
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 100, bottom: 5, right: 100)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        navigationItem.titleView = button
        
        //네비게이션바에 햄버거 아이콘 추가
        addSlideMenuButton()
        picker.delegate=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //네비게이션 로고 눌렀을때
    @objc func clickOnButton(){
        let mainStoryboard:UIStoryboard = UIStoryboard(name : "Main", bundle: nil)
        let DVC = mainStoryboard.instantiateViewController(withIdentifier: "mainpage") as! Main
        self.navigationController?.pushViewController(DVC, animated: true)
    }
    
    //업로드버튼
    @IBAction func upLoad(_ sender: UIButton) {
        guard let token = UserDefaults.standard.string(forKey: "token") else{
            print("토큰 없음")
            return
        }
        let headers:HTTPHeaders = [
            "Authorization" : "Token \(token)", "Accept" : "application/json"]
        let userDefault = UserDefaults.standard
        let id = userDefault.value(forKey: "id") as! String
        let id_data:Data = id.data(using: .utf8)!
        let textMemo : String = textView.text
        let textMemo_data:Data = textMemo.data(using: .utf8)!
        
        print(textMemo_data)
        
        let selected_Image = imageView1.image
        let imgData = (imageView1.image?.jpegData(compressionQuality: 0.8))!
        
        Alamofire.upload(multipartFormData:{
            (multipartFormData) in
            multipartFormData.append(id_data, withName: "sns_id")
            multipartFormData.append(textMemo_data, withName: "text")
            multipartFormData.append(imgData, withName: "picture",fileName: "swift_file.jpeg", mimeType: "image/jpeg")
        }, to: AppDelegate.server_url+"bicycle/sns/",method:.post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON{
                    response in
                    debugPrint(response)
                    print("게시물 저장 성공")
                    let mainStoryboard:UIStoryboard = UIStoryboard(name : "Main", bundle: nil)
                    let DVC = mainStoryboard.instantiateViewController(withIdentifier: "SnsHomeViewController") as! SnsHomeViewController
                    self.navigationController?.pushViewController(DVC, animated: true)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    //add버튼
    @IBAction func addAction(_ sender: Any) {
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
            
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboard(){
        textView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == ""){
            textView.text = "오늘의 러닝을 기록하세요!"
            textView.textColor = UIColor.gray
        }
        textView.resignFirstResponder()
        
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "오늘의 러닝을 기록하세요!"){
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    //라이브러리 열기
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    //카메라 열기
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
            
        else{
            print("Camera not available")
        }
    }
    
}
// 사진을 선택해서 imageView에 넣음
extension SnsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate{
    
    func imagePickerController(_ _picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey:Any]){
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageView1.image = selectedImage
        
        print("사진이 선택됨")
        print(info)
        dismiss(animated: true, completion: nil)
        
    }
    
    //info의 값을 UIImage로 가져온다.
    
    
    
    
    
    
    
}
