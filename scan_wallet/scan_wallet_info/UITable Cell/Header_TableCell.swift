//
//  Header_TableCellTableViewCell.swift
//  scan_wallet_info
//
//  Created by Teddys on 13/04/21.
//

import UIKit

class Header_TableCell: UITableViewCell {

    @IBOutlet weak var img_Header: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
