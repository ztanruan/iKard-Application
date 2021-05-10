//
//  NextButtonTableCell.swift
//  scan_wallet_info
//
//  Created by Teddys on 13/04/21.
//

import UIKit

class NextButtonTableCell: UITableViewCell {

    @IBOutlet weak var btn_Next: UIControl!
    @IBOutlet weak var btn_Tititle: UILabel!
    
    var didTappedOnNextButton: ((UIControl)->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btn_Next.backgroundColor = AppColor.blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btn_Next_Action(_ sender: UIControl) {
        if self.didTappedOnNextButton != nil {
            self.didTappedOnNextButton!(sender)
        }
    }

}
