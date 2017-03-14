//
//  AMAudioContactsViewController.swift
//  AudioMapper
//
//  Created by KrishnaChaitanya Amjuri on 13/03/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit
import AVFoundation
import PKHUD

class AMAudioContactsViewController: AMContactsViewController {

    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var currentlyRecording: [String : Bool] = [:] // dictionary of identifier : boolean for recording
    var currentlyPlaying: [String : Bool] = [:] // dictionary of identifier : boolean for playing
    
    var currentlyStatic: Bool = true // nothing is either playing or recording
    var lastIdentifier: String = ""
    
    var allowedToRecord: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Task 2"
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                DispatchQueue.main.async {
                    self.allowedToRecord = allowed
                }
            })
        }catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func showHUD(for message: String) {

        let pkhud: PKHUDTextView = PKHUDTextView(text: message)
        PKHUD.sharedHUD.contentView = pkhud
        PKHUD.sharedHUD.show()
        PKHUD.sharedHUD.hide(afterDelay: 2)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return filteredContacts.count > 0 ? 140 : (self.tableView.bounds.size.height-50)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if filteredContacts.count > 0 {
            guard let cell:AMAudioContactsCell = tableView.dequeueReusableCell(withIdentifier: "audioReuseIdentifier", for: indexPath) as? AMAudioContactsCell else {
                return UITableViewCell()
            }
            
            var contact: AMContact = AMContact(primaryPhoneNumber: "", givenName: "", thumbImage: nil)
            
            cell.delegate = self
            
            if indexPath.row < self.filteredContacts.count {
                contact = filteredContacts[indexPath.row]
            }
            
            cell.nameLabel.text = contact.givenName
            cell.phoneNumberLabel.text = contact.primaryPhoneNumber
            if let image:UIImage = contact.thumbImage {
                cell.thumbImageView.image = image
            }
            
            cell.identifer = "\(contact.givenName)_\(contact.primaryPhoneNumber)"
            
            if let recordButtonSelected: Bool = self.currentlyRecording[cell.identifer] {
                cell.recordButton.isSelected = recordButtonSelected
            }else {
                cell.recordButton.isSelected = false
            }
            
            if let playButtonSelected: Bool = self.currentlyPlaying[cell.identifer] {
                cell.playButton.isSelected = playButtonSelected
            }else {
                cell.playButton.isSelected = false
            }
        
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
        
        guard let cell:AMEmptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as? AMEmptyCell else {
            return UITableViewCell()
        }
        
        cell.messageLabel.text = self.isFetchingData ? "" : "No results found for search"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
}

extension AMAudioContactsViewController: AudioCellDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func playButtonClicked(for identifier: String) {
        
        if currentlyStatic {

            let pathString: String = identifier
            let outputUrl:URL = self.applicationDocumentUrl().appendingPathComponent("\(pathString)_path.m4a")

            let fileManager = FileManager()
            let fileExists:Bool = fileManager.fileExists(atPath: outputUrl.path)
            if !fileExists {
                self.tableView.reloadData()
                self.showHUD(for: "No recorded audio")
                return
            }
            
            self.lastIdentifier = identifier
            self.showHUD(for: "Audio play started")
            self.currentlyPlaying[lastIdentifier] = true
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: outputUrl)
                audioPlayer?.volume = 1.0
                audioPlayer?.prepareToPlay()
                audioPlayer?.delegate = self                
                audioPlayer?.play()
            } catch {

            }
        }else {
            self.currentlyRecording[lastIdentifier] = false
            self.currentlyPlaying[lastIdentifier] = false
            self.showHUD(for: "Audio play interrupted and stopped")
            self.deallocAudioRecorder()
            self.deallocAudioPlayer()
        }
        
        self.tableView.reloadData()
        
        currentlyStatic = !currentlyStatic
    }
    
    func recordButtonClicked(for identifier: String) {
        
        if currentlyStatic {
            self.lastIdentifier = identifier

            let pathString: String = identifier
            let outputUrl:URL = self.applicationDocumentUrl().appendingPathComponent("\(pathString)_path.m4a")
            let recordSettings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            do {
                audioRecorder = try AVAudioRecorder(url: outputUrl, settings: recordSettings)
                audioRecorder!.delegate = self
                audioRecorder!.isMeteringEnabled = true
                audioRecorder!.prepareToRecord()
                audioRecorder?.record()
            }catch let error {
                print(error.localizedDescription)
            }
            
            self.currentlyRecording[lastIdentifier] = true
            
            self.showHUD(for: "Recording started")
        }else {
            self.currentlyRecording[lastIdentifier] = false
            self.currentlyPlaying[lastIdentifier] = false
            
            self.showHUD(for: "Recording interrupted and stopped. Saving..")
            self.deallocAudioRecorder()
            self.deallocAudioPlayer()
        }
        
        self.tableView.reloadData()
        
        currentlyStatic = !currentlyStatic
    }
    
    func stopPlaying(for identifier: String) {
       
        self.currentlyRecording[lastIdentifier] = false
        self.currentlyPlaying[lastIdentifier] = false
        
        self.tableView.reloadData()
        
        currentlyStatic = true
        
        self.deallocAudioRecorder()
        self.deallocAudioPlayer()

        self.showHUD(for: (lastIdentifier == identifier) ? "Audio play stopped" : "Audio play interrupted and stopped")
    }
    
    func stopRecording(for identifier: String) {
       
        self.currentlyRecording[lastIdentifier] = false
        self.currentlyPlaying[lastIdentifier] = false
        
        self.tableView.reloadData()
        
        currentlyStatic = true
        
        self.deallocAudioRecorder()
        self.deallocAudioPlayer()
        
        self.showHUD(for: (lastIdentifier == identifier) ? "Audio recording stopped. Saving ..." : "Audio recording interrupted and stopped. Saving ...")
    }
    
    func deallocAudioPlayer() {
        if self.audioPlayer != nil {
            self.audioPlayer?.stop()
            self.audioPlayer = nil
        }
    }
    
    func deallocAudioRecorder() {
        if self.audioRecorder != nil {
            self.audioRecorder?.stop()
            self.audioRecorder = nil
        }
    }
    
    func applicationDocumentUrl() -> URL {
        
        let fileManager = FileManager()
        let urls:[URL] = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlaying(for: self.lastIdentifier)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print(flag)
    }

}
