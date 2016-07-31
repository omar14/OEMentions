//
//  OEMentions.swift
//  OEMentions
//
//  Created by Omar Alessa on 7/31/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit

class OEMentions: NSObject, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // UIViewController view
    var mainView:UIView?
    
    // The UITextView we want to add mention to
    var textView:UITextView?
    
    // List of names to show in the list
    var names:[String]?
    
    // [Index:Length] of added mentions to textview
    var mentionsIndexes = [Int:Int]()
    
    // Keep track if still searching for a name
    var isMentioning = Bool()
    
    // The search query
    var mentionQuery = ""
    
    // The start of mention index
    var startMentionIndex = Int()
    
    // Character that show the mention list (Default is "@"), It can be changed using changeMentionCharacter func
    private var mentionCharater = "@"
    
    // Keyboard hieght after it shows
    var keyboardHieght:CGFloat?
    
    // The UITextView width
    var textViewWidth:CGFloat?
    
    // Mentions tableview
    var tableView: UITableView!
    
    //MARK: Customisable mention text properties
    
    // Color of the mention tableview name text
    var nameColor = UIColor(red: 13 / 255, green: 135 / 255, blue: 125 / 255, alpha: 1.0)
    
    // Font of the mention tableview name text
    var nameFont = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
    
    // Color if the rest of the UITextView text
    var notMentionColor = UIColor.blackColor()
    
    
    //MARK: class init
    
    init(textView:UITextView, mainView:UIView, names:[String]){
        super.init()
        self.mainView = mainView
        self.names = names
        self.textView = textView
        
        self.textViewWidth = textView.frame.width
        
        initMentionsList()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OEMentions.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    // Set the mention character. Should be one character only, default is "@"
    func changeMentionCharacter(character: String){
        if character.characters.count == 1 && character != " " {
            self.mentionCharater = character
        }
    }
    
    
    //MARK: UITextView delegate functions:
    
    func textViewDidEndEditing(textView: UITextView) {
        
        self.mentionQuery = ""
        self.isMentioning = false
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.hidden = true
        })
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        self.textView!.scrollEnabled = false
        self.textView!.sizeToFit()
        self.textView!.frame.size.width = textViewWidth!
        
        updatePosition()
        
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let str = String(textView.text)
        var lastCharacter = "nothing"
        
        if !str.isEmpty && range.location != 0{
            lastCharacter = String(str[str.startIndex.advancedBy(range.location-1)])
        }
        
        if mentionsIndexes.count != 0 { // There is mentions
            
            for (index,length) in mentionsIndexes {
                print("The mention is from: ", index, " To: ", (index + length))
                
                if case index ... index+length = range.location {
                    print("delete the username")
                    textView.replaceRange((textView.textRangeFromNSRange(NSMakeRange(index, length)))!, withText: "")
                    mentionsIndexes.removeValueForKey(index)
                }
                
            }
        }
        
        
        if isMentioning {
            if text == " " || (text.characters.count == 0 &&  self.mentionQuery == ""){ // If Space or delete the "@"
                self.mentionQuery = ""
                self.isMentioning = false
                UIView.animateWithDuration(0.2, animations: {
                    
                    self.tableView.hidden = true
                    
                })
            }
            else if text.characters.count == 0 {
                self.mentionQuery.removeAtIndex(self.mentionQuery.endIndex.predecessor())
                
                //TODO: Filter array
                //self.getMentionUsers(self.mentionQuery)
                
            }
            else {
                self.mentionQuery += text
                
                //TODO: Filtet array
                //self.getMentionUsers(self.mentionQuery)
                
            }
        }
        else {
            if text == self.mentionCharater && ( range.location == 0 || lastCharacter == " ") { /* (Beginning of textView) OR (space then @) */
                
                self.isMentioning = true
                self.startMentionIndex = range.location
                UIView.animateWithDuration(0.2, animations: {
                    self.tableView.hidden = false
                })
                
            }
        }
        
        return true
    }
    
    
    //MARK: Keyboard will show NSNotification:
    
    func keyboardWillShow(notification:NSNotification) {
        
        print("Hey!")
        
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let thekeyboardHeight = keyboardRectangle.height
        self.keyboardHieght = thekeyboardHeight
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.updatePosition()
            
        })
        
    }
    
    
    //Mentions UITableView init
    func initMentionsList(){
        
        tableView = UITableView(frame: CGRectMake(0, 0, self.mainView!.frame.width, 100), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.separatorColor = UIColor.clearColor()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.mainView!.addSubview(self.tableView)
        
        self.tableView.hidden = true
    }
    
    
    //MARK: Mentions UITableView deleget functions:
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel!.text = names![indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        addMentionToTextView(names![indexPath.row])
        
        self.mentionQuery = ""
        self.isMentioning = false
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.hidden = true
        })
        
    }
    
    
    // Add a mention name to the UITextView
    func addMentionToTextView(name: String){
        
        mentionsIndexes[self.startMentionIndex] = name.characters.count
        
        print("The replaced: ", "@" + self.mentionQuery)
        let range: Range<String.Index> = self.textView!.text.rangeOfString("@" + self.mentionQuery)!
        self.textView!.text.replaceRange(range, with: name)
        
        let theText = self.textView!.text + " "
        let theEndIndex = self.startMentionIndex + name.characters.count
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: theText)
        
        for (startIndex, length) in mentionsIndexes {
            // Add attributes for the mention
            attributedString.addAttribute(NSForegroundColorAttributeName, value: nameColor, range: NSMakeRange(startIndex, length))
            attributedString.addAttribute(NSFontAttributeName, value: nameFont!, range: NSMakeRange(startIndex, length))
        }
        
        // Add for the rest
        attributedString.addAttribute(NSForegroundColorAttributeName, value: notMentionColor, range: NSMakeRange(theEndIndex, 1))
        
        
        self.textView!.attributedText = attributedString
        
        self.textView!.scrollEnabled = false
        self.textView!.sizeToFit()
        self.textView!.frame.size.width = textViewWidth!
        
        updatePosition()
        
    }
    
    
    // Update views potision for the textview and tableview
    func updatePosition(){
        
        self.textView!.frame.origin.y = UIScreen.mainScreen().bounds.height - self.keyboardHieght! - self.textView!.frame.height
        self.tableView.frame.size.height = UIScreen.mainScreen().bounds.height - self.keyboardHieght! - self.textView!.frame.height
        
    }
    
}


extension UITextView
{
    func textRangeFromNSRange(range:NSRange) -> UITextRange?
    {
        let beginning = self.beginningOfDocument
        guard let start = self.positionFromPosition(beginning, offset: range.location), end = self.positionFromPosition(start, offset: range.length) else { return nil}
        
        return self.textRangeFromPosition(start, toPosition: end)
    }
}