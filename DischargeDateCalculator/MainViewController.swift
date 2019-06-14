//
//  ViewController.swift
//  Navigation
//
//  Created by Min Kyeong Tae on 01/12/2018.
//  Copyright © 2018 Min Kyeong Tae. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var versionInfoLabel: UILabel!
    
    @IBOutlet var appInfoBarButtonItem: UIBarButtonItem!
    
    var mainBackground: UIImage?
    var mainDecoImg: UIImage?
    var btnBgImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let calcVersion = 1.15
        versionInfoLabel.text = String(calcVersion) + " ver"
        //메인화면 간판이미지 삽입
        mainDecoImg = UIImage(named: "dischargingDateMainImg.png")
        thumbnailImageView.image = mainDecoImg
        
        //배경 이미지 삽입
        mainBackground = UIImage(named: "mainBg_7.png")
        backgroundImageView.image = mainBackground
////        imgMainBackground.mutableOrderedSetValue(forKey: "0")
//        btnBgImg = UIImage(named: "btnBlueBg.png")
//        btnAppInfo.setBackgroundImage(btnBgImg, for: UIControl.State.normal, barMetrics: UIBarMetrics.default)
//        
        
    }
    @IBAction func btnStartAction(_ sender: UIButton) {
        print("Discharge Calc Starts!!")
    }
    

}

