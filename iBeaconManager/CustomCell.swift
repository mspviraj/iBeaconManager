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
    

    
    var beacon: Beacon? = nil {
        didSet {
            if let beacon = beacon {
                 imgIcon.image = UIImage(named: "beaconMint")
                beaconLabel.text = beacon.name
                proximityLabel.text = beacon.locationString()
            } else {
                imgIcon.image = nil
                beaconLabel.text = "unknown"
                proximityLabel.text = "-1"
            }
        }
    }
    
    func refreshLocation() {
        proximityLabel.text = beacon?.locationString() ?? "-2"
        print( beacon?.locationString() ?? "non")
    }
    
    
    let imgIcon:UIImageView={
    
        let imageView = UIImageView()
        imageView.image = UIImage(named:"beaconBlue")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    
    
    
    
    }()
    
    
    
    let beaconLabel:UILabel = {
        let label = UILabel()
        label.text = "beaconLabel"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var proximityLabel:UILabel = {
        let label = UILabel()
        label.text = "prox"
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
        addSubview(beaconLabel)
        addSubview(proximityLabel)
        addSubview(imgIcon)
     
        addConstraintsWithFormat("H:|-8-[v0(44)]|",views: imgIcon)
        addConstraintsWithFormat("V:|-16-[v0(44)]|",views: imgIcon)
        
        addConstraintsWithFormat("H:|-64-[v0]|",views: beaconLabel)
        addConstraintsWithFormat("V:|-16-[v0]",views: beaconLabel)
        
        addConstraintsWithFormat("H:|-64-[v0]|",views: proximityLabel)
        addConstraintsWithFormat("V:[v0]-16-|",views: proximityLabel)
        
        
//cell button
        
//        addSubview(actionButton)
//        addConstraintsWithFormat("H:|-300-[v0]-8-|",views: actionButton)
//        addConstraintsWithFormat("V:|[v0]|",views: actionButton)
//        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        
        
    }
    
    
    
    func handleAction(){
        print("Action button tapped")
        customTableViewContrller?.deleteCell(cell: self)
        
    }
    
    
}
