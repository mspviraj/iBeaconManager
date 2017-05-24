//
//  Extensions.swift
//  iBeaconManager
//
//  Created by Yoel Lev on 5/21/17.
//  Copyright © 2017 YoelL. All rights reserved.
//

import UIKit

//MARK: UIView Extension

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    func anchorToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant)
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
 
    
}

//MARK: Int Extension

extension Int {

    public var digitCount: Int {
        get {
            return numberOfDigits(in: self)
        }
    }
    
    // private recursive method for counting digits
    private func numberOfDigits(in number: Int) -> Int {
        if abs(number) < 10 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number/10)
        }
    }

}

//MARK: UIAlertController Extension

extension UIAlertController {
    
    func isValidEmail(_ email: String) -> Bool {
        
        let emailValid = email.characters.count > 0 && NSPredicate(format: "self matches %@", "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,64}").evaluate(with: email)
        
            colorValidator(validParam: emailValid, forField: 0)
        
        return emailValid
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.characters.count > 4 && password.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
    }
    
    func isValidName(_ name:String)->Bool{
        
        let nameValid = (name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count > 0)

            colorValidator(validParam: nameValid, forField: 0)
        
        return nameValid
    }
    
    func isValidUUID(_ uuid:String)-> Bool {
    
        let uuidRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
        
        // Is UUID valid?
        var uuidValid = false
        let uuidString = uuid.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if uuidString.characters.count > 0 {
            uuidValid = (uuidRegex.numberOfMatches(in: uuidString, options: [], range: NSMakeRange(0, uuidString.characters.count)) > 0)
        }
        
        
        colorValidator(validParam: uuidValid, forField: 1)
        
        
        return uuidValid
    }
    
    func isValidMajor(_ major:Int)->Bool {
        
        if (major.digitCount == 5 ){
            
            colorValidator(validParam: true, forField: 2)
            return true
        }
        
            colorValidator(validParam: false, forField: 2)
        
        return false
    }
    
    func isValidMinor(_ minor:Int )->Bool {
        
        if  ( minor.digitCount == 5 ){
            
            colorValidator(validParam: true, forField: 3)
            return true
        }
        
        colorValidator(validParam: false, forField: 3)
        return false
    }

    func textDidChangeInLoginAlert() {
        if let email = textFields?[0].text,
            let password = textFields?[1].text,
            let action = actions.last {
            action.isEnabled = isValidEmail(email) && isValidPassword(password)
        }
    }
    
    func textDidChangeInAddBeaconAlert(){
        
         if let beaconName = textFields?[0].text,
            let uuid = textFields?[1].text,
            let major = textFields?[2].text,
            let minor = textFields?[3].text,
            let action = actions.last {
        
            guard isValidName(beaconName) && isValidUUID(uuid) && isValidMajor(Int(major)!) && isValidMinor(Int(minor)!) else {
                
                if isValidName(beaconName) == false {
                    textFields?[0].text = "Beacon Must Have a Name"
                    textFields?[0].textColor = UIColor.red
                    }
                
                if isValidUUID(uuid) == false {
                    textFields?[1].textColor = UIColor.red
                    }
                
                if isValidMajor(Int(major)!) == false {
                    textFields?[2].textColor = UIColor.red
                    }
                
                if isValidMinor(Int(minor)!) == false {
                    textFields?[3].textColor = UIColor.red
                    }

                return
                }
            
            
            action.isEnabled = isValidName(beaconName) && isValidUUID(uuid) && isValidMajor(Int(major)!) && isValidMinor(Int(minor)!)
        
        
            }
        }
    
    func colorValidator(validParam:Bool,forField:Int) {
        
        if validParam {
            textFields?[forField].textColor = UIColor.blue
        }else{
            
            textFields?[forField].textColor = UIColor.red
        }

    }

}

