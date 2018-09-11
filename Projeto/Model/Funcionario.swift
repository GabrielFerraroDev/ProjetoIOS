//
//  Funcionario.swift
//  Projeto
//
//  Created by dev on 19/08/2018.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import os.log

class Funcionario: NSObject, NSCoding{
    
    //MARK: Properties
    
    var id : Int
    var nome : String
    var foto : UIImage?
    var RG : String
    var idDepartamento : Int
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("funcionarios")
    
    //MARK: Types
    
    struct PropertyKey {
        static let id = "id"
        static let nome = "nome"
        static let foto = "foto"
        static let RG = "RG"
        static let idDepartamento = "idDepartamento"
    }
    
    //MARK: Initialization
    
    init?(id : Int,nome: String, foto:UIImage?, RG : String, idDepartamento : Int) {
        
        // The name must not be empty
        guard !nome.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.id = id
        self.nome = nome
        self.foto = foto
        self.RG = RG
        self.idDepartamento = idDepartamento
        
    }
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(nome, forKey: PropertyKey.nome)
        aCoder.encode(foto, forKey: PropertyKey.foto)
        aCoder.encode(RG, forKey: PropertyKey.RG)
        aCoder.encode(idDepartamento, forKey:PropertyKey.idDepartamento)
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let nome = aDecoder.decodeObject(forKey: PropertyKey.nome) as? String else {
            os_log("Unable to decode the name for a employee object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        guard let RG = aDecoder.decodeObject(forKey: PropertyKey.RG) as? String else {
            os_log("Unable to decode the RG for a employee object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        let foto = aDecoder.decodeObject(forKey:PropertyKey.foto) as? UIImage
        let idDepartamento = aDecoder.decodeInteger(forKey: PropertyKey.idDepartamento)
        
        // Must call designated initializer.
        self.init(id: id, nome: nome, foto:foto,RG: RG, idDepartamento: idDepartamento)
        
    }
}
