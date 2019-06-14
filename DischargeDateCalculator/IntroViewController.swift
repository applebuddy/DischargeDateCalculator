//
//  IntroViewController.swift
//  Navigation
//
//  Created by Min Kyeong Tae on 06/12/2018.
//  Copyright © 2018 Min Kyeong Tae. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var introImageView: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //인트로이미지를 일단 알파로 해둔다.
        self.introImageView.alpha = 0
        print("init the IntroScene")
        
        //인트로 이미지를 페이드인 ~ 페이드아웃할 것이다. UIView의 animate를 활용한다.
        //페이드인, 페이드아웃 애니메이션 뒤에 메인 뷰로 전환하는 방법
        UIView.animate(withDuration: 0.8, animations: ({self.introImageView.alpha = 1}), completion:{finished in
            
            UIView.animate(withDuration: 0.3, animations: ({self.introImageView.alpha = 0}), completion:{finished in
                self.performSegue(withIdentifier: "goToMainView", sender: nil)
            })
            
        })
    }
}

