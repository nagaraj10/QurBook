//
//  LoaderVC.swift
//  Runner
//
//  Created by Venkatesh on 15/11/22.
//  Copyright © 2022 The Chromium Authors. All rights reserved.
//

import UIKit

class LoaderVC: UIViewController {

    @IBOutlet weak var timerLablel: UILabel!
    @IBOutlet var loading: NVActivityIndicatorView!
    
    var timer = Timer()
    var seconds = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLablel.text = "10 Seconds"
        loading.startAnimating()
//        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopLoading))
//        mytapGestureRecognizer.numberOfTapsRequired = 1
//        view.addGestureRecognizer(mytapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runTimer()
    }
    
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1,
                                      target: self,
                                      selector: (#selector(self.updateTimer)),
                                      userInfo: nil,
                                      repeats: true)
    }
    
   @objc func updateTimer() {
        seconds -= 1
        timerLablel.text = "\(seconds) Seconds"
       if(seconds == 0){
           stopLoading()
       }
    }
    
    @objc func stopLoading(){
//        loading.stopAnimating()
//        loading.isHidden = true
//        timerLablel.isHidden = true
//        timer.invalidate()
        self.dismiss(animated: false)
    }
}
