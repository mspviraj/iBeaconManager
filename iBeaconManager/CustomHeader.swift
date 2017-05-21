//
//  CustomHeader.swift
//  iBeaconManager
//
//  Created by Yoel Lev on 5/21/17.
//  Copyright © 2017 YoelL. All rights reserved.
//

import UIKit


class CustomHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        print("in initCustomHeader ")
        setupHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Header Label"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    func  setupHeaderView(){
        print("in setup Header")
        addSubview(nameLabel)
        addConstraintsWithFormat("H:|-120-[v0]|",views: nameLabel)
        addConstraintsWithFormat("V:|[v0]|",views: nameLabel)
        
    }
    
    
    
}
