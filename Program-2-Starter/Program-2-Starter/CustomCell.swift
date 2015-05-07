//
//  CustomCell.swift
//  Program-2-Starter
//
//  Created by Daniel Bowen on 4/26/15.
//  Copyright (c) 2015 mwsu. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell
{

    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
