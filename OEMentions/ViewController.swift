//
//  ViewController.swift
//  OEMentions
//
//  Created by Omar Alessa on 7/31/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, OEMentionsDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    var oeMentions:OEMentions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oeObjects = [OEObject(id: 1,name: "Elsie Easterling"), OEObject(id: 2,name: "Caterina Misiewicz"), OEObject(id: 3,name: "Ruben Dematteo"), OEObject(id: 4,name: "Huey Hehn"), OEObject(id: 5,name: "Latashia Oriol"), OEObject(id: 6,name: "Genesis Foret"), OEObject(id: 7,name: "Hortense Hunsucker"), OEObject(id: 8,name: "Sergio Penaflor"), OEObject(id: 9,name: "Jonie Paredez"), OEObject(id: 10,name: "Lannie Jamerson"), OEObject(id: 11,name: "Annette Gustin"), OEObject(id: 12,name: "Leanora Loux"), OEObject(id: 13,name: "Genaro Matter"), OEObject(id: 14,name: "Keven Chennault"), OEObject(id: 15,name: "Pablo Aimar"), OEObject(id: 16,name: "Foo")]
        
        oeMentions = OEMentions(containerView: containerView, textView: textView, mainView: self.view, oeObjects: oeObjects)
        oeMentions.delegate = self
        
        textView.delegate = oeMentions
        
    }
    
    func mentionSelected(id:Int, name: String) {
        
        // Do something with selected id and name ..
        let selectedId = id
        let selectedName = name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

