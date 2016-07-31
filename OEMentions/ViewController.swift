//
//  ViewController.swift
//  OEMentions
//
//  Created by Omar Al-Essa on 7/31/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var oeMentions:OEMentions!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let names = ["a","b","a","b","a","b","a","b","a","b","a","b","a","b","a","b","a","b","a","b","a","b","a","b","a","b",]
        
        oeMentions = OEMentions(textView: textView, mainView: self.view, names: names)
        
        textView.delegate = oeMentions
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

