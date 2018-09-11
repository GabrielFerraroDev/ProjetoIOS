//
//  Departamento.swift
//  Projeto
//
//  Created by dev on 19/08/2018.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import os.log


class Departamento: NSObject, NSCoding{
    
    //MARK: Properties
    var id : Int
    var nome : String
    var sigla : String
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("departamentos")
    
    //MARK: Types
    
    struct PropertyKey {
        static let id = "id"
        static let nome = "nome"
        static let sigla = "sigla"
    }
    //MARK: Initialization
  
    
    init?(id : Int, nome: String, sigla :String) {
        
        // The name must not be empty
        guard !nome.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.id = id
        self.nome = nome
        self.sigla = sigla
        
   
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(nome, forKey: PropertyKey.nome)
        aCoder.encode(sigla, forKey: PropertyKey.sigla)
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let nome = aDecoder.decodeObject(forKey: PropertyKey.nome) as? String else {
            os_log("Unable to decode the name for a Departamento object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        guard let sigla = aDecoder.decodeObject(forKey: PropertyKey.sigla) as? String else {
            os_log("Unable to decode the initials for a Departamento object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        
        // Must call designated initializer.
        self.init(id: id, nome: nome, sigla: sigla)
        
    }
    
   
    
    
    
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    

