# OEMentions
An easy way to add mentions to uitextview like Facebook and Instagram. It also include a tableview to show the users list to choose from. The component is written in 
**Swift**.

![demo2_gif](https://cloud.githubusercontent.com/assets/3969198/17277971/849e7a16-5758-11e6-9589-d6f3f0a8c8e4.gif)
![demo3_gif](https://cloud.githubusercontent.com/assets/3969198/17277992/17f54448-5759-11e6-8107-ac5b0f9deb08.gif)



## Main features
* Expandale UITextView (also expandle UITextView container)
* Show and manage position of users list when "@" is typed ("@" can be changed to any character)
* Customizable mention text


## Installation

All you need is to import `OEMentions.swift` to your project folder


## Usage Example
You can see a full implementation in ViewController.swift

1. Refrence UITextView outlet and "Optional: Container (UIView that has UITextView in it)"
  
  ```swift
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var textView: UITextView!
  ```
  
2. Create a OEMention variable

  ```swift
  var oeMentions:OEMentions!
  ```

3. Create an OEObejct array that contain users info (id, name)

  ```swift
  let oeObjects = [OEObject(id: 1,name: "Elsie Easterling"), OEObject(id: 2,name: "Caterina Misiewicz"), OEObject(id: 3,name: "Ruben Dematteo")]
  ```

4. Initialize the OEMentions

  ```swift
  oeMentions = OEMentions(containerView: containerView, textView: textView, mainView: self.view, oeObjects: oeObjects)
  ```

5. Assign UITextView delegate to OEMentions

  ```swift
  textView.delegate = oeMentions
  ```
  
6. (Optional) OEMentionsDelegate: delegate method for the chosen user

  ```swift
  class ViewController: UIViewController, OEMentionsDelegate
  ```
  ```swift
  oeMentions.delegate = self
  ```
  ```swift
  func mentionSelected(id:Int, name: String) {
        
        // Do something with selected id and name
        
  }
  ```


## Customization   

```swift
changeMentionCharacter(character: String)
```
```swift
changeMentionTableviewBackground(color: UIColor)
```
```swift
// Color of the mention tableview name text
OEMentions.nameColor
// Font of the mention tableview name text
OEMentions.nameFont
// Rest of the UITextView text color
OEMentions.notMentionColor
```

## License

MIT License

Copyright (c) 2016 Omar Alessa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
