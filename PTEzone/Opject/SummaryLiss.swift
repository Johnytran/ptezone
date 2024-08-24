//
//  SummaryLiss.swift
//  PTEzone
//
//  Created by Tuan Anh on 18/8/2024.
//

import Foundation

class SummaryLiss{
    private var id:String = ""
    private var title:String = ""
    private var audio: String = ""
    private var answer: String = ""
    private var url: String = ""
    
    func setValue(tmpID:String, tmpTilte:String, tmpAudio:String, tmpAnswer:String, tmpUrl:String){
        self.id = tmpID
        self.title = tmpTilte
        self.audio = tmpAudio
        self.answer = tmpAnswer
        self.url = tmpUrl
    }
    func getID()->String{
        return self.id
    }
    func getTitle()->String{
        return self.title
    }
    func getAudio()->String{
        return self.audio
    }
    func getAnswer()->String{
        return self.answer
    }
    func getUrl()->String{
        return self.url
    }
}
