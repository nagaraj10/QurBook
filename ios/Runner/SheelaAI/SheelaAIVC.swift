//
//  SheelaAIVC.swift
//  Runner
//
//  Created by Venkatesh on 06/10/21.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

import UIKit

class SheelaAIVC: UIViewController {
    
    @IBOutlet weak var TVBGV: UIView!
    @IBOutlet weak var mainTF: UITextView!
    @IBOutlet weak var PopUPView: UIView!
    var callback : ((String) -> Void)?
    var message = ""
    @IBOutlet weak var CloseBTN: UIButton!
    @IBOutlet weak var SendBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTF.text = message
        PopUPView.layer.cornerRadius = 40
        TVBGV.layer.cornerRadius = 30
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        PopUPView.clipsToBounds = true
        TVBGV.clipsToBounds = true
        TVBGV.layer.borderColor = UIColor.lightGray.cgColor
        TVBGV.layer.borderWidth = 1
        mainTF.becomeFirstResponder()
        SendBTN.setTitle(" ", for: .normal)
        CloseBTN.setTitle(" ", for: .normal)
        SendBTN.setBackgroundImage(UIImage(named: "Send"), for: .normal)
        CloseBTN.setBackgroundImage(UIImage(named: "Close"), for: .normal)
    }
    
    @IBAction func CloseAction(_ sender: UIButton) {
        callback?("")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendAction(_ sender: Any) {
        callback?(mainTF.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
}
