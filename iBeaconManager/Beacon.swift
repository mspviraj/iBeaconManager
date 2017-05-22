//
//  Beacon.swift
//  iBeaconManager
//
//  Created by Yoel Lev on 5/21/17.
//  Copyright © 2017 YoelL. All rights reserved.
//

import Foundation
import CoreLocation


struct BeaconConstant {
    static let nameKey = "name"
    static let iconKey = "icon"
    static let uuidKey = "uuid"
    static let majorKey = "major"
    static let minorKey = "minor"
}


class Beacon: NSObject, NSCoding {
    
    let name: String
    let icon: Int
    let uuid: UUID
    let majorValue: CLBeaconMajorValue
    let minorValue: CLBeaconMinorValue
    var beacon: CLBeacon?
    
    init(name: String, icon: Int, uuid: UUID, majorValue: Int, minorValue: Int) {
        self.name = name
        self.icon = icon
        self.uuid = uuid
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.minorValue = CLBeaconMinorValue(minorValue)
    }
    
    // MARK: NSCoding
    required init(coder aDecoder: NSCoder) {
        let aName = aDecoder.decodeObject(forKey: BeaconConstant.nameKey) as? String
        name = aName ?? ""
        
        let aUUID = aDecoder.decodeObject(forKey: BeaconConstant.uuidKey) as? UUID
        uuid = aUUID ?? UUID()
        
        icon = aDecoder.decodeInteger(forKey: BeaconConstant.iconKey)
        majorValue = UInt16(aDecoder.decodeInteger(forKey: BeaconConstant.majorKey))
        minorValue = UInt16(aDecoder.decodeInteger(forKey: BeaconConstant.minorKey))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: BeaconConstant.nameKey)
        aCoder.encode(icon, forKey: BeaconConstant.iconKey)
        aCoder.encode(uuid, forKey: BeaconConstant.uuidKey)
        aCoder.encode(Int(majorValue), forKey: BeaconConstant.majorKey)
        aCoder.encode(Int(minorValue), forKey: BeaconConstant.minorKey)
    }
    
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: uuid,
                              major: majorValue,
                              minor: minorValue,
                              identifier: name)
    }
    
    func locationString() -> String {
        guard let beacon = beacon else { return "Location: Unknown" }
        let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = "Location: \(proximity)"
        if beacon.proximity != .unknown {
            location += " (approx. \(accuracy)m)"
        }
        
        return location
    }
    
    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
    
}

func ==(item: Beacon, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == item.uuid.uuidString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}
