//
//  ViewController.swift
//  Swift Color Game for Kids
//
//  Created by Terry Griffin on 2/2/15.
//  Copyright (c) 2015 mwsu. All rights reserved.
//

import UIKit
import Foundation
import Darwin

class ResponsePackage {
    
    var success = false
    var response: AnyObject? = nil
    var error: NSError? = nil
    
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblChangeColor: UILabel!
    @IBOutlet weak var lblChangeColor2: UILabel!
    
    @IBOutlet weak var lblTotalCorrect: UILabel!
    @IBOutlet weak var lblCorrectIncorrect: UILabel!
    
    @IBOutlet weak var btnAnswer1OUTLET: UIButton!
    @IBOutlet weak var btnAnswer2OUTLET: UIButton!
    @IBOutlet weak var btnAnswer3OUTLET: UIButton!
    
    var buttonAnswer = 0
    var lastButtonAnswer = 0
    
    var colorPullName = "derp"
    var lastColorPullName = "derp"
    
    var button1Correct = false
    var button2Correct = false
    var button3Correct = false
    
    var totalCorrect = 0;
    
    var colorNames : [String] = ["Red","Green","Blue","Orange","Black","White","Brown","Purple","Gray","Yellow"]
    
    //Color dictionary type not used in the program but kept as an example for future
    var colorRGB : [Dictionary<String,UInt>] = [
        ["Red":0xFF0000],
        ["Green":0x00FF00],
        ["Blue":0x0000FF],
        ["Orange":0xFF7F00],
        ["Black":0x000000],
        ["White":0xFFFFFF],
        ["Pink":0xFF6EB4],
        ["Purple":0x8968CD],
        ["Gray":0xBEBEBE],
        ["Yellow":0xFFFF00],
        ["Gray2":0xC0C0C0]
    ]

    var myColors:Colors
    
