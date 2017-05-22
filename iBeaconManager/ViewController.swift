//
//  ViewController.swift
//  iBeaconManager
//
//  Created by Yoel Lev on 5/21/17.
//  Copyright © 2017 YoelL. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
     let locationManager = CLLocationManager()
     var beaconsArray = [Beacon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        add()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func startMonitoringItem(_ beacon: Beacon) {
        print("startMonitoringItem")
        let beaconRegion = beacon.asBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func stopMonitoringItem(_ beacon: Beacon) {
        print("stopMonitoringItem")
        let beaconRegion = beacon.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    
    func add(){
    
    
        var uuidString = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        uuidString = uuidString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        
        guard let uuid = UUID(uuidString: uuidString) else { return }
        let major = Int(53721)
        let minor = Int(40418)
        
        let newItem = Beacon(name: "Mint", icon: 1 , uuid:uuid , majorValue: major, minorValue: minor)
        beaconsArray.append(newItem)
        
        
        
        print(newItem.name)
        print(newItem.locationString())
        print(newItem.uuid)
        
        startMonitoringItem(newItem)
    
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton){
        
        let alertController = UIAlertController(title: "Add Beacon", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
//            let firstTextField = alertController.textFields![0] as UITextField
//            let secondTextField = alertController.textFields![1] as UITextField
            
            
          //  saveBeaconData()
            
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Beacon Name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Beacon UUID"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Major"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Minor"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}




//MARK: CLLocationManager Delegate - Listening for Your iBeacon
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        print("in range beacon")
        
        if beaconsArray.isEmpty {
            print("No Beacons in array")
        
        }else{
        
          print(beacons.description)
        
        }
    }
        
}
    



