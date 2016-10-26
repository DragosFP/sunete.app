//
//  AdaugaSunetViewController.swift
//  Sunete - iOS 10
//
//  Created by Dragos Florin on 10/9/16.
//  Copyright © 2016 Dragos Florin. All rights reserved.
//

import UIKit
import AVFoundation

class AdaugaSunetViewController: UIViewController {
    @IBOutlet weak var butonInregistreaza: UIButton!
    @IBOutlet weak var butonAsculta: UIButton!
    @IBOutlet weak var campText: UITextField!
    @IBOutlet weak var butonSalveaza: UIButton!
    
    var inregistrareAudio : AVAudioRecorder?
    var asculta : AVAudioPlayer?
    var sunetURL : URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        setariInregistrare()
        butonAsculta.isEnabled = false
        butonSalveaza.isEnabled = false
        
    }
    
    func setariInregistrare() {
        
        do {
            // Create an audio session
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord) //ne permite sa play and record
            try session.overrideOutputAudioPort(.speaker) // ne permite sa ascultam la difuzoare
            try session.setActive(true)
            
            
            //Create URL for the audio file
            
            let basePath : String  = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponente = [basePath, "sunet.m4a"]
            
            sunetURL = NSURL.fileURL(withPathComponents: pathComponente)!
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            print(sunetURL)
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            
            //Create settings for audio recorder
            
            var setari : [String:AnyObject] = [:]
            setari[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            setari[AVSampleRateKey] = 44100.0 as AnyObject?
            setari[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            // Create AudioRecorder (inregistrareAudio) object
            
            inregistrareAudio =  try AVAudioRecorder (url: sunetURL!, settings: setari)
            inregistrareAudio!.prepareToRecord()
            
            
        } catch  let error as NSError{
            print (error)
        }
    }


    @IBAction func inregistreazaApasat(_ sender: AnyObject) {
        if inregistrareAudio!.isRecording{
            // Stop the recording
            inregistrareAudio?.stop()
            
            //Schimba butonul in Inregistreaza
            butonInregistreaza.setTitle("Inregistreaza", for: .normal)
            
            butonAsculta.isEnabled = true
            butonSalveaza.isEnabled = true
        }else {
            // Start the recording
            inregistrareAudio?.record()
            
            //Schimba butonul in Stop
            butonInregistreaza.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func ascultaApasat(_ sender: AnyObject) {
        //Setare Audio Player
        do{
            try asculta = AVAudioPlayer(contentsOf: sunetURL!)
            asculta!.play()
        }catch {}

    } 
    
    @IBAction func salveazaApasat(_ sender: AnyObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sunet(context: context)
        
        sound.nume = campText.text
        
        sound.audio = NSData(contentsOf: sunetURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
        
    }
    
    
}
