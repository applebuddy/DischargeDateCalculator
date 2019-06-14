//
//  ViewController.swift
//  Navigation
//
//  Created by Min Kyeong Tae on 01/12/2018.
//  Copyright © 2018 Min Kyeong Tae. All rights reserved.
//
import GoogleMobileAds
import UIKit

//최대 복무단축기간이 되었는지를 판별하는 함수
func verifyMaxDateValue(optionCode: String, deDateValue: Int) -> Bool{
    
    switch optionCode {
    case "Army", "Navy":
        if(deDateValue >= 90){
            return true
        }else{
            return false
        }
    case "Airforce":
        if(deDateValue >= 60){
            return true
        }else{
            return false
        }
        
    default:
        if(deDateValue >= 90){
            return true
        }else{
            return false
        }
    }
}
//군 복무 단축일수를 계산하는 함수
func reducingDateVerifier(verifyDate: Int, optionCode: String, preDateValue: Date) -> Int{
    
    //~육군/해병대의 경우~
//    2017년 1월 3일부터 14일씩 끝어가며 늦게 입대할 수록 단축일수가 1씩 증가한다.
  //  print("육군,해병대 복무단축기준날짜 대비 지난시간 : \(verifyDate)")
    let vDate = (verifyDate/14)+1
    
    
    switch optionCode {
    case "Army", "Navy":
        if(vDate > 0){
            if(vDate <= 90){
                //     print("육군,해병대 해당 기간의 복무단축일수 : \(vDate)")
                return vDate
            }else{

                return 90
            }
        }else{
            return 0
        }
    case "Airforce":
        if(vDate > 0){
            if(vDate <= 60){ //공군의 경우, 장기적 복무 단축일이 60일에 불과하므로 따로 복무단축 알고리즘을 설정한다.
                
                return vDate
            }else{
//                dateValue2.addTimeInterval(TimeInterval(-60*60*24))
                return 60
            }
        }else{
            return 0
        }

    default:
        if(vDate > 0){
            if(vDate <= 90){
                //     print("육군,해병대 해당 기간의 복무단축일수 : \(vDate)")
                return vDate
            }else{
                //     print("육군,해병대 해당 기간의 복무단축일수(90일) : \(vDate)")
                return 90
            }
        }else{
            return 0
        }
    }
}





class PickerViewController: UIViewController, GADInterstitialDelegate {
    
    //전면광고 객체 생성
    var interstitial: GADInterstitial!
    
    
    @IBOutlet var dischargeDatePickerView: UIDatePicker!
    @IBOutlet var selectedDateInfoLabel: UILabel!//데이터피커로 설정된 날짜 표시라벨
    @IBOutlet var preDischargeDateResultLabel: UILabel!//입대일을 표시하는 라벨
    @IBOutlet var currentRemainDateResultLabel: UILabel!//남은 전역일을 표시하는 라벨
    
    @IBOutlet var currentDateInfoLabel: UILabel! //현재 날짜를 표시하는 라벨
    @IBOutlet var optionInfoLabel: UILabel!//선택된 복무분류 나타내는 라벨
    @IBOutlet var dischargeRemainInfoLabel: UILabel!
    
    
    //계산기 화면 배경 이미지를 받는 변수, imgCalcViewBg
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var selectArmyButton: UIButton!
    @IBOutlet var selectNavyButton: UIButton!
    @IBOutlet var selectAirforceButton: UIButton!
    @IBOutlet var dateCalcButton: UIButton!
    
    //계산결과에 대한 공지를 알리는 팝업 이미지뷰 아웃렛변수
    @IBOutlet var popupNoticeImageView: UIImageView!
    
    @IBOutlet weak var subTitle1Label: UILabel!
    @IBOutlet weak var subTitle2Label: UILabel!
    @IBOutlet weak var subTitle3Label: UILabel!
    @IBOutlet weak var subTitle4Label: UILabel!
    @IBOutlet weak var subTitle5Label: UILabel!
    @IBOutlet weak var subTitle6Label: UILabel!
    
    
    //팝업 이미지 담는 변수
    var noticePopupImg: UIImage?
    var calcViewBg: UIImage?
    var calcNoticeAlarm: UIAlertController?
//    var calcNoticeFadeOutAction:
    
