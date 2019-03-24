//
//  ViewController.swift
//  OEMentionsExample
//
//  Created by Omar Alessa on 24/03/2019.
//  Copyright © 2019 Omar Alessa. All rights reserved.
//

import UIKit
import OEMentions

class ViewController: UIViewController, OEMentionsDelegate {
    
    @IBOutlet weak var myContainer: UIView!
    @IBOutlet weak var myTextView: UITextView!
    
    var oeMentions:OEMentions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oeObjects = [OEObject(id: 1,name: "Elsie Easterling"), OEObject(id: 2,name: "Caterina Misiewicz"), OEObject(id: 3,name: "Ruben Dematteo")]
        
        oeMentions = OEMentions(containerView: myContainer, textView: myTextView, mainView: self.view, oeObjects: oeObjects)
        
        oeMentions.delegate = self
        
        myTextView.delegate = oeMentions
        
    }
    
    
    func mentionSelected(id: Int, name: String) {
        print("id \(id)")
        print("name \(name)")
    }


}

