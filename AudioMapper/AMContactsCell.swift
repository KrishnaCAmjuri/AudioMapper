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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = AMColor.appDarkBlack
        nameLabel.textAlignment = .left
        
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 16)
        phoneNumberLabel.textColor = AMColor.appLightBlack
        phoneNumberLabel.textAlignment = .left
        
        thumbImageView.contentMode = .scaleAspectFit
        thumbImageView.image = UIImage(named: "AMPlaceholder")
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(phoneNumberLabel)
        self.contentView.addSubview(thumbImageView)
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
     
        thumbImageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        nameLabel.frame = CGRect(x: thumbImageView.frame.origin.x+thumbImageView.frame.size.width+10, y: thumbImageView.frame.origin.y+5, width: self.contentView.bounds.size.width-(thumbImageView.frame.origin.x+thumbImageView.frame.size.width+10), height: 20)
        phoneNumberLabel.frame = CGRect(x: thumbImageView.frame.origin.x+thumbImageView.frame.size.width+10, y: nameLabel.frame.origin.y+nameLabel.frame.size.height+5, width: self.contentView.bounds.size.width-(thumbImageView.frame.origin.x+thumbImageView.frame.size.width+10), height: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
