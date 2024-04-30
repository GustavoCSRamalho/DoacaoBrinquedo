//
//  TextFieldPhoneDelegate.swift
//  DoacaoBrinquedo
//
//  Created by Gustavo Ramalho on 29/04/24.
//

import UIKit

final class UITextFieldPhoneDelegate: NSObject, UITextFieldDelegate{
    
    let characterLimit = 11
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = characterLimit
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        if newString.count <= maxLength {
            guard let currentText = textField.text else { return true }
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let formattedText = updatedText.applyPhoneNumberMask()
            textField.text = formattedText
        }
        return false
    }
    
}
