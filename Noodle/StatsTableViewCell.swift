//

//  StatsTableViewCell.swift

//  Noodle

//

//  Created by Luis E. Arevalo on 11/21/17.

//  Copyright © 2017 pen15club. All rights reserved.

//



import UIKit



class StatsTableViewCell: UITableViewCell {
    
    
    
   
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var statNumberLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        
        
        // Configure the view for the selected state
        
    }
    
    
    
}



