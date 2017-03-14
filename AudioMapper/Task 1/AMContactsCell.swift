//
//  AMContactsCell.swift
//  AudioMapper
//
//  Created by KrishnaChaitanya Amjuri on 13/03/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit

class AMContactsCell: UITableViewCell {

    let nameLabel: UILabel = UILabel()
    let phoneNumberLabel: UILabel = UILabel()
    let thumbImageView: UIImageView = UIImageView()
    let cellView: UIView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = AMColor.appBlue
        self.addRelatedViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbImageView.image = UIImage(named: "AMPlaceholder")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        cellView.frame = CGRect(x: 5, y: 5, width: self.contentView.bounds.size.width-10, height: self.contentView.bounds.size.height-10)
        thumbImageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        nameLabel.frame = CGRect(x: thumbImageView.frame.origin.x+thumbImageView.frame.size.width+10, y: thumbImageView.frame.origin.y+5, width: cellView.bounds.size.width-(thumbImageView.frame.origin.x+thumbImageView.frame.size.width+10), height: 20)
        phoneNumberLabel.frame = CGRect(x: thumbImageView.frame.origin.x+thumbImageView.frame.size.width+10, y: nameLabel.frame.origin.y+nameLabel.frame.size.height+5, width: cellView.bounds.size.width-(thumbImageView.frame.origin.x+thumbImageView.frame.size.width+10), height: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func addRelatedViews() {
        cellView.layer.cornerRadius = 5
        cellView.backgroundColor = UIColor.white
        self.contentView.addSubview(cellView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = AMColor.appDarkBlack
        nameLabel.textAlignment = .left
        
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 16)
        phoneNumberLabel.textColor = AMColor.appLightBlack
        phoneNumberLabel.textAlignment = .left
        
        thumbImageView.contentMode = .scaleAspectFit
        thumbImageView.image = UIImage(named: "AMPlaceholder")
        
        cellView.addSubview(nameLabel)
        cellView.addSubview(phoneNumberLabel)
        cellView.addSubview(thumbImageView)
    }
}
