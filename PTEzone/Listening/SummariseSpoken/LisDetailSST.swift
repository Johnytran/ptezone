//
//  DetailLisSumSpoText.swift
//  PTEzone
//
//  Created by Owner on 8/5/22.
//

import UIKit
import AVFoundation

class LisDetailSST: UIViewController, URLSessionDownloadDelegate{
    
    
    @IBOutlet weak var progressConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var instructView: CornerGradientView!
    
    @IBOutlet weak var ButtonView: CornerGradientView!
    @IBOutlet weak var fullTextView: CornerGradientView!
    private var answerView:ViewAnswerText? = nil
    
    @IBAction func ShowFullText(_ sender: Any) {
        self.fullTextView.setIsHidden(false, animated: true)
        self.progressConstrant.constant = -150;
        self.instructView.setIsHidden(true, animated: true)
    }
    func createAnswerView(){
        answerView = Bundle.main.loadNibNamed("ViewAnswerText", owner:
        self, options: nil)?.first as? ViewAnswerText
        self.view.addSubview(answerView!)
        answerView?.translatesAutoresizingMaskIntoConstraints = false
        if(self.fullTextView.isHidden){
            answerView?.topAnchor.constraint(equalTo: self.ButtonView.topAnchor, constant: 150).isActive = true
        }else{
            answerView?.topAnchor.constraint(equalTo: self.fullTextView.topAnchor, constant: 180).isActive = true
        }
    
        answerView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        answerView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        answerView?.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    @IBAction func ViewAnswer(_ sender: Any) {
        if(self.answerView != nil){
            self.answerView!.removeFromSuperview()
            createAnswerView()
        }else{
            createAnswerView()
        }

    }
    
    
    
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finished");
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        let destPath = NSString(string: documentPath).appendingPathComponent(self.audioName) as String
        do {
            try FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: destPath))

            self.playVideo(url: NSURL(fileURLWithPath: destPath))
            DispatchQueue.main.async {
                self.messageView.removeFromSuperview()
            }

        }catch let error as NSError {
            print("move file error: \(error.localizedDescription)")
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        let percentage = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let progressPercent = Int(percentage*100)
        DispatchQueue.main.async {
            self.messageView.msgLabel.text = "Loading audio: "+String(progressPercent)+" %"
        }
        
        print("percentage : ", progressPercent)
    }
    
    var player:AVPlayer!
    var observer: NSKeyValueObservation?
    private lazy var urlSession: URLSession = {
            let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier ?? "").background")
            config.isDiscretionary = true
            config.sessionSendsLaunchEvents = true
            return URLSession(configuration: config, delegate: self, delegateQueue: nil)
        }()
    var messageView = LoadingAudioView()
    var audioName:String!
    var task = URLSessionDownloadTask()
    var audioURl:String!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.audioName = "SoundHelix-Song-40.mp3"
//        self.audioURl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3"
//        download(url: self.audioURl)
    }
    func skipSession(){
        print("skip");
        task.cancel()
        self.navigationController?.popViewController(animated: true)
    }
    func reloadAudio(){
        self.messageView.removeFromSuperview()
        download(url: self.audioURl)
    }
    func download(url:String) {
        
        self.messageView = LoadingAudioView.instanceFromNib() as! LoadingAudioView
        self.messageView.setParent(refParent: self)
        self.view.addSubview(messageView)
        
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        let destPath = NSString(string: documentPath).appendingPathComponent(self.audioName) as String
        if FileManager.default.fileExists(atPath: destPath) {
            print("file already exist at \(destPath)")
            self.messageView.removeFromSuperview()
            self.playVideo(url: NSURL(fileURLWithPath: destPath))
            
            return
        }else{
            task = urlSession.downloadTask(with: URL(string: url)!)
        }
        
        
        
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
//            player!.play()
            
            
            
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        DispatchQueue.main.async {
            let duration:CMTime  = self.player.currentItem!.duration; //total time
            let currentTime = self.player.currentItem!.currentTime(); //playing time
            let dur:Float64 = CMTimeGetSeconds(duration);
            let cur:Float64 = CMTimeGetSeconds(currentTime);

            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateAudioProgressView), userInfo: nil, repeats: true)
            self.progressView.setProgress(Float(cur/dur), animated: false)
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
extension UIView {
    func setIsHidden(_ hidden: Bool, animated: Bool) {
        if animated {
            if self.isHidden && !hidden {
                self.alpha = 0.0
                self.isHidden = false
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = hidden ? 0.0 : 1.0
            }) { (complete) in
                self.isHidden = hidden
            }
        } else {
            self.isHidden = hidden
        }
    }
}
