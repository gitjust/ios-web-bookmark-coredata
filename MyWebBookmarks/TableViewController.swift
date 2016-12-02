//
//  TableViewController.swift
//  MyWebBookmarks
//
//  Created by Justinus Andjarwirawan on 11/25/16.
//  Copyright © 2016 Petra Christian University. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var urls:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
        do {
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Links")
            let results = try context.fetch(request)
            for url in results as! [NSManagedObject] {
                let name = url.value(forKey: "url")
                urls.append(name as! String)
            }
            
        } catch {
            print("error")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
        let theURL = urls[indexPath.row]
        cell.textLabel?.text = theURL

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /* Tadinya slide-to-delete ada disini, pindah ke editActionsForRowAt
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            
//
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
    */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let alertController = UIAlertController(title: "Edit URL", message: "Modify and confirm:", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                if let field = alertController.textFields?[0] {
                    // edit and store your data
                    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
                    do {
                        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Links")
                        let results = try context.fetch(request)
                        for url in results as! [NSManagedObject] {
                            let name = url.value(forKey: "url")
                            if name as! String == self.urls[indexPath.row] {
                                url.setValue(field.text!, forKey: "url")
                                do {
                                    try context.save()
                                    // update tampilan:
                                    self.urls[indexPath.row] = field.text!
                                    self.tableView.reloadData()
                                } catch {
                                    print("ada error")
                                }
                            }
                        }
                    } catch {
                        print("error")
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alertController.addTextField { (textField) in
//                textField.placeholder = "URL"
                textField.text = self.urls[indexPath.row]
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)

        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.persistentContainer.viewContext
            do {
                let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Links")
                let results = try context.fetch(request)
                for url in results as! [NSManagedObject] {
                    let name = url.value(forKey: "url")
                    if name as! String == self.urls[indexPath.row] {
                        context.delete(url)
                        do {
                            try context.save()
                        } catch {
                            print("ada error")
                        }
                    }
                }
            } catch {
                print("error")
            }
            // hapus di UI setelah hapus di CoreData! bila tidak index bisa kacau
            self.urls.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
        edit.backgroundColor = UIColor.blue
        
        return [edit, delete]
    }

    var selected: String?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = urls[indexPath.row]
        performSegue(withIdentifier: "toWebView", sender: self)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            let a = segue.destination as! WebViewController
            a.theURL = selected
        }
    }
    
}
