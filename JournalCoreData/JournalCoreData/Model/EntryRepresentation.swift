//
//  EntryRepresentation.swift
//  JournalCoreData
//
//  Created by Bhawnish Kumar on 4/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var identifier: UUID
    var title: String
    var bodyText: String?
    var mood: String
    var timeStamp: Date
    
}
