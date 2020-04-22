//
//  Entry+Convenience.swift
//  JournalCoreData
//
//  Created by Bhawnish Kumar on 4/20/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
       case sad = "🙁"
     case neutral = "😐"
     case happy = "🙂"
}
extension Entry {
    
    
    

    convenience init(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
                           self.init(context: context)
        self.identifier = entryRepresentation.identifier
        self.title = entryRepresentation.title
        self.bodyText = entryRepresentation.bodyText
        self.timeStamp = entryRepresentation.timeStamp
        self.mood = entryRepresentation.mood
                       }
               
    

           
           
    @discardableResult convenience init(identifier: UUID = UUID(),
                     title: String,
                     bodyText: String?,
                     timeStamp: Date,
                     mood: EntryMood = .neutral,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.bodyText = bodyText
        self.timeStamp = timeStamp
        self.mood = mood.rawValue
    }
    
}
