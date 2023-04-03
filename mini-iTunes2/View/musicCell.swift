//
//  musicCell.swift
//  mini-iTunes2
//
//  Created by Howe on 2023/3/21.
//

import UIKit

class musicCell: UITableViewCell {
    
    
    @IBOutlet weak var artworkUrl100: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
