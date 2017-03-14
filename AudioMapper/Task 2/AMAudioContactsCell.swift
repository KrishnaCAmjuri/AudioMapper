//
//  ANAudioContactsCell.swift
//  AudioMapper
//
//  Created by KrishnaChaitanya Amjuri on 13/03/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit

protocol AudioCellDelegate:class {
    
    func playButtonClicked(for identifier: String)
    func recordButtonClicked(for identifier: String)
    func stopRecording(for identifier: String)
    func stopPlaying(for identifier: String)
}

class AMAudioContactsCell: AMContactsCell {

    var delegate: AudioCellDelegate?
    
    var identifer: String = ""
    
    let recordButton: UIButton = UIButton(type: UIButtonType.custom)
    let playButton: UIButton = UIButton(type: UIButtonType.custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addAudioRelatedButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        playButton.frame = CGRect(x: -20+self.cellView.frame.size.width/3, y: thumbImageView.frame.origin.y+thumbImageView.frame.size.height+10, width: 40, height: 40)
        recordButton.frame = CGRect(x: -20+2*self.cellView.frame.size.width/3, y: thumbImageView.frame.origin.y+thumbImageView.frame.size.height+10, width: 40, height: 40)
    }
    
    func addAudioRelatedButtons() {
        
        recordButton.setImage(UIImage(named: "AMRecordIcon"), for: UIControlState.normal)
        recordButton.setImage(UIImage(named: "AMStopIcon"), for: UIControlState.selected)
        recordButton.backgroundColor = AMColor.appBlue.withAlphaComponent(0.5)
        
        playButton.setImage(UIImage(named: "AMPlayIcon"), for: UIControlState.normal)
        playButton.setImage(UIImage(named: "AMStopIcon"), for: UIControlState.selected)
        playButton.backgroundColor = AMColor.appBlue.withAlphaComponent(1.0)

        playButton.addTarget(self, action: #selector(self.playAudio(sender:)), for: UIControlEvents.touchDown)
        recordButton.addTarget(self, action: #selector(self.recordAudio(sender:)), for: UIControlEvents.touchDown)
        
        self.cellView.addSubview(recordButton)
        self.cellView.addSubview(playButton)
    }
    
    func playAudio(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if self.delegate != nil {
        
            if sender.isSelected {
                self.delegate?.playButtonClicked(for: self.identifer)
            }else {
                self.delegate?.stopPlaying(for: self.identifer)
            }
        }
    }
    
    func recordAudio(sender: UIButton) {

        sender.isSelected = !sender.isSelected
        
        if self.delegate != nil {
        
            if sender.isSelected {
                self.delegate?.recordButtonClicked(for: self.identifer)
            }else {
                self.delegate?.stopRecording(for: self.identifer)
            }
        }
    }
}
