import UIKit

class TextFildTableCell: UITableViewCell {

    @IBOutlet weak var txt_fild: UITextField!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var view_textfld_BG: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
