//
//  FuncTableViewCell.swift
//  Projeto
//
//  Created by dev on 21/08/2018.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit

class FuncTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var NomeFunc: UILabel!
    @IBOutlet weak var RGFunc: UILabel!
    @IBOutlet weak var FotoFunc: UIImageView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
