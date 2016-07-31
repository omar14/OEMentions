//
//  ViewController.swift
//  OEMentions
//
//  Created by Omar Al-Essa on 7/31/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OEMentionsDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var oeMentions:OEMentions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let oeObjects = [OEObject(id: 1,name: "John"), OEObject(id: 2,name: "Mark"), OEObject(id: 3,name: "Frank"), OEObject(id: 4,name: "Foo")]
        
        oeMentions = OEMentions(textView: textView, mainView: self.view, oeObjects: oeObjects)
        oeMentions.delegate = self
        
        textView.delegate = oeMentions
        
    }
    
    func mentionSelected(id:Int, name: String) {
        
        // Do something with selected id and name
        print(id, " ", name)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

