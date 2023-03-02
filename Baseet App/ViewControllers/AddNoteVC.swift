//
//  AddNoteVC.swift
//  Baseet App
//
//  Created by VinodKatta on 17/07/22.
//

import UIKit
import AVFoundation

class AddNoteVC: UIViewController {
    
    @IBOutlet weak var DoneBtn: UIButton!{
        didSet{
            DoneBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Done", comment: ""), for: .normal)
        }
    }
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationName: UIButton!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            cancelButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CANCEL", comment: ""), for: .normal)
        }
    }
    
    @IBOutlet weak var addnoteLbl: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var personIMage: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    var notes:((String, String)->())?
    @IBOutlet weak var playButton: UIButton!
    var locallyTxtView:String!
    
    var soundRecorder:AVAudioRecorder?
    var soundPlayer: AVAudioPlayer!
    var addNotesVM = AddNoteVCVM()
    var filename = "audio.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setupRecord()
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            notesTextView.textAlignment = .left
            
        }else{
            notesTextView.textAlignment = .right
            
        }
        
        notesTextView.delegate = self
        notesTextView.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add Your Comment Here", comment: "")
        addnoteLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add Note", comment: "")
        notesTextView.textColor = UIColor.lightGray
        let disMissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(disMissKeyboardTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        pauseButton.layer.borderWidth = 2
        pauseButton.layer.borderColor = UIColor.gray.cgColor
        pauseButton.layer.cornerRadius = pauseButton.frame.height/2
        pauseButton.clipsToBounds = true
        self.pauseButton.isEnabled = false
        self.playButton.isEnabled = false
        
        if self.addNotesVM.notes?.count ?? 0 > 0 {
        self.notesTextView.text = self.addNotesVM.notes
        }
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.locationName.setTitle(UserDefaults.standard.string(forKey: "City_Name"), for: .normal)
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.userName.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.userName.isHidden = false
            self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
    
 /*   func checkForMicroPhonePermisson(sender: UIButton) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            self.actionForRecord(sender: sender)
        case .denied:
            let alert = UIAlertController(title: "Alert", message: "Please enable access for microphone from settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        case .undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                // Handle granted
                if granted {
                    self.actionForRecord(sender: sender)
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Please enable access for microphone from settings", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        @unknown default:
            let alert = UIAlertController(title: "Alert", message: "Please enable access for microphone from settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonPlay(_ sender: UIButton) {
        if self.recordButton.isEnabled {
            self.recordButton.isEnabled = false
            preparePlayer()
            soundPlayer?.play()
            self.playButton.tintColor = UIColor.red
            self.playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            self.pauseButton.tintColor = UIColor.red
            pauseButton.layer.borderColor = UIColor.red.cgColor
            self.pauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            self.recordButton.isEnabled = true
            soundPlayer?.stop()
            self.playButton.tintColor = UIColor.systemGreen
            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.pauseButton.tintColor = UIColor.systemGreen
            pauseButton.layer.borderColor = UIColor.systemGreen.cgColor
            self.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func preparePlayer()
    {
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: self.getFinalURL() as URL)
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1
            
        } catch {
            print("error in loading ")
        }
    }
    
    @IBAction func buttonPause(_ sender: UIButton)
    {
        if sender.currentImage == UIImage(systemName: "play.fill") || sender.currentImage == nil {
           if sender.currentImage == nil {
            preparePlayer()
            }
            soundPlayer?.play()
            pauseButton.layer.borderWidth = 2
            pauseButton.layer.borderColor = UIColor.red.cgColor
            pauseButton.layer.cornerRadius = pauseButton.frame.height/2
            pauseButton.clipsToBounds = true
            self.pauseButton.tintColor = UIColor.red
            self.pauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            soundPlayer?.pause()
            pauseButton.layer.borderWidth = 2
            pauseButton.layer.borderColor = UIColor.systemGreen.cgColor
            pauseButton.layer.cornerRadius = pauseButton.frame.height/2
            pauseButton.clipsToBounds = true
            self.pauseButton.tintColor = UIColor.systemGreen
            self.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        }
    }*/
    
    @IBAction func backBtn(_ sender: Any)
    {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionClose(_ sender: Any)
    {
        self.dismiss(animated: true,completion: nil)
    }
    
 /*   @IBAction func actionRecord(_ sender: UIButton)
    {
        self.timingLabel.text = "0.00"
        if sender.titleLabel?.text == "Record" {
        self.checkForMicroPhonePermisson(sender: sender)
        } else {
            self.soundRecorder?.stop()
            sender.setImage(UIImage(), for: .normal)
            sender.configuration?.imagePadding = 0
            sender.setTitle("Record", for: .normal)
            self.playButton.isEnabled = true
            self.pauseButton.isEnabled = true
            self.pauseButton.isEnabled = true
        }
    }
    
    func actionForRecord(sender: UIButton)
    {
        DispatchQueue.main.async {
                self.soundRecorder?.record()
                sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
                sender.tintColor = .red
                sender.configuration?.imagePadding = 5
                sender.setTitle("stop", for: .normal)
                self.playButton.isEnabled = false
                self.pauseButton.isEnabled = false
                self.pauseButton.isEnabled = false
        }
    }*/
    
    
    
    @IBAction func actionDone(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        self.notes?(self.notesTextView.text, "")
        self.locallyTxtView = notesTextView.text!
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        self.view.frame.origin.y  = 0
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
  /*  func setupRecord() {
        let audioSession = AVAudioSession.sharedInstance()
               do {
                   try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
               } catch let error as NSError {
                   print(error.description)
               }
        do {
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }

        let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),
                                AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
                        AVNumberOfChannelsKey : NSNumber(value: 1),
                     AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.max.rawValue))]

               do{
                   try soundRecorder = AVAudioRecorder(url: self.getFinalURL() as URL, settings: recordSettings)
                   soundRecorder?.delegate = self
                   soundRecorder?.prepareToRecord()
               }
               catch let error as NSError {
                   error.description
               }
    }
    
    func setupRecorder() {
        let recordSettings =  [AVFormatIDKey: kAudioFormatAppleLossless, AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue, AVEncoderBitRateKey: 320000, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0 ]
        as [String : Any]
        //   var error: NSError?
        do {
            soundRecorder = try AVAudioRecorder(url: self.getFinalURL() as URL, settings: recordSettings as [String: Any])
            
            soundRecorder?.delegate = self
            soundRecorder?.prepareToRecord()
        } catch {
            //hanldle error
            print("not recorder")
        }
        
    }
    
    func getCacheDirect() ->String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        return path[0]
    }
    
    
    func getFinalURL() ->NSURL {
        let path = (self.getCacheDirect() as NSString).appendingPathComponent(filename)
        let filePath = NSURL(fileURLWithPath: path)
        print(filePath)
        return filePath
    }*/
}

extension AddNoteVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {

        if notesTextView.textColor == UIColor.lightGray {
            notesTextView.text = ""
            notesTextView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTextView.text == "" {

            notesTextView.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add Your Comment Here", comment: "")
            notesTextView.textColor = UIColor.lightGray
        }
        
    }
}

/*extension AddNoteVC:  AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }
    
    // Helper function inserted by Swift migrator.
    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
    
    // completion of recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.playButton.isEnabled = true
            self.pauseButton.isEnabled = true
            let asset = AVAsset(url: self.getFinalURL() as URL)
            
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            print(durationTime)
            let timingString = secondsToHoursMinutesSeconds(seconds: durationTime)
            self.timingLabel.text = "\(timingString.1):\(timingString.2)"
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        self.recordButton.isEnabled = true
        self.playButton.tintColor = UIColor.systemGreen
        self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        self.pauseButton.tintColor = UIColor.systemGreen
        self.pauseButton.layer.borderColor = UIColor.systemGreen.cgColor
        self.pauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    func secondsToHoursMinutesSeconds(seconds: Double) -> (Int, Int, Int) {
        let (hr,  minf) = modf(seconds / 3600)
        let (min, secf) = modf(60 * minf)
        return (Int(hr), Int(min), Int(60 * secf))
    }
}*/

