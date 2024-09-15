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
import NaturalLanguage
//import Pluralize_swift

class LisDetailSST: UIViewController, URLSessionDownloadDelegate, UITextViewDelegate{
    
    
    
    @IBOutlet weak var userAnswer: UITextView!
    @IBOutlet weak var progressConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var instructView: CornerGradientView!
    
    @IBOutlet weak var ButtonView: CornerGradientView!
    @IBOutlet weak var fullTextInput: UITextView!
    @IBOutlet weak var fullTextView: CornerGradientView!
    @IBOutlet weak var btnButtonPlay: UIButton!
    private var answerView:ViewAnswerText? = nil
    private var analyseView:LisSumAnalyse? = nil
    private var loadingView:Loading? = nil
    private var keywords = [String]()
    private var countKeyWord: Int = 0
    private var observation: NSKeyValueObservation?
    public var objSummaryLiss:SummaryLiss?
    deinit {
        observation?.invalidate()
      }
    
    override func viewDidDisappear(_ animated: Bool) {
        player!.pause();
    }
    
    @IBOutlet weak var answerText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.objSummaryLiss?.getUrl());
        
        self.audioName = self.objSummaryLiss?.getAudio()
        self.audioURl = self.objSummaryLiss?.getUrl()
        self.fullTextInput.text = self.objSummaryLiss?.getAnswer()
        download(url: self.audioURl)
        
        answerText.delegate = self
        answerText.text = "Type your answer here."
        answerText.textColor = UIColor.purple
        self.keywords = ["pandemic","catastrophic","unprecedented","preparation","affects", "public health", "treatment", "prevention"]
        
    }
    func grammarCheck(text:String){
        
        if(text.isEmpty){
            return
        } else {
            let sentences = getAllSentences(content: text)
            for sent in sentences{
                let subj = getSubject(sentence: sent)
                print(subj)
            }
        }
    }
    func getSubject(sentence: String) -> String{
        if(sentence.isEmpty){
            return ""
        } else {
            let verb = getVerbs(from: sentence)
            if(verb.isEmpty){
                return ""
            }else{
                let tagSente = sentence.components(separatedBy: verb[0])
                return tagSente[0]
            }
        }
    }
    func getAllSentences(content: String)->[String]{
        let arrSentent = content.components(separatedBy: ".")
        return arrSentent
    }
    func tags(for text: String, tagScheme: NLTagScheme) -> [(word: String, tag: NLTag)] {
        var taggedWords: [(String, NLTag)] = []

        let tagger = NLTagger(tagSchemes: [tagScheme])
        tagger.string = text
        tagger.enumerateTags(in: text.startIndex..<text.endIndex,
                                unit: .word,
                                scheme: tagScheme,
                                options: [.omitPunctuation, .omitWhitespace]) { tag, tokenRange in
            if let tag = tag {
                taggedWords.append((String(text[tokenRange]), tag))
            }
            return true
        }
        return taggedWords
    }
    func getVerbs(from text: String) -> [String] {
        let tags = tags(for: text, tagScheme: .lexicalClass)
        return tags.filter { $0.tag == .verb }.map { $0.word }
    }
    
    @IBAction func PlayAudio(_ sender: Any) {
        if((player) != nil){
            if(player.isPlaying){
                player!.pause()
                btnButtonPlay.setImage(UIImage(named: "play.png"), for: .normal)
            }else{
                player!.play()
                btnButtonPlay.setImage(UIImage(named: "pause.png"), for: .normal)
            }
            
        }else{
            
            download(url: self.audioURl)
        }
    }
    @IBAction func SubmitTest(_ sender: Any) {
        
        
        
        
        
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
        answerView?.contentTextView.text = self.userAnswer.text
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
        
        let tmpTextView:UITextView = (answerView?.contentTextView)!
        
        let attributedText = NSMutableAttributedString(attributedString: tmpTextView.attributedText!)

        let text = userAnswer.text! as NSString
        
        
        
        for word in keywords{
            if text.contains(word) {
                countKeyWord+=1
                let smallRange = text.range(of: word)

                attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: smallRange)
            }
        }
        tmpTextView.attributedText = attributedText
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
        
        grammarCheck(text: answerText.text)
//        analyseView = Bundle.main.loadNibNamed("LisSumAnalyse", owner:
//        self, options: nil)?.first as? LisSumAnalyse
//        self.view.addSubview(analyseView!)
//
//        analyseView?.translatesAutoresizingMaskIntoConstraints = false
//        analyseView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
//        analyseView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
//        analyseView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
//        analyseView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150).isActive = true
        
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
