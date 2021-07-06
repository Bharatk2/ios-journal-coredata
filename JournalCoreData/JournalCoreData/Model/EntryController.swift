//
//  EntryController.swift
//  JournalCoreData
//
//  Created by Bhawnish Kumar on 4/21/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.


import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier, otherError, noData, noDecode, noEncode, noRep
}
enum HTTPMethod: String {
    case put = "PUT"
    case delete = "DELETE"
}

class EntryController {
    
    init() {
        fetchEntryFromServer()
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    var fireBase: FireBaseURL = FireBaseURL()
    
    func fetchEntryFromServer(completion: @escaping CompletionHandler = {_ in}) {
        let requestURL = fireBase.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                NSLog("Unable to fetch entry: \(error)")
                completion(.failure(.otherError))
                return
            }
            guard let data = data else {
                NSLog("No data to return from fetch")
                completion(.failure(.noData))
                return
            }
            do {
                let entryRepresentation = Array(try JSONDecoder().decode([String : EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentation)
                completion(.success(true))
            } catch {
                NSLog("Error decoding tasks from server: \(error)")
            }
        }.resume()
    }
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = fireBase.baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("Error encoding \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error in getting data: \(error)")
                completion(.failure(.noData))
            }
            
            //            MARK: - Data handeling
            
            
            
            
            //            MARK: - Response handeling
            
            
            completion(.success(true))
        }.resume()
        
    }
    
    func deleteEntryFromServe(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = fireBase.baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error in getting data: \(error)")
                completion(.failure(.noData))
            }
            
            //            MARK: - Data handling
            
            
            
            
            //            MARK: - Response handling
            
            
            completion(.success(true))
        }.resume()
    }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timeStamp = representation.timeStamp
        entry.mood = representation.mood
    }
    
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier) }
        let representationByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entryToCreate = representationByID
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            
        do {
            let existingEntries = try context.fetch(fetchRequest)
                       
                       for entry in existingEntries {
                           guard let id = entry.identifier,
                               let representation = representationByID[id] else { continue }
                           self.update(entry: entry, with: representation)
                        entryToCreate.removeValue(forKey: id)
                       }
            for representation in entryToCreate.values {
                Entry(entryRepresentation: representation, context: context)
            }
           try context.save()
        } catch {
           NSLog("Error fetching entry with uUIDs: \(identifiersToFetch), with error: \(error)")
        }
        }
    }
}
