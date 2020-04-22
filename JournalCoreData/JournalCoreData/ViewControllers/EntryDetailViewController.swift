//
//  EntryDetailViewController.swift
//  JournalCoreData
//
//  Created by Bhawnish Kumar on 4/21/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry?
     var wasEdited = false
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var journyTitle: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if wasEdited {
            guard let title = journyTitle.text,
                let entry = entry else {
                    return
            }
            let notes = notesTextView.text
            entry.title = title
            entry.bodyText = notes
            let entryPriority = moodSegmentedControl.selectedSegmentIndex
            entry.mood = EntryMood.allCases[entryPriority].rawValue
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        journyTitle.isUserInteractionEnabled = editing
        notesTextView.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        journyTitle.text = entry?.title
        journyTitle.isUserInteractionEnabled = isEditing
        
        notesTextView.text = entry?.bodyText
        notesTextView.isUserInteractionEnabled = isEditing
        
        let mood: EntryMood
        
        if let entryMood = entry?.mood {
            mood = EntryMood(rawValue: entryMood)!
        } else {
            mood = .neutral
        }
        moodSegmentedControl.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: mood) ?? 1
        moodSegmentedControl.isUserInteractionEnabled = isEditing
        //part3
    }


}
