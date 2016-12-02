//
//  ViewController.swift
//  MyWebBookmarks
//
//  Created by Justinus Andjarwirawan on 11/25/16.
//  Copyright © 2016 Petra Christian University. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBAction func openBookmark(_ sender: UIButton) {
        performSegue(withIdentifier: "toTable", sender: self)
    }
    
    @IBOutlet weak var newLink: UITextField!
    @IBAction func addButton(_ sender: UIButton) {
        if (newLink.text != "" && checkData()) {
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Links", in: context)
            let transc = NSManagedObject(entity: entity!, insertInto: context)
            transc.setValue(newLink.text, forKey: "url")
            do {
                try context.save()
            } catch {
                print("ada error")
            }
            performSegue(withIdentifier: "toTable", sender: self)
        }
    }
    
    func checkData() -> Bool {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        do {
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Links")
            let results = try context.fetch(request)
            for url in results as! [NSManagedObject] {
                let name = url.value(forKey: "url")
                if name as! String == self.newLink.text! {
                    // sudah ada!
                    let alertController = UIAlertController(title: "Data Exists", message: "already in database", preferredStyle: .alert)
                    
                    let confirmAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                            // do nothing
                    }
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                    return false
                }
            }
        } catch {
            print("error")
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

