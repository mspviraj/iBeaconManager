//
//  BeaconsController.swift
//  iBeaconManager
//
//  Created by Yoel Lev on 5/21/17.
//  Copyright © 2017 YoelL. All rights reserved.
//

import UIKit

class BeaconController : UITableViewController {
    
    var items = ["item1","item2","item3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Beacons List"
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.sectionHeaderHeight = 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: #selector(insert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "InsertBatch", style: .plain, target: self, action: #selector(insertBatch))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomCell
        cell.nameLabel.text = items[indexPath.row]
        cell.customTableViewContrller = self
        
        return cell
    }
    
    
    func deleteCell(cell:UITableViewCell){
        
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
            
            
        }
        
    }
    
    
    
    
    
    func insert(){
        
        items.append("Item \(items.count + 1)")
        let insertionIndexPath = IndexPath(row: items.count - 1 , section: 0)
        tableView.insertRows(at: [insertionIndexPath], with: .automatic)
        
    }
    
    func insertBatch(){
        
        var indexPaths = [NSIndexPath]()
        
        for i in items.count...items.count + 10 {
            items.append("Item \(items.count + 1)")
            indexPaths.append(NSIndexPath(row: i, section: 0))
        }
        
        var bottomHalfIndexPaths = [NSIndexPath]()
        for _ in 0...indexPaths.count / 2 - 1 {
            bottomHalfIndexPaths.append(indexPaths.removeLast())
        }
        
        tableView.beginUpdates()
        
        tableView.insertRows(at: indexPaths as [IndexPath], with: .right)
        tableView.insertRows(at: bottomHalfIndexPaths as [IndexPath], with: .left)
        
        tableView.endUpdates()
        
    }
    
    
    
    //Header
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")
    }
    
    
    
    
    
    
}
