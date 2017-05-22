//
//  AddBeacon.swift
//  iBeaconManager
//
//  Created by Yoel Lev on 5/21/17.
//  Copyright © 2017 YoelL. All rights reserved.
//

import UIKit

protocol AddBeacon {
    func addBeacon(item: Beacon)
}


class InsertBeacon: NSObject {
    
     weak var txtName: UITextField!
     weak var txtUUID: UITextField!
     weak var txtMajor: UITextField!
     weak var txtMinor: UITextField!

    
    let uuidRegex = try! NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
    
    var delegate: AddBeacon?

    
    
    
    
    
    
    
    
    
}
