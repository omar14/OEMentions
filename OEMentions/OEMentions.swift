
//
//  OEMentions.swift
//  OEMentions
//
//  Created by Omar Alessa on 7/31/16.
//  Copyright © 2019 omaressa. All rights reserved.
//

import UIKit

public protocol OEMentionsDelegate
{
    // To respond to the selected name
    func mentionSelected(id:Int, name:String)
}


public class OEMentions: NSObject, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // UIViewController view
    var mainView:UIView?
    
    // UIView for the textview container
    var containerView:UIView?
    
    // The UITextView we want to add mention to
    var textView:UITextView?
    
    // List of names to show in the list
    var oeObjects:[OEObject]?
    
    // The list after the query filter
    var theFilteredList = [OEObject]()
    
    // [Index:Length] of added mentions to textview
    var mentionsIndexes = [Int:Int]()
    
    // Keep track if still searching for a name
    var isMentioning = Bool()
    
    // The search query
    var mentionQuery = String()
    
    // The start of mention index
    var startMentionIndex = Int()
    
    // Character that show the mention list (Default is "@"), It can be changed using changeMentionCharacter func
    private var mentionCharater = "@"
    
    // Keyboard hieght after it shows
    var keyboardHieght:CGFloat?
    
    
    // Mentions tableview
    var tableView: UITableView!
    
    //MARK: Customizable mention list properties
    
    // Color of the mention tableview name text
    var nameColor = UIColor.blue
    
    // Font of the mention tableview name text
    var nameFont = UIFont.boldSystemFont(ofSize: 14.0)
    
    // Color if the rest of the UITextView text
    var notMentionColor = UIColor.black
    
    
    // OEMention Delegate
    var delegate:OEMentionsDelegate?
    
    
    var textViewWidth:CGFloat?
    var textViewHieght:CGFloat?
    var textViewYPosition:CGFloat?
    
    var containerHieght:CGFloat?
    
    //MARK: - init
    
    //MARK: class init without container
    public init(textView:UITextView, mainView:UIView, oeObjects:[OEObject]){
        super.init()
        
        self.mainView = mainView
        self.oeObjects = oeObjects
        self.textView = textView
        
        self.textViewWidth = textView.frame.width
        
        initMentionsList()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(OEMentions.keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
    
    //MARK: class init with container
    public init(containerView:UIView, textView:UITextView, mainView:UIView, oeObjects:[OEObject]){
        super.init()
        
        self.containerView = containerView
        self.mainView = mainView
        self.oeObjects = oeObjects
        self.textView = textView
        
        self.containerHieght = containerView.frame.height
        
        self.textViewWidth = textView.frame.width
        self.textViewHieght = textView.frame.height
        self.textViewYPosition = textView.frame.origin.y
        
        initMentionsList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(OEMentions.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    //MARK: - UITextView delegate functions:
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        
        self.mentionQuery = ""
        self.isMentioning = false
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.isHidden = true
        })
        
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        updatePosition()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let str = String(textView.text)
        var lastCharacter = "nothing"
        
        if !str.isEmpty && range.location != 0{
            lastCharacter = String(str[str.index(before: str.endIndex)])
        }
        
        // Check if there is mentions
        if mentionsIndexes.count != 0 {
            
            for (index,length) in mentionsIndexes {
                
                if case index ... index+length = range.location {
                    // If start typing within a mention rang delete that name:
                    
                    textView.replace(textView.textRangeFromNSRange(range: NSMakeRange(index, length))!, withText: "")
                    mentionsIndexes.removeValue(forKey: index)
                }
                
            }
        }
        
        
        if isMentioning {
            if text == " " || (text.count == 0 &&  self.mentionQuery == ""){ // If Space or delete the "@"
                self.mentionQuery = ""
                self.isMentioning = false
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.tableView.isHidden = true
                    
                })
            }
            else if text.count == 0 {
                self.mentionQuery.remove(at: self.mentionQuery.index(before: self.mentionQuery.endIndex))
                self.filterList(query: self.mentionQuery)
                self.tableView.reloadData()
            }
            else {
                self.mentionQuery += text
                self.filterList(query: self.mentionQuery)
                self.tableView.reloadData()
            }
        } else {
            if text == self.mentionCharater && ( range.location == 0 || lastCharacter == " ") { /* (Beginning of textView) OR (space then @) */
                
                
                self.isMentioning = true
                self.startMentionIndex = range.location
                theFilteredList = oeObjects!
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.isHidden = false
                })
                
            }
        }
        
        return true
    }
    
    
    
    //MARK: - Keyboard will show NSNotification:
    
    @objc public func keyboardWillShow(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let thekeyboardHeight = keyboardRectangle.height
        self.keyboardHieght = thekeyboardHeight
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.updatePosition()
            
        })
        
    }
    
    
    
    //MARK: - UITableView deleget functions:
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theFilteredList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel!.text = theFilteredList[indexPath.row].name
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addMentionToTextView(name: theFilteredList[indexPath.row].name!)
        
        if delegate != nil {
            self.delegate!.mentionSelected(id: theFilteredList[indexPath.row].id!, name: theFilteredList[indexPath.row].name!)
        }
        
        self.mentionQuery = ""
        self.isMentioning = false
        self.theFilteredList = oeObjects!
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.isHidden = true
        })
    }
    
    // Add a mention name to the UITextView
    public func addMentionToTextView(name: String){
        
        mentionsIndexes[self.startMentionIndex] = name.count
        
        let range: Range<String.Index> = self.textView!.text.range(of: "@" + self.mentionQuery)!
        self.textView!.text.replaceSubrange(range, with: name)
        
        let theText = self.textView!.text + " "
        let theEndIndex = self.startMentionIndex + name.count
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: theText)
        
        for (startIndex, length) in mentionsIndexes {
            // Add attributes for the mention
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: nameColor, range: NSMakeRange(startIndex, length))
            attributedString.addAttribute(NSAttributedString.Key.font, value: nameFont, range: NSMakeRange(startIndex, length))
        }
        
        // Add for the rest
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: notMentionColor, range: NSMakeRange(theEndIndex, 1))
        
        
        self.textView!.attributedText = attributedString
        
        updatePosition()
        
    }
    
    //MARK: - Utilities
    
    
    //Mentions UITableView init
    public func initMentionsList(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.mainView!.frame.width, height: 100), style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.separatorColor = UIColor.clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.mainView!.addSubview(self.tableView)
        
        self.tableView.isHidden = true
    }
    
    
    public func filterList(query: String) {
        
        theFilteredList.removeAll()
        
        if query.isEmpty {
            theFilteredList = oeObjects!
        }
        
        if let myOEobjects = oeObjects {
            for object in myOEobjects {
                if object.name?.lowercased().contains(query.lowercased()) ?? false {
                    theFilteredList.append(object)
                }
            }
        }
        
    }
    
    // Set the mention character. Should be one character only, default is "@"
    public func changeMentionCharacter(character: String){
        if character.count == 1 && character != " " {
            self.mentionCharater = character
        }
    }
    
    // Change tableview background color
    public func changeMentionTableviewBackground(color: UIColor){
        self.tableView.backgroundColor = color
    }
    
    // Update views potision for the textview and tableview
    public func updatePosition(){
        
        if containerView != nil {
            
            self.containerView!.frame.size.height = self.containerHieght! + ( self.textView!.frame.height -  self.textViewHieght! )
            self.containerView!.frame.origin.y = UIScreen.main.bounds.height - self.keyboardHieght! - self.containerView!.frame.height

            self.textView!.frame.origin.y = self.textViewYPosition!

            self.tableView.frame.size.height = UIScreen.main.bounds.height - self.keyboardHieght! - self.containerView!.frame.size.height
        }
        else {
            self.textView!.frame.origin.y = UIScreen.main.bounds.height - self.keyboardHieght! - self.textView!.frame.height
            self.tableView.frame.size.height = UIScreen.main.bounds.height - self.keyboardHieght! - self.textView!.frame.height
        }
        
        
    }
    
}


// OEMentions object (id,name)

public class OEObject {
    
    var id:Int?
    var name:String?
    
    public init(id:Int, name:String){
        self.id = id
        self.name = name
    }
    
}


extension UITextView
{
    public func textRangeFromNSRange(range:NSRange) -> UITextRange?
    {
        let beginning = self.beginningOfDocument
        guard let start = self.position(from: beginning, offset: range.location), let end = self.position(from: start, offset: range.length) else { return nil}
        return self.textRange(from: start, to: end)
    }
}
