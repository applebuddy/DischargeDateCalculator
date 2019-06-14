
import UIKit

class InfoViewController: UIViewController {
    var logoImage: UIImage?
    var infoViewBg: UIImage?
    
    @IBOutlet var infoViewBackgroundImage: UIImageView!
    @IBOutlet var ourTreesImageView: UIImageView!
    @IBOutlet weak var subInfoTextView: UITextView!

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "개발자 정보"
//        infoViewBg = UIImage(named: "infoBg_7.png")
        logoImage = UIImage(named: "LogoScene.png")
        subInfoTextView.adjustsFontForContentSizeCategory = true
//        infoViewBackgroundImage.image = infoViewBg
        ourTreesImageView.image = logoImage

    }


}

