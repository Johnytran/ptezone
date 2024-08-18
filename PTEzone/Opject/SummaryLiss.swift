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
    
    func setValue(tmpID:String, tmpTilte:String, tmpAudio:String, tmpAnswer:String){
        self.id = tmpID
        self.title = tmpTilte
        self.audio = tmpAudio
        self.answer = tmpAnswer
    }
}
