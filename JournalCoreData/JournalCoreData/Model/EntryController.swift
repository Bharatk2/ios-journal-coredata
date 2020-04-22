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
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    var fireBase: FireBaseURL = FireBaseURL()
    
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
}
