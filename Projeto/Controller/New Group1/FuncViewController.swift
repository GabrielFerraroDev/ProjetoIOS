//
//  FuncViewController.swift
//  Projeto
//
//  Created by dev on 21/08/2018.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import os.log

class FuncViewController: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: proprieties
    @IBOutlet weak var NomeFunc:UITextField!
    @IBOutlet weak var FotoFunc: UIImageView!
    @IBOutlet weak var RGFunc: UITextField!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    
    
    
    var IdDepartamentoFunc  : Int = 0
    var IdFunc : Int = 1
    
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var funcionario: Funcionario?
    var departamento : Departamento?
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        NomeFunc.delegate = self
        RGFunc.delegate = self
         let idFun = defaults.integer(forKey: "id")
        if idFun == 0 {
            defaults.set(IdFunc, forKey:"id")
        }
            
        
        
        // Set up views if editing an existing Meal.
        if let funcionario = funcionario {
            navigationItem.title = funcionario.nome
            NomeFunc.text  = funcionario.nome
            FotoFunc.image = funcionario.foto
            RGFunc.text = funcionario.RG
            
            
            
        }
        
       
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        navigationItem.title = NomeFunc.text
        updateSaveButtonState()
        
        
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        FotoFunc.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddFuncMode = presentingViewController is UINavigationController
        
        if isPresentingInAddFuncMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
        
    }
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        
            guard let button = sender as? UIBarButtonItem, button === SaveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
            }
        
        
        
            let nome = NomeFunc.text ?? ""
            let foto = FotoFunc.image
            let RG = RGFunc.text ?? ""
        
        
        
            let idDepFunc = self.departamento?.id
        let idFun2 = defaults.integer(forKey: "id")
        
            
        
        
            
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
        funcionario = Funcionario( id:(idFun2),nome: nome, foto: foto, RG: RG, idDepartamento: idDepFunc!)
        defaults.set((idFun2+1), forKey: "id")
            
        
            
        
        
    }
    
    
    //MARK: Actions
    
    
    @IBAction func SelecionaIMG(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        NomeFunc.resignFirstResponder()
        RGFunc.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    

    
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = NomeFunc.text ?? ""
        SaveButton.isEnabled = !text.isEmpty
        
    
    
}
}
