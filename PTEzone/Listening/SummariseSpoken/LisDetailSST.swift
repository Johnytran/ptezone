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
    var observer: NSKeyValueObservation?
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        download()
    }
    
    func download() {
        
        let view = LoadingAudioView.instanceFromNib()
        self.view.addSubview(view)
        
        let videoUrl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3"
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        let destPath = NSString(string: documentPath).appendingPathComponent("SoundHelix-Song-17.mp3") as String
        if FileManager.default.fileExists(atPath: destPath) {
            print("file already exist at \(destPath)")
            
            self.playVideo(url: NSURL(fileURLWithPath: destPath))
            
            return
        }
        URLSession.shared.downloadTask(with: URL(string: videoUrl)!) { (location:URL?, response:URLResponse?, err:Error?) -> Void in
            if let _ = location {
                do {
                    try FileManager.default.moveItem(at: location!, to: URL(fileURLWithPath: destPath))
                    
                    self.playVideo(url: NSURL(fileURLWithPath: destPath))
                }catch let error as NSError {
                    print("move file error: \(error.localizedDescription)")
                }
            } else {
                print("location err: \(String(describing: location))")
            }
        }.resume()
    }
    func playVideo(url:NSURL) {
        
        do {

            
            let avAsset = AVAsset(url: url as URL)
            let playerItem = AVPlayerItem(asset: avAsset)
            //Register as an observer of the player item's status property
               self.observer = playerItem.observe(\.status, options:  [.new, .old], changeHandler: { (playerItem, change) in
                   if playerItem.status == .readyToPlay {
                       print("ready")
                   }
               })
            self.player = try AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
            
            let duration:CMTime  = player.currentItem!.duration; //total time
            let currentTime = player.currentItem!.currentTime(); //playing time
            let dur:Float64 = CMTimeGetSeconds(duration);
            let cur:Float64 = CMTimeGetSeconds(currentTime);
            
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
            progressView.setProgress(Float(cur/dur), animated: false)
            
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    @objc func updateAudioProgressView()
    {
       if self.player.isPlaying
          {
            let duration:CMTime  = player.currentItem!.duration; //total time
            let currentTime = player.currentItem!.currentTime(); //playing time
            let dur:Float64 = CMTimeGetSeconds(duration);
            let cur:Float64 = CMTimeGetSeconds(currentTime);
           // Update progress
            progressView.setProgress(Float(cur/dur), animated: true)
          }
    }
    
}
extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
extension String{
    func uniqueFilename(withPrefix prefix: String? = nil) -> String {
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        
        if prefix != nil {
            return "\(prefix!)-\(uniqueString)"
        }
        
        return uniqueString
    }
}
