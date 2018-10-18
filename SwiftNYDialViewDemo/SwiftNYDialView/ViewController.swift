//
//  ViewController.swift
//  SwiftNYDialView
//
//  Created by liyangly on 2018/10/18.
//  Copyright © 2018 liyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var dialView: NYDialView = {
        let view = NYDialView(frame: CGRect(x: 40, y: 200, width: 300, height: 300))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(dialView)
    }


}

