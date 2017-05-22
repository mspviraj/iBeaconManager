//
//  BeaconsController.swift
//  iBeaconManager
//
//  Created by Yoel Lev on 5/21/17.
//  Copyright © 2017 YoelL. All rights reserved.
//

import UIKit
import CoreLocation

let storedItemsKey = "storedItems"

class BeaconController : UITableViewController {
    
    var beaconsArray = [Beacon]()
    
    //Beacon Manager
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Beacons List"
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.sectionHeaderHeight = 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: #selector(insert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "InsertBatch", style: .plain, target: self, action: #selector(insertBatch))
        
        
        //Beacon Auth -  the app can start any of the available location services while it is running in the foreground or background
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        loadItems()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func insert(){
        addBeacon()
    }
    
    func insertBatch(){
        
//        var indexPaths = [NSIndexPath]()
//        
//        for i in items.count...items.count + 10 {
//            items.append("Item \(items.count + 1)")
//            indexPaths.append(NSIndexPath(row: i, section: 0))
//        }
//        
//        var bottomHalfIndexPaths = [NSIndexPath]()
//        for _ in 0...indexPaths.count / 2 - 1 {
//            bottomHalfIndexPaths.append(indexPaths.removeLast())
//        }
//        
//        tableView.beginUpdates()
//        
//        tableView.insertRows(at: indexPaths as [IndexPath], with: .right)
//        tableView.insertRows(at: bottomHalfIndexPaths as [IndexPath], with: .left)
//        
//        tableView.endUpdates()
        
    }
    
    func addBeaconData( ){
        
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
            textField.placeholder = " Beacon Name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = " UUID"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = " Major"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = " Minor"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addBeacon(){
    
        var uuidString = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        uuidString = uuidString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        
         guard let uuid = UUID(uuidString: uuidString) else { return }
        let major = Int(53721)
        let minor = Int(40418)
        
        let newItem = Beacon(name: "Mint", icon: 1 , uuid:uuid , majorValue: major, minorValue: minor)
        print(newItem.name)
        print(newItem.locationString())
        print(newItem.uuid)
        
        beaconsArray.append(newItem)
        refreshTableView(beacon: newItem)
    }
    
    
    func refreshTableView(beacon:Beacon){

        tableView.beginUpdates()
        let newIndexPath = IndexPath(row: beaconsArray.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.endUpdates()
        
         startMonitoringItem(beacon)
        persistItems()

    }
    
    
    //MARK:Data Persistance
    
    func loadItems() {
        guard let storedItems = UserDefaults.standard.array(forKey: storedItemsKey) as? [Data] else { return }
        for beaconData in storedItems {
            guard let beacon = NSKeyedUnarchiver.unarchiveObject(with: beaconData) as? Beacon else { continue }
            beaconsArray.append(beacon)
            startMonitoringItem(beacon)
        }
    }
    
    func persistItems() {
        var itemsData = [Data]()
        for beacon in beaconsArray {
            let beaconData = NSKeyedArchiver.archivedData(withRootObject: beacon)
            itemsData.append(beaconData)
        }
        
        UserDefaults.standard.set(itemsData, forKey: storedItemsKey)
        UserDefaults.standard.synchronize()
    }
    
}

//MARK: TableView
extension BeaconController  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beaconsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomCell
        cell.beaconLabel.text = beaconsArray[indexPath.row].name
        cell.proximityLabel.text = beaconsArray[indexPath.row].locationString()
        cell.customTableViewContrller = self
          
        return cell
    }
    
    
    func deleteCell(cell:UITableViewCell){
        
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            beaconsArray.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }

    //Header
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            stopMonitoringItem(beaconsArray[indexPath.row])
            
            tableView.beginUpdates()
            beaconsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            persistItems()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = beaconsArray[indexPath.row]
        let detailMessage = "UUID: \(item.uuid.uuidString)\nMajor: \(item.majorValue)\nMinor: \(item.minorValue)"
        let detailAlert = UIAlertController(title: "Details", message: detailMessage, preferredStyle: .alert)
        detailAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(detailAlert, animated: true, completion: nil)
    }
    
    
}



//MARK: CLLocationManager Delegate - Listening for Your iBeacon
extension BeaconController: CLLocationManagerDelegate {
    
    
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

    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        
        print(beacons.description)
        
        // Find the same beacons in the table.
        var indexPaths = [IndexPath]()
        for beacon in beacons {
            for row in 0..<beaconsArray.count {
                if beaconsArray[row] == beacon {
                    beaconsArray[row].beacon = beacon
                    indexPaths += [IndexPath(row: row, section: 0)]
                }
            }
        }
        
        // Update beacon locations of visible rows.
        if let visibleRows = tableView.indexPathsForVisibleRows {
            let rowsToUpdate = visibleRows.filter { indexPaths.contains($0) }
            for row in rowsToUpdate {
                let cell = tableView.cellForRow(at: row) as! CustomCell
                cell.refreshLocation()
                
            }
        }
        
    }

}







