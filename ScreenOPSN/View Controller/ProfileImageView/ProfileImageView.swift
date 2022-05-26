

import UIKit

class ProfileImageView: UIViewController {

    var image:String = ""
       
    @IBOutlet weak var profileImage: UIImageViewProperty!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.downloadImage(from: Global.getStringValue(image as AnyObject))

    }

    @IBAction func dismissAction(){
        self.dismiss(animated: false, completion: nil)
    }
}
