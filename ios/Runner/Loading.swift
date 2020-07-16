

import UIKit

class Loading : NSObject {
    
    static let sharedInstance   = Loading()
    
    private let ApplicationDelegate: UIApplicationDelegate = UIApplication.shared.delegate!
    
    let bgBlurView: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        vw.clipsToBounds = true
        vw.alpha = 0
        return vw
    }()

    let baseView: UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        vw.layer.shadowOffset = CGSize(width: 0, height: -1)
        vw.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
        vw.layer.shadowRadius = 12.0
        vw.layer.shadowOpacity = 0.8
        vw.clipsToBounds = false
        vw.layer.cornerRadius = 5.0
        vw.alpha = 0
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        vw.addGestureRecognizer(mytapGestureRecognizer)
        return vw
    }()
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let vw = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width - 50)/2, y: (UIScreen.main.bounds.size.height - 50)/2, width: 50, height:  50))
        vw.backgroundColor = UIColor.clear
        vw.color =  UIColor(red: 95/255, green: 33/255, blue: 222/255, alpha: 1.0)
        vw.type = NVActivityIndicatorType.lineScalePulseOut
        return vw
    }()
    
    //    let activityIndicatorView: UIAlertController = {
    //        let alert = UIAlertController(title: nil, message: "Listening...", preferredStyle: .alert)
    //        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    //        loadingIndicator.hidesWhenStopped = true
    //        loadingIndicator.style = UIActivityIndicatorView.Style.gray
    //        loadingIndicator.startAnimating();
    //        alert.view.addSubview(loadingIndicator)
    //        return alert
    //    }()
    
    private var keyWindow                   : UIWindow?
    
    func showLoader() {
        
        keyWindow = ApplicationDelegate.window!
        
        // Set Frame
        changeFrame()
        
        activityIndicatorView.startAnimating()
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bgBlurView.alpha = 1
            self.baseView.alpha = 1
        }) { (finished) in
        }
    }
    
    func hideLoader() {
        
        activityIndicatorView.stopAnimating()
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.bgBlurView.alpha = 0
            self.baseView.alpha = 0
        }) { (finished) in
        }
    }
    
    func changeFrame(){
        let screenWidth  =  UIScreen.main.bounds.size.width
        let screenHeight =  UIScreen.main.bounds.size.height
        
        keyWindow?.addSubview(bgBlurView)
        bgBlurView.addSubview(baseView)
        baseView.addSubview(activityIndicatorView)
        
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        bgBlurView.addGestureRecognizer(mytapGestureRecognizer)
        
        bgBlurView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        baseView.frame = CGRect(x: bgBlurView.frame.size.width/2 - 50, y: bgBlurView.frame.size.height/2 - 50, width: 100, height: 100)
        activityIndicatorView.frame = CGRect(x: baseView.frame.size.width/2 - 25, y: baseView.frame.size.height/2 - 25, width: 50, height: 50)
    }
    
    @objc func myTapAction(recognizer: UITapGestureRecognizer) {
        hideLoader()
    }
}
