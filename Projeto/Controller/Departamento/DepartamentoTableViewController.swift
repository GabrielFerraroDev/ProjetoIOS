//
//  DepartamentoTableViewController.swift
//  Projeto
//
//  Created by dev on 19/08/2018.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import os.log

class DepartamentoTableViewController: UITableViewController {
    
    
    
    
    
    
    //MARK: Properties
    
    var departamentos = [Departamento]()
    
    
    
    //MARK: IBActions
    
    @IBAction func unwindToDepartamentList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let departamento = sourceViewController.departamento {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                departamentos[selectedIndexPath.row] = departamento
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            }else {
                // Add a new Departament.
                let newIndexPath = IndexPath(row: departamentos.count, section: 0)
                
                departamentos.append(departamento)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
                
            }
            // Save the departaments.
            saveDepartaments()
            
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
         navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved departaments
        if let savedDepartaments = loadDepartaments() {
            departamentos += savedDepartaments
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return departamentos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "DepartamentoTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DepartamentoTableViewCell  else {
            fatalError("The dequeued cell is not an instance of DepartamentoTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let departamento = departamentos[indexPath.row]
        
        cell.nomeDep.text = departamento.nome
        
        
        
        return cell
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            departamentos.remove(at: indexPath.row)
            // Save the departaments
            saveDepartaments()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    //MARK: NSCoding
    
    private func saveDepartaments() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(departamentos, toFile: Departamento.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Departament successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save departaments...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadDepartaments() -> [Departamento]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Departamento.ArchiveURL.path) as? [Departamento]
    }
    
    
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
            
        case "AddItem":
            os_log("Adding a new departament.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let ViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDepartamentoCell = sender as? DepartamentoTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDepartamentoCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedDepartamento = departamentos[indexPath.row]
            ViewController.departamento = selectedDepartamento
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            
        }
        
    }
    

}
