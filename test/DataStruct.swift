//
//  DataStruct.swift
//  test
//
//  Created by 111 on 27/08/2019.
//  Copyright © 2019 111. All rights reserved.
//

import Foundation

struct Token:Codable {
    var token:String
}

struct bikeInfo:Codable {
    var stationLatitude:Float? //위도
    var stationLongitude:Float? //경도
    var stationId:String? //대여소 정보
    var parkingBikeTotCnt:Int? //사용가능한 자전거의 수
    var stationName:String? // 대여소 이름
    var rackTotCnt:Int? //자전거의 총 수
    var shared:Int? //거치율
}

struct Record:Codable {
    var record_id:String
    var date:String
    var time:String
    var kal:String
    var km:String
}

struct Sns:Codable{
    var sns_id:String
    var text:String
    var picture:String?
}

struct Booking:Codable {
    var mypage_id:String
    var buy_date:String
    var mypage_time:String
}
struct Timeshare:Codable {
    var timeshare_id:String
    var timeshare_time:String
}

struct List:Codable {
    var id:Int
    var username:String
}

struct DustInfo:Codable {
    var MSRSTE_NM:String? //지역구
    var PM10:Int? //미세먼지 수치
}