    var isSelectedDate: Bool? //피커데이터뷰가 설정됐는지를 판단하는 불 변수
    var deDateValue: Int?
   
    var datePickerView = UIDatePicker()
    
    //dateValue2는 현재설정한 데이트피커뷰의 시간값에 특정 복무일만큼의 일 수를 추가시킨다.(60초*60분*24시간*~~일)
    var dateValue2 = Date()
    
    
    
    
    //날짜 설정 포맷을 지정하기 위한 DateFormatter 객체
    let formatter = DateFormatter()
    let formatter2 = DateFormatter()
    var dateValueNow: Date =  NSDate() as Date
    var optionCode: String = "Army"
    //날짜를 출력하기 위하여 DateFormatter라는 클래스 상수 formatter를 선언합니다.
    //입대일에 따른 복무단축기간을 가려내기 위한 변수 20170103이 되어야한다.
    var verifyStandardDate: Date = NSDate(timeIntervalSinceReferenceDate: 60*60*24*5846) as Date

    
//     var verifiValue: Int?
    var isDateOne: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        //ca-app-pub-1161737894053314/7030018412 => 실 사용해야하는 ID
        //ca-app-pub-3940256099942544/4411468910 => 테스트용 광고 ID
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1161737894053314/7030018412")
//        interstitial.load(request) //테스트 필요.
        let request = GADRequest()
        
        interstitial.load(request) //테스트 필요.
        interstitial.delegate = self
        self.navigationItem.title = "전역일 계산하기"
        self.selectedDateInfoLabel.adjustsFontSizeToFitWidth = true
        self.currentDateInfoLabel.adjustsFontSizeToFitWidth = true
        self.preDischargeDateResultLabel.adjustsFontSizeToFitWidth = true
        self.currentRemainDateResultLabel.adjustsFontSizeToFitWidth = true
        self.subTitle1Label.adjustsFontSizeToFitWidth = true
        self.subTitle2Label.adjustsFontSizeToFitWidth = true
        self.subTitle3Label.adjustsFontSizeToFitWidth = true
        self.subTitle4Label.adjustsFontSizeToFitWidth = true
        self.subTitle5Label.adjustsFontSizeToFitWidth = true
        self.subTitle6Label.adjustsFontSizeToFitWidth = true
        
        
        //팝업창 지워진 후 버튼들이 생겨서 작동되게 한다.
        dischargeDatePickerView.isHidden = true
        selectArmyButton.isHidden = true
        selectNavyButton.isHidden = true
        selectAirforceButton.isHidden = true
        dateCalcButton.isHidden = true

        
        //아직 초기에는 입대일 설정을 안한상태이므로 false값을 준다.
        isSelectedDate = false

        
        //계산결과에 대한 이미지 팝업을 띄우기 위한 코딩
        noticePopupImg = UIImage(named: "armyNoticeImg.png")
        popupNoticeImageView.image = noticePopupImg
        
        //경고메세지를 띄우기 위한 UIAlertController객체의 생성
        calcNoticeAlarm = UIAlertController(title: "*주의 사항*", message: "입대일을 설정해주시기 바랍니다..", preferredStyle: UIAlertController.Style.alert)
        //경고메세지에 대한 액션이벤트를 적용하기 위한 UIAlertAction객체의 생성
        
        
        let onNoticeAlarmAction = UIAlertAction(title: "네 알겠습니다 :)", style: UIAlertAction.Style.default, handler: nil)
        //경고메세지에 대한 세부 액션(확인응답 받는)을 추가
        calcNoticeAlarm?.addAction(onNoticeAlarmAction)
        //경고메세지를 띄운다.
 
        //계산화면 배경화면 이미지 삽입
        calcViewBg = UIImage(named: "mainBackground.png")
        backgroundImageView.image = calcViewBg

