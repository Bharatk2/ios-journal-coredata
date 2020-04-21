//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Bhawnish Kumar on 4/21/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

class EntryController {
    
    func saveToPersistentStore() {
        
        do {
            try CoreDataStack.shared.mainContext.save() // has to see with books array.
            
        } catch {
            NSLog("error saving managed obejct context: \(error)")
        }
    }

    
    func createEntry(identifier: UUID, title: String, bodyText: String, timeStamp: Date, mood: EntryMood = .sad) -> Entry {
         
        let newEntry = Entry(identifier: UUID(), title: title, bodyText: bodyText, timeStamp: timeStamp, mood: mood, context: CoreDataStack.shared.mainContext)
         return newEntry
     }
     
     func updateEntry(entryTitle: String, bodyText: String, entry: Entry, mood: String) {
         entry.title = entryTitle
         entry.bodyText = bodyText
         entry.timeStamp = Date()
         entry.mood = mood
         saveToPersistentStore()
        
     }
     
     func deleteEntry(entry: Entry) {
         CoreDataStack.shared.mainContext.delete(entry)
         saveToPersistentStore()
     }
}
