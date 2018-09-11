//
//  FuncTableViewController.swift
//  Projeto
//
//  Created by dev on 21/08/2018.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import os.log


class FuncTableViewController: UITableViewController {
    
    
    //MARK: Properties
    var departamento: Departamento?
    var funcionarios = [Funcionario]()
    var selecionados = [Funcionario]()
    //MARK:IBOutlets
    @IBOutlet weak var EditButton: UIBarButtonItem!
    
    
    //MARK:IBActions
    @IBAction func unwindToFuncList(sender: UIStoryboardSegue) {
        
        
        if let sourceViewController = sender.source as? FuncViewController,
            let funcionario = sourceViewController.funcionario {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                funcionarios[selectedIndexPath.row] = funcionario
                selecionados[selectedIndexPath.row] = funcionario
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                
                // Add a new emplyee.
                
                    let newIndexPath = IndexPath(row: funcionarios.count, section: 0)
                
                funcionarios.append(funcionario)
                 let newIndexPathSelecionado = IndexPath(row: selecionados.count, section: 0)
                selecionados.append(funcionario)
                tableView.insertRows(at: [newIndexPathSelecionado], with: .automatic)
                }
                    
            
            
        }
        // Save the employees.
        saveEmployees()
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        // Use the edit button item provided by the table view controller.
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // Load any saved employess
        if let savedEmployees = loadEmplyoyess() {
            funcionarios += savedEmployees
        }
        for f in funcionarios{
            if f.idDepartamento == departamento?.id{
                selecionados.append(f)
            }
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
        return selecionados.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FuncTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FuncTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        
        let funcionario = selecionados[indexPath.row]
        
            
            
            cell.NomeFunc.text = funcionario.nome
            cell.FotoFunc.image = funcionario.foto
            cell.RGFunc.text = funcionario.RG
            
        
            
        
        
        return cell
        
        
        
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            selecionados.remove(at: indexPath.row)
            funcionarios.remove(at: indexPath.row)
            
            // Save the departaments
            saveEmployees()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        
    }
    //MARK: NSCoding
    
    private func saveEmployees() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(funcionarios, toFile: Funcionario.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Employee successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save employees...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadEmplyoyess() -> [Funcionario]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Funcionario.ArchiveURL.path) as? [Funcionario]
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "AddItem" {
            if let dest = segue.destination as? FuncViewController {
                dest.departamento = self.departamento
            }
        }
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            
            os_log("Adding a new employe.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let funcDetailViewController = segue.destination as? FuncViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedFuncCell = sender as? FuncTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedFuncCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedFunc = funcionarios[indexPath.row]
            funcDetailViewController.funcionario = selectedFunc
            if let dest = segue.destination as? FuncViewController {
                dest.departamento = self.departamento
            }
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }    }

}
