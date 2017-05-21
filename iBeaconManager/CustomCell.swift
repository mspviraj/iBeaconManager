//
//  CustomCell.swift
//  iBeaconManager
//
//  Created by Yoel Lev on 5/21/17.
//  Copyright © 2017 YoelL. All rights reserved.
//

import UIKit


class CustomCell: UITableViewCell {
    
    var customTableViewContrller:BeaconController?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
        
    }()
    
    
    
    
    func  setupViews(){
        
        //cell label
        addSubview(nameLabel)
        addConstraintsWithFormat("H:|-16-[v0]|",views: nameLabel)
        addConstraintsWithFormat("V:|[v0]|",views: nameLabel)
        
        //cell button
        
        addSubview(actionButton)
        addConstraintsWithFormat("H:|-300-[v0]-8-|",views: actionButton)
        addConstraintsWithFormat("V:|[v0]|",views: actionButton)
        
        
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        
        
    }
    
    
    
    func handleAction(){
        print("Action button tapped")
        customTableViewContrller?.deleteCell(cell: self)
        
    }
    
    
    
}
