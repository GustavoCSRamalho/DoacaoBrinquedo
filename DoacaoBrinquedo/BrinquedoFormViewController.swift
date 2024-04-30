//
//  BrinquedoFormViewController.swift
//  DoacaoBrinquedo
//
//  Created by Gustavo Ramalho on 27/04/24.
//

import UIKit
import FirebaseFirestore

class BrinquedoFormViewController: UIViewController {
    
    let collection = "brinquedosList"
    let maxNumberPhone = 11

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldState: UISegmentedControl!
    @IBOutlet weak var textFieldGiver: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var buttonAddEdit: UIButton!
    
    private let textFieldPhoneDelegate = UITextFieldPhoneDelegate()
    
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    var brinquedo: Brinquedo?
    
    fileprivate func setDelegate() {
        textFieldPhone.delegate = textFieldPhoneDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        if let brinquedo = brinquedo {
            title = "Edicao"
            textFieldName.text = brinquedo.nome
            textFieldGiver.text = brinquedo.doador
            textFieldAddress.text = brinquedo.endereco
            textFieldPhone.text = brinquedo.telefone
            buttonAddEdit.setTitle("Alterar", for: .normal )
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let nome = textFieldName.text, let doador = textFieldGiver.text, let endereco = textFieldAddress.text, let telefone = textFieldPhone.text else {
            return
        }
        
        let data: [String: Any] = [
            "nome": nome,
            "doador": doador,
            "endereco": endereco,
            "telefone": telefone.removePhoneNumberMask(),
            "estado": textFieldState.selectedSegmentIndex,
        ]
        
        
        if textFieldPhone.text?.removePhoneNumberMask().count == maxNumberPhone {
            if let brinquedo = brinquedo {
                self.firestore.collection(self.collection).document(brinquedo.id).updateData(data)
            } else {
                self.firestore.collection(self.collection).addDocument(data: data)
            }
            navigationController?.popViewController(animated: true)
        }
    }
}

extension BrinquedoFormViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 11
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}
