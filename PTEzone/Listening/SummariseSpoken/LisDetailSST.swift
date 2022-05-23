//
//  DetailLisSumSpoText.swift
//  PTEzone
//
//  Created by Owner on 8/5/22.
//

import UIKit
import AVFoundation

class LisDetailSST: UIViewController{
    
    var player:AVPlayer!
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.play(url: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3")! as NSURL)
    }
    func play(url:NSURL) {
        print("playing \(url)")

        do {

            let playerItem = AVPlayerItem(url: url as URL)

            self.player = try AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    
}