        formatter.dateFormat = "yyyy-MM-dd EEE" + "요일"
        formatter.locale = Locale(identifier: "ko_KR") //데이트 포맷을 한국어로 바꾸고 싶을때! ex) fr_FR /
        formatter2.dateFormat = "DDD"
        
        //formatter의 dateFormat 속성을 설정합니다. ~~년 - ~~월 - ~~일 -- ~~요일 포맷설정.
        
        //현재 어플 실행날짜를 출력한다.
        currentDateInfoLabel.text = formatter.string(from: dateValueNow)
        optionInfoLabel.text = "육군"
        
        self.initButtonBackground()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initButtonBackground() {
        self.selectArmyButton.backgroundColor = UIColor(displayP3Red: 100/255, green: 230/255, blue: 100/255, alpha: 130/255)
        self.selectNavyButton.backgroundColor = UIColor(red: 230/255, green: 200/255, blue: 200/255, alpha: 50/255)
        self.selectAirforceButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 230/255, alpha: 50/255)
    }
    
    //입대일 설정하는 데이트피커
    @IBAction func changeTimePicker(_ sender: UIDatePicker) {
        datePickerView = sender
        //데이트 피커를 선택할 때 발생하는 액션 함수인 'changeDayePicker'가 호출되면서 sender라는 UIDatePicker 자료형의 인수가 전달됩니다. 이 sender를 datePickerView라는 상수에 저장합니다.
        //데이트피커뷰를 설정 했으므로, isSlelctedDate 값을 true로 바꿔준다.
        isSelectedDate = true

        selectedDateInfoLabel.text = formatter.string(from: datePickerView.date)
        currentRemainDateResultLabel.text = ""
        //dateValue는 현재 설정한 데이트피커뷰의 시간값을 갖는다.
        let dateValue = datePickerView.date
        //dateValue2는 현재설정한 데이트피커뷰의 시간값에 특정 복무일만큼의 일 수를 추가시킨다.(60초*60분*24시간*~~일)
        dateValue2 = datePickerView.date
        //deDateValue는 현재 설정한 데이트 -1 값을 가진다 (1일 일때만 쓴다.)
    //    var dateValue3 = datePickerView.date.addingTimeInterval(-60*60*24)
        
        
        //    print("전역예정일(dateValue2) 1 : \(dateValue2)")
        let cal = Calendar(identifier: .gregorian) //블로그 참고 \"https://www.clien.net/service/board/cm_app/10761680\" 그레고리력으로 되어있는 캘린더 함수
        //현재 데이트피커로 설정한 시간값을 갖고 있는 컴포넌트, componentsNow
        //현재 데이트피커로 설정한 시간값을 갖고 있는 컴포넌트, components2 => 이건 변합니다. 따로 연산하는데 씀 연산해서 뭐하는데 쓰지
        let componentsNow = cal.dateComponents(in: TimeZone.current, from: dateValue as Date)
        var components2 = cal.dateComponents(in: TimeZone.current, from: dateValue as Date)
//        var components2 = cal.dateComponents(in: TimeZone.current, from: dateValue3 as Date)//1일일 경우, 하루 빠진 값을 갖는 데이트 컴포넌트
        
        
        if(optionCode == "Army"){   //////////////////육군 ~ 해병대 기준 전역예정일 계산////////////////////////
            
            //육군 복무단축시작 기준일은 2016년 11월 03일
            verifyStandardDate = NSDate(timeIntervalSinceReferenceDate: 60*60*24*5846) as Date
            print("Army verifyStandardDate : \(verifyStandardDate)")
            
  
            //////////육군 ~ 해병대 기준 전역예정일 계산////////////////////////
            // 1)년도는 1년1월 -> 2년10월 / 1년2월 -> 2년11월 / 1년3월 -> 2년12월 / 1년4월 -> 3년1월 / 1년5월 -> 3년2월 / 1년6월 -> 3년3월 / 1년7월 -> 3년4월
            //1년8월 -> 3년5월 / 1년9월 -> 3년6월 / 1년10월 -> 3년7월 / 1년11월 -> 3년8월 / 1년12월 -> 3년9월
            
            //@@@@@@@@@ 만약 입대일자가 xx월 1일 이라면 아래 연산을 취한다. @@@@@@@@@@@@@@@@
            
            
            // 2)먼저 1년을 더해준 뒤 시작한다.
            components2.year! = (componentsNow.year!)+1
            //        components2.year! = (componentsNow.year!)+1
            
            if((componentsNow.day!) == 1){
                
                isDateOne = true
                //   components2 = datePickerView.date.addingTimeInterval(-60*60*24)
                
                
                if(componentsNow.month!>3){//3)2보다 클 경우에는 2를 그냥 빼줘도 마이너스 달 값이 나지 않는다.
                    components2.year! = components2.year! + 1 //1년 마저 더해준다.
                    components2.month = componentsNow.month!-3 //2개월을 빼고,
                }else{//4)2보다 작을 경우에는
                    components2.month = 12 + (componentsNow.month!-3) //5)12월 - (기존 달값에 2를 뺀 값)
                }
                
                //   components2.day! = 1 //1일로 바꿔 버린 뒤 이걸 Date 변수에 씌울 수 있으면 그 뒤에 하루를 빼버리는 거야1!
                print("\n### components22 ### : \(components2)")
                
                dateValue2 = components2.date!
                
                
            }else{//xx월 1일을 제외하고는
                
                isDateOne = false
                
                if(componentsNow.month!>2){//3)2보다 클 경우에는 2를 그냥 빼줘도 마이너스 달 값이 나지 않는다.
                    components2.year! = components2.year! + 1 //1년 마저 더해준다.
                    components2.month = componentsNow.month!-3 //2개월을 빼고,
                }else{//4)2보다 작을 경우에는
                    components2.month = 12 + (components2.month!-3) //5)12월 - (기존 달값에 2를 뺀 값)
                }
                
                //5)날짜는 입대일 '일' 값의 -1 값이다.
                components2.day = (componentsNow.day!-1)
                dateValue2 = components2.date!
                print("\n### components2 ### : \(components2)")
                print("components2.date!의 값은? : \(components2.date!)")
                
                
            }
            
        }else if(optionCode == "Navy"){//////////////////해군 기준 전역예정일 계산////////////////////////
            
            //해군 복무단축시작 기준일은 2017년 1월 3일
            verifyStandardDate = NSDate(timeIntervalSinceReferenceDate: 60*60*24*5785) as Date
            print("Navy verifyStandardDate : \(verifyStandardDate)")
            
            
            //////해군 전역 예정일 연산하기/////
            // 2)먼저 1년을 더해준 뒤 시작한다.
            components2.year! = (componentsNow.year!)+1
            //        components2.year! = (componentsNow.year!)+1
            
            if((componentsNow.day!) == 1){
                
                isDateOne = true
                //   components2 = datePickerView.date.addingTimeInterval(-60*60*24)
                
                
                if(componentsNow.month!>1){//3)2보다 클 경우에는 2를 그냥 빼줘도 마이너스 달 값이 나지 않는다.
                    components2.year! = components2.year! + 1 //1년 마저 더해준다.
                    components2.month = componentsNow.month!-1 //2개월을 빼고,
                }else{//4)2보다 작을 경우에는
                    components2.month = 12 + (componentsNow.month!-1) //5)12월 - (기존 달값에 2를 뺀 값)
                }
                
                //   components2.day! = 1 //1일로 바꿔 버린 뒤 이걸 Date 변수에 씌울 수 있으면 그 뒤에 하루를 빼버리는 거야1!
                print("\n### components22 ### : \(components2)")
                
                dateValue2 = components2.date!
                
                
            }else{//xx월 1일을 제외하고는
                
                isDateOne = false
                
                if(componentsNow.month!>1){//3)2보다 클 경우에는 2를 그냥 빼줘도 마이너스 달 값이 나지 않는다.
                    components2.year! = components2.year! + 1 //1년 마저 더해준다.
                    components2.month = componentsNow.month!-1 //2개월을 빼고,
                }else{//4)2보다 작을 경우에는
                    components2.month = 12 + (components2.month!-1) //5)12월 - (기존 달값에 2를 뺀 값)
                }
                
                //5)날짜는 입대일 '일' 값의 -1 값이다.
                components2.day = (componentsNow.day!-1)
                dateValue2 = components2.date!
                print("\n### components2 ### : \(components2)")
                print("components2.date!의 값은? : \(components2.date!)")
                
                
            }
            
            
        }else{//////////////////공군 기준 전역예정일 계산////////////////////////
            
            //////공군 전역 예정일 연산하기/////
            //공군 복무단축시작 기준일은 2017년 1월 3일
            verifyStandardDate = NSDate(timeIntervalSinceReferenceDate: 60*60*24*5754) as Date
            print("Airforce verifyStandardDate : \(verifyStandardDate)")
            
            //2025년 1월1일 => 2월1일 => 3월1일 => 4월1일 => 5월1일 => 6월1일
            
            
            // 2)먼저 1년을 더해준 뒤 시작한다.
            components2.year! = (componentsNow.year!)+1
            //        components2.year! = (componentsNow.year!)+1
            
            if((componentsNow.day!) == 1){
                
                isDateOne = true
                //   components2 = datePickerView.date.addingTimeInterval(-60*60*24)
                
                
                if(componentsNow.month!>1){//3)2보다 클 경우에는 2를 그냥 빼줘도 마이너스 달 값이 나지 않는다.
                    components2.year! = components2.year! + 1 //1년 마저 더해준다.
//                    components2.month = componentsNow.month! //
                }else{//4)2보다 작을 경우에는
                    components2.year! = components2.year! + 1
                    components2.month = 1 //5)12월 - (기존 달값에 2를 뺀 값)
                }
                
                //   components2.day! = 1 //1일로 바꿔 버린 뒤 이걸 Date 변수에 씌울 수 있으면 그 뒤에 하루를 빼버리는 거야1!
                print("\n### components22 ### : \(components2)")
                
                dateValue2 = components2.date!
                
                
            }else{//xx월 1일을 제외하고는
                
                isDateOne = false
//
//                if(componentsNow.month!<=2){//3)2보다 클 경우에는 2를 그냥 빼줘도 마이너스 달 값이 나지 않는다.
////                    components2.year! = components2.year! + 1 //1년 마저 더해준다.
//                    components2.month = componentsNow.month!+10 //2개월을 빼고,
//                }else{//4)2보다 작을 경우에는
                    components2.year! = components2.year! + 1 //1년 마저 더해준다.
//                    components2.month = 12 - (components2.month!-3) //5)12월 - (기존 달값에 2를 뺀 값)
//                }////개껌////
                
                //5)날짜는 입대일 '일' 값의 -1 값이다.
                components2.day = (componentsNow.day!-1)
                dateValue2 = components2.date!
                print("\n### components2 ### : \(components2)")
                print("components2.date!의 값은? : \(components2.date!)")
                
                
            }
        }
     
        //21개월 기준
        //2020년 10월 2일 => 2022년 8월 1일
        //2021년 2월 15일 => 2023년 11월 14일
        //2021년 7월 1일 => 2023년 4월 말일.
        
        print("componentNow : \(componentsNow)")
        
        //UIDatePicker 변수 값에 dateComponents 변수값을 넣는 방법.
        var tempCal = components2.calendar
        tempCal!.locale = Locale(identifier:"ko_KR")
        let tempCom = DateComponents(calendar : tempCal, year : components2.year, month : components2.month, day : components2.day, hour : components2.hour)
        dateValue2 = tempCal!.date(from : tempCom)!
        if((isDateOne) && (components2.day! == 1)){
            dateValue2.addTimeInterval(TimeInterval(-60*60*24))
        }
        
        print("components2.value : \(components2.value)")
        
        
        
        print("\n\n %%% components2의 년 %%% : \(components2.year!), 월 : \(components2.month!), 일 : \(components2.day!) \n\n")
        //  dateValue2.addTimeInterval(TimeInterval(60*60*24)) //24시간 빼기 r꼼수
        print("복무단축 적용 후의 전역예정일 값 이 떠야하는데...\n \(dateValue2)")
        
        //현재 전역 예정일이 나오게 출력하기
        
        //복무단축시작 기준일 ~ 입대날짜 사이의 값을 넣습니다. => 이 값은 내려가면
        let verifiValue = cal.dateComponents([.day], from: verifyStandardDate, to: dateValue)
        //* deDateValue는 설정한 입대값 기준에 따른 복무단축일 연산결과를 갖고 있습니다. 이 정보를 이용해 입대날짜 별 복무단출일수를 산출합니다. (reducingDateVerifier(verifyDate: Day))
//        verifyValue
        print("verifyValue : \(verifiValue)")

        deDateValue = reducingDateVerifier(verifyDate: verifiValue.day!, optionCode: optionCode, preDateValue: dateValue2)
        
        
        //최대 복무단축기간이 설정됬을 경우 특정 요일을 빼준다. 복무 종류 별 필터링 작업
        if(verifyMaxDateValue(optionCode: optionCode, deDateValue: deDateValue!)){///최대 복무단축기간인 시점 이후의 적용 알고리즘을 설정
            //ㅅㅂ
            
            if((optionCode == "Army")||(optionCode == "Navy")){
                dateValue2.addTimeInterval(TimeInterval(-60*60*48))
            }else{
                dateValue2.addTimeInterval(TimeInterval(-60*60*24))
            }
            
        }
        
        
        
        //dateValueNow는 현재시간 값, dateValue는 전역일 값 이 둘을 빼면, 전역까지 남은 시간이다.
        var components = cal.dateComponents([.day], from: dateValueNow, to: dateValue2)
        
//        print("components.day : \(components.day!)")
        if components.day ?? 0 < 0 {
            subTitle6Label.text = "전역일 지난 날짜 : "
            currentRemainDateResultLabel.text = String(describing: (-1)*(components.day!))//전역까지 남은 날 수가 떠야하는데....
            
            // print("입대일~전역일 사이 남은 날 수 계산 : \(components)")
        }else{
            
            // print("복무단축 적용 전의 전역예정일 값, \(dateValue2)")
            
           
            
            //전역예정일 값에 복무단축일을 적용한다.
            dateValue2.addTimeInterval(TimeInterval(-60*60*24*(deDateValue!)))
            
            subTitle6Label.text = "전역일 남은 날짜 : "
            currentRemainDateResultLabel.text = String(String(describing: components.day!) + " - " + String(describing: deDateValue!) + " = " + String(describing: components.day!-deDateValue!) + "일")//전역까지 남은 날 수가 떠야하는데....
            
            currentRemainDateResultLabel.textColor = UIColor(displayP3Red: 50/255, green: 50/255, blue: 200/255, alpha: 1)

        }



        //전역 예정일의 계산값을 출력하게 설정
        preDischargeDateResultLabel.text = formatter.string(from: dateValue2) //전역예정일이 나와야 한다.
        //계산하기 버튼을 누르기 전까진 가려놓는다. => 현재 시간 값을 디폴트 값으로 넣어둔다
        preDischargeDateResultLabel.isHidden = true
        currentRemainDateResultLabel.isHidden = true
    }
    

    
    //"계산하기" 버튼을 누르면 실행하는 액션함수
    @IBAction func calculatingDateBtn(_ sender: UIButton) {

        if isSelectedDate==true{//입대일이 설정 되어있을 경우 계산결과 값을 보여준다.
            let randomNo: UInt32 = arc4random_uniform(10) //0~6 까지의 값이 랜덤으로 생성되어 randomNo에 들어갑니다.
            
            //이때 랜덤한 확률로 광고가 게제된다.
            if(randomNo == 1){
           
            interstitial.present(fromRootViewController: self)
                print("AD Init!!")
            }

        preDischargeDateResultLabel.isHidden = false
        currentRemainDateResultLabel.isHidden = false
//
        }else{ //입대일이 설정되어있지 않을 경우 계산결과 값을 보여줄 수 업삳. 입대일을 설정해달라고 한다.
//
                present(calcNoticeAlarm!, animated: true, completion: nil)
//
        }
    
    }
    
    //육/해/공 분류버튼을 누를때 발동하는 액션 함수
    @IBAction func btnArmyOption(_ sender: UIButton) {


        
        optionCode = "Army"
        optionInfoLabel.text = "육군"
        selectArmyButton.backgroundColor = UIColor(displayP3Red: 100/255, green: 230/255, blue: 100/255, alpha: 130/255)
        selectNavyButton.backgroundColor = UIColor(red: 230/255, green: 200/255, blue: 200/255, alpha: 50/255)
        selectAirforceButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 230/255, alpha: 50/255)
        
        //육/해/공 선택 버튼을 누를때 날짜설정과 같은 반응을 하게 설정
        changeTimePicker(datePickerView)

        
    }
    @IBAction func btnNavyOption(_ sender: UIButton) {

        optionCode = "Navy"
        optionInfoLabel.text = "해군"
        selectArmyButton.backgroundColor = UIColor(displayP3Red: 100/255, green: 230/255, blue: 100/255, alpha: 50/255)
        selectNavyButton.backgroundColor = UIColor(red: 250/255, green: 200/255, blue: 200/255, alpha: 130/255)
        selectAirforceButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 230/255, alpha: 50/255)
        
        //육/해/공 선택 버튼을 누를때 날짜설정과 같은 반응을 하게 설정
        changeTimePicker(datePickerView)
    }
    @IBAction func btnAirforceOption(_ sender: UIButton){
        
        optionCode = "Airforce"
        optionInfoLabel.text = "공군"
        selectArmyButton.backgroundColor = UIColor(displayP3Red: 100/255, green: 230/255, blue: 100/255, alpha: 50/255)
        selectNavyButton.backgroundColor = UIColor(red: 230/255, green: 200/255, blue: 200/255, alpha: 50/255)
        selectAirforceButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 230/255, alpha: 130/255)
        
        //육/해/공 선택 버튼을 누를때 날짜설정과 같은 반응을 하게 설정
        changeTimePicker(datePickerView)
    }


    //공지 이미지 페이드아웃 함수
    func noticeImgFadeOut() -> Void {
        
        //팝업창 이미지가 지워진 후 버튼들이 생겨서 작동되게 한다.
        dischargeDatePickerView.isHidden = false
        selectArmyButton.isHidden = false
        selectNavyButton.isHidden = false
        selectAirforceButton.isHidden = false
        dateCalcButton.isHidden = false
        
        //공지 이미지 페이드아웃 시키기 구현
        UIView.animate(withDuration: 0.6, animations: ({
            self.popupNoticeImageView.alpha = 0
            
        }))
    }
    //광고가 끝난 뒤 재로드 중 사용하는 함수
    //ca-app-pub-1161737894053314/7030018412
    //ca-app-pub-3940256099942544/4411468910
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1161737894053314/7030018412")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    //광고가 끝난 뒤 재로드 하는 함수
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen init!!")
        interstitial = createAndLoadInterstitial()
    }

    
    //@터치 이벤트 메서드 구현하기
    //터치 이벤트를 사용하기 위해서는 터치 이벤트가 발생했을 때 호출되는 메서드를 사용자가 재정의해야 합니다. 재정의(redefinition)란 부모 클래스에서 생성해 놓은 메서드에게 할 일을 새로 부여한다는 의미입니다. 즉, 터치 이벤트가 발생했을 때 호출되는 메서드가 정해져 있는데, 해당 메서드가 무슨 일을 할지 정의한다는 의미랍니다.
    //재정의해야 할 터치 이벤트 메서드는 다음과 같습니다. 다음 소스를 가장 아래쪽 '}' 위에 추가해줍니다.
    
    //터치가 시작했을 떄의 동작하는 터치이벤트 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    //    print("Touches Began")
    }
    //터치 후 드래그 되었을때 동작하는 터치이벤트 함수
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
     //   print("Touches Moved")
    }
    //터치 후 끝났을때에 동작하는 터치이벤트 함수
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        noticeImgFadeOut()

    }

}

