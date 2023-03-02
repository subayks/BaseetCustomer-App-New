//
//  AddNoteVCVM.swift
//  Baseet App
//
//  Created by Subendran on 16/09/22.
//

import Foundation

class AddNoteVCVM {
    var notes: String?
    var voiceRecord: String?
    
   convenience init(notes: String, voiceRecord: String) {
       self.init()
        self.notes = notes
        self.voiceRecord = voiceRecord
    }
    
    init() {
        
    }
}
