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
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
