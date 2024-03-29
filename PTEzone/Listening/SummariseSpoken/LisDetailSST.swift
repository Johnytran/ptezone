//
//  DetailLisSumSpoText.swift
//  PTEzone
//
//  Created by Owner on 8/5/22.
//

import UIKit
import AVFoundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

class LisDetailSST: UIViewController, URLSessionDownloadDelegate, UITextViewDelegate{
    
    
    
    @IBOutlet weak var userAnswer: UITextView!
    @IBOutlet weak var progressConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var instructView: CornerGradientView!
    
    @IBOutlet weak var ButtonView: CornerGradientView!
    @IBOutlet weak var fullTextView: CornerGradientView!
    private var answerView:ViewAnswerText? = nil
    private var analyseView:LisSumAnalyse? = nil
    private var loadingView:Loading? = nil
    private var keywords = [String]()
    private var countKeyWord: Int = 0
    private var observation: NSKeyValueObservation?
    deinit {
        observation?.invalidate()
      }
    
    @IBOutlet weak var answerText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioName = "SoundHelix-Song-55.mp3"
        self.audioURl = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3"
        download(url: self.audioURl)
        
        answerText.delegate = self
        answerText.text = "Type your answer here."
        answerText.textColor = UIColor.purple
        self.keywords = ["book","the Republic","readable","living conversation","important ideas", "thoughts", "fundamental questions", "answer"]
    }
    @IBAction func PlayAudio(_ sender: Any) {
        if((player) != nil){
            player!.play()
        }else{
            
            download(url: self.audioURl)
        }
    }
    @IBAction func SubmitTest(_ sender: Any) {
        
        
        let attributedText = NSMutableAttributedString(attributedString: userAnswer.attributedText!)

        let text = userAnswer.text! as NSString
        
        
        
        for word in keywords{
            if text.contains(word) {
                countKeyWord+=1
                let smallRange = text.range(of: word)

                attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: smallRange)
            }
        }
        self.userAnswer.attributedText = attributedText
        
        
    }
    
    @IBAction func ShowFullText(_ sender: Any) {
        self.fullTextView.setIsHidden(false, animated: true)
        self.progressConstrant.constant = -150;
        self.instructView.setIsHidden(true, animated: true)
        if(self.answerView != nil){
            self.answerView!.removeFromSuperview()
            createAnswerView()
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if answerText.textColor == UIColor.purple {
            answerText.text = ""
            answerText.textColor = UIColor.black
            }
    }
    func createAnswerView(){
        answerView = Bundle.main.loadNibNamed("ViewAnswerText", owner:
        self, options: nil)?.first as? ViewAnswerText
        self.view.addSubview(answerView!)
        answerView?.translatesAutoresizingMaskIntoConstraints = false
        if(self.fullTextView.isHidden){
            answerView?.topAnchor.constraint(equalTo: self.ButtonView.topAnchor, constant: 200).isActive = true
        }else{
            answerView?.topAnchor.constraint(equalTo: self.fullTextView.topAnchor, constant: 180).isActive = true
        }
    
        answerView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        answerView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        answerView?.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    @IBAction func ViewAnswer(_ sender: Any) {
        if(self.answerView != nil){
            self.answerView!.removeFromSuperview()
            createAnswerView()
        }else{
            createAnswerView()
        }

    }
    
    
    @IBAction func AnalyseTest(_ sender: Any) {
        
        
//sapling.ai/programming-language/swift
        let textPressed = "I walked to the store and I bought milk. I will eat fish for dinner and drank milk. We all eat the fish and then made dessert."
        let json: [String: Any] = [
            "key": "4W9GQMVV0DEYL2E5MTSKP6R7BO2FYRIX",
            "text": textPressed,
            "session_id": "Test Document UUID"
        ]
        
        // figure the number of sentences
        var sentences: [String] = []
        textPressed.enumerateSubstrings(in: textPressed.startIndex..., options: .bySentences) { (string, range, enclosingRamge, stop) in
            sentences.append(string!)
        }
        //print(sentences.count)
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: json)

            let url = URL(string: "https://api.sapling.ai/api/v1/edits")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("\(String(describing: `jsonData`.count))", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            self.loadingView = Bundle.main.loadNibNamed("Loading", owner:
            self, options: nil)?.first as? Loading
            self.loadingView!.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height);
            self.loadingView!.circularPercentView.animate(fromAngle: 0, toAngle: 0, duration: 1, completion: nil)
            self.view.addSubview(self.loadingView!)
            self.view.bringSubviewToFront(self.loadingView!)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                print("URLSession dataTask")
                guard let data = data, error == nil else {
                  print("No data")
                  return;
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: NSArray]
                //let errorSentences:Int =  responseJSON?["edits"]?.count as Any as! Int
                let errorSentences = 2
                let percentGrammar: Int = (errorSentences*100)/sentences.count
                let degreeGrammar: Int = 360*percentGrammar/100
//                print(errorSentences)
//                print(sentences.count)
//                print(percentGrammar)
//                if let responseJSON = responseJSON as? [String: Any] {
//                    print(responseJSON)
//                }
                DispatchQueue.main.async {
                    self.analyseView = self.setupAnalyse()
                    //self.analyseView?.progGrammar.angle = Double(degreeGrammar)
                    self.analyseView?.progGrammar.animate(fromAngle: 0, toAngle: Double(degreeGrammar), duration: 1, completion: nil)
                    self.analyseView?.setTextGrammarDes(text: "fdasf")
                }
                
                    
                    
            }
            
            observation = task.progress.observe(\.fractionCompleted) { progress, _ in
                //print("progress: ", progress.fractionCompleted*100)
                let percentPro = progress.fractionCompleted*100
                let radProg = 360*progress.fractionCompleted
                DispatchQueue.main.async {
                    self.loadingView!.circularPercentView.animate(fromAngle: 0, toAngle: radProg, duration: 1, completion: nil)
                    if(percentPro==100){
                        self.loadingView!.removeFromSuperview()
                    }
                }
            }
            
            // another way
//            import PlaygroundSupport
//
//            let page = PlaygroundPage.current
//            page.needsIndefiniteExecution = true
//
//            let url = URL(string: "https://source.unsplash.com/random/4000x4000")!
//            let task = URLSession.shared.dataTask(with: url) { _, _, _ in
//              page.finishExecution()
//            }
//
//            // Don't forget to invalidate the observation when you don't need it anymore.
//            let observation = task.progress.observe(\.fractionCompleted) { progress, _ in
//              print(progress.fractionCompleted)
//            }
//
//            task.resume()
            
            task.resume()
        }catch{
            print(error)
        }
        
        
    }
    
    func setupAnalyse()->LisSumAnalyse{
        analyseView = Bundle.main.loadNibNamed("LisSumAnalyse", owner:
        self, options: nil)?.first as? LisSumAnalyse
        self.view.addSubview(analyseView!)
        
        let text = userAnswer.text! as NSString
        
        countKeyWord = 0;
        
        for word in keywords{
            if text.contains(word) {
                countKeyWord+=1
            }
        }
        
        let percentContent:Int = countKeyWord*100/keywords.count;
        
        let degreeContent:Int = 360*percentContent/100
        
//        print("count: ", countKeyWord)
//        print("percent: ",percentContent)
//        print(" degree: ",degreeContent)
        
        //analyseView?.progContent.angle = Double(degreeContent)
        analyseView?.progContent.animate(fromAngle: 0, toAngle: Double(degreeContent), duration: 1.5, completion: nil)
        
        analyseView?.translatesAutoresizingMaskIntoConstraints = false
        analyseView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        analyseView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        analyseView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        analyseView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150).isActive = true
        
        return analyseView!
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
            let config = URLSessionConfiguration.background(withIdentifier: UUID().uuidString)
            config.isDiscretionary = true
            config.sessionSendsLaunchEvents = true
            return URLSession(configuration: config, delegate: self, delegateQueue: nil)
        }()
    var messageView = LoadingAudioView()
    var audioName:String!
    var task = URLSessionDownloadTask()
    var audioURl:String!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    func skipSession(){
        print("skip");
        
        
        
        task.cancel()
        urlSession.invalidateAndCancel()
        
        self.messageView.removeFromSuperview()
        //self.navigationController?.popViewController(animated: true)
    }
    func reloadAudio(){
        skipSession()
        //self.messageView.removeFromSuperview()
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
            task.resume()
            print("downloading audio")
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