    required init(coder aDecoder: NSCoder){
    
        myColors = Colors()

        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        //Fetch the Json color object from the CS server
        request(.GET, "http://cs.mwsu.edu/~griffin/swift/colors2.json")
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    println("Error: \(error)")
                    println(req)
                    println(res)
                } else {
                    
                    println("Success")
                    
                    //Unwrap the json (not safe, but oh well)
                    var json = JSON(json!)
                    
                    //If we are successful, then call the method `parseJson` to load the "color class: Colors"
                    self.parseJson(json)
                    
                    //Start the game
                    self.matchColorLogic()
                    
                    
                    //Example usage of the Colors class
                    var randColor = self.myColors.fetchRandomColor()
                    
                    println("\(randColor.hexValue) : \(randColor.colorName) ")
                    
                    var uicolor = self.myColors.hexStringToUIColor(randColor.hexValue)
                    
                    println(uicolor)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAnswer1ACTION(sender: UIButton) {
        if button1Correct == true {
            lblCorrectIncorrect.text = "Correct!"
            totalCorrect++
        }else{
            lblCorrectIncorrect.text = "Incorrect!"
        }
        button1Correct = false
        matchColorLogic()
    }
    
    @IBAction func btnAnswer2ACTION(sender: UIButton) {
        if button2Correct == true {
            lblCorrectIncorrect.text = "Correct!"
            totalCorrect++
        }else{
            lblCorrectIncorrect.text = "Incorrect!"
        }
        button2Correct = false
        matchColorLogic()
    }
    
    @IBAction func btnAnswer3ACTION(sender: UIButton) {
        if button3Correct == true {
            lblCorrectIncorrect.text = "Correct!"
            totalCorrect++
        }else{
            lblCorrectIncorrect.text = "Incorrect!"
        }
        button3Correct = false
        matchColorLogic()
    }
    
    
    @IBAction func btnFireColorAnimation(sender: UIButton) {
        println("fired action")
    }
  /*
    func ColourDistance(r1: UInt32, g1: UInt32, b1: UInt32, r2: UInt32, g2: UInt32, b2: UInt32){
    
        let rmean:UInt32 = (r1+r2)/2
        let r:UInt32 = r1-r2
        let g:UInt32 = g1-g2
        let b:UInt32 = b1-b2
        let x1:UInt32 = (((512+rmean)*r*r)>>8)
        let x2:UInt32 = 4*g*g
        let x3:UInt32 = (((767-rmean)*b*b)>>8)
        let test = sqrt(4.02)
        let testvar:Double = 4
        let test2 = sqrt(testvar)
        let x = Float(x1 + x2 + x3)
        return sqrtf(x)
    }
   */
    
    func matchColorLogic() -> Bool{
        
        buttonAnswer = Int(arc4random_uniform(3))
        while buttonAnswer == lastButtonAnswer {
            buttonAnswer = Int(arc4random_uniform(3))
        }
        lastButtonAnswer = buttonAnswer
        
        
        var colorPull = myColors.fetchRandomColor()
        colorPullName = colorPull.colorName
        while colorPullName == lastColorPullName {
            colorPull = myColors.fetchRandomColor()
            colorPullName = colorPull.colorName
        }
        lastColorPullName = colorPullName
        
        changeColor()
        
        var colorPullChoice1 = myColors.fetchRandomColor()
        var colorPullChoice2 = myColors.fetchRandomColor()
        
        var prev = colorPullChoice1.colorName
        var next = colorPullChoice2.colorName
        
        if(buttonAnswer == 0){
            btnAnswer1OUTLET.setTitle(colorPullName, forState: UIControlState.Normal)
            btnAnswer2OUTLET.setTitle(prev, forState: UIControlState.Normal)
            btnAnswer3OUTLET.setTitle(next, forState: UIControlState.Normal)
            button1Correct = true;
            
        }
        
        if(buttonAnswer == 1){
            btnAnswer1OUTLET.setTitle(prev, forState: UIControlState.Normal)
            btnAnswer2OUTLET.setTitle(colorPullName, forState: UIControlState.Normal)
            btnAnswer3OUTLET.setTitle(next, forState: UIControlState.Normal)
            button2Correct = true
        }
        
        if(buttonAnswer == 2){
            btnAnswer1OUTLET.setTitle(next, forState: UIControlState.Normal)
            btnAnswer2OUTLET.setTitle(prev, forState: UIControlState.Normal)
            btnAnswer3OUTLET.setTitle(colorPullName, forState: UIControlState.Normal)
            button3Correct = true
        }
        
        return true;
    }
    
    
    func changeColor() -> Bool{
        
        let lblColor = myColors.fetchHexValue(colorPullName)
        lblChangeColor.backgroundColor = hexStringToUIColor(lblColor)
        
        lblTotalCorrect.text = "Total Correct: \(totalCorrect)"
        
        return true
    }
    
    //Not used in the program but kept as an example for future
    //This function receives a hexidecimal color in the format 0xFFFFFF
    //and returns a UIColor RGB value
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /********************************************************************************************
    * Function: parseJson
    *   Parses json object and loads it into the "Colors" class for us to use.
    * @Params:
    *   json:JSON - Json object to be parsed
    * @Returns:
    *   Void
    ********************************************************************************************/
    func parseJson(json:JSON)->Void{
        
        var colors = Colors()
        var colorName = ""
        var hexValue = ""
        var hsv:HSV
        var hsl:HSL
        var rgb:RGB
        var col = ""
        var hex = ""
        var r = 0.0
        var g = 0.0
        var b = 0.0
        var h1 = 0
        var s1 = 0.0
        var h2 = 0
        var s2 = 0.0
        var l = 0.0
        var v = 0.0
        
        
        for (index,subjson) in json {
            for (key,val) in subjson {
                switch key {
                case "colorName":
                    col = val.stringValue
                case "hexValue":
                    hex = val.stringValue
                case "RGB":
                    r = val["R"].doubleValue
                    g = val["G"].doubleValue
                    b = val["B"].doubleValue
                case "HSL":
                    h1 = val["H"].intValue
                    s1 = val["S"].doubleValue
                    l = val["L"].doubleValue
                case "HSV":
                    h2 = val["H"].intValue
                    s2 = val["S"].doubleValue
                    v = val["V"].doubleValue
                default:
                    println("Error!")
                }
            }
            
            self.myColors.addColor(col,hex:hex,red:r,green:g,blue:b,hue1:h1,sat1:s1,hue2:h2,sat2:s2,value:v,lightness:l)
        }
        self.myColors.printColors()
        println(self.myColors.fetchColorName("#CE2029"))
        println(self.myColors.fetchRGB("#CE2029"))
    }
    
}





/********************************************************************************************
* Json Helper Class
* Methods:
*   getJSON(string) returns NSData
*   parseJSON(NSData) returns Dictionary
********************************************************************************************/
class myJson {
    
    class func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    class func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return boardsDictionary
    }
}

/********************************************************************************************
* Color helper class
* Methods:
*   getJSON(string) returns NSData
*   parseJSON(NSData) returns Dictionary
********************************************************************************************/
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = cString.substringFromIndex(advance(cString.startIndex, 1))
    }
    
    if (countElements(cString) != 6) {
        return UIColor.grayColor()
    }
    
    var rgbValue:UInt32 = 0
    NSScanner(string: cString).scanHexInt(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

/********************************************************************************************
* File read and write helper class
* Methods:
*   exists(string) returns Bool
*   read(string,encoding) returns String
*   write(string,string,encoding,error) returns Bool
* A string to hex method can be found here: https://gist.github.com/arshad/de147c42d7b3063ef7bc
********************************************************************************************/
class File {
    
    class func exists (path: String) -> Bool {
        return NSFileManager().fileExistsAtPath(path)
    }
    
    class func read (path: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        if File.exists(path) {
            return String(contentsOfFile: path, encoding: encoding, error: nil)
        }
        
        return nil
    }
    
    class func write (path: String, content: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Bool {
        return content.writeToFile(path, atomically: true, encoding: encoding, error: nil)
    }
}



