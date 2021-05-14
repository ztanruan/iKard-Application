import UIKit

class SelectImageTableCell: UITableViewCell {

    @IBOutlet weak var view_Base: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_ImgBG: UIView!
    @IBOutlet weak var img_plaeholder: UIImageView!
    @IBOutlet weak var img_mainImage: UIImageView!
    
    var didTappedOnCellForImagePicker: ((UIControl)->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func btn_ImagePick_Action(_ sender: UIControl) {
        if self.didTappedOnCellForImagePicker != nil {
            self.didTappedOnCellForImagePicker!(sender)
        }
    }
}
