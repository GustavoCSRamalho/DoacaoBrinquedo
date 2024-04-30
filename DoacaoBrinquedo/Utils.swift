//
//  Utils.swift
//  DoacaoBrinquedo
//
//  Created by Gustavo Ramalho on 29/04/24.
//

import Foundation

extension String{
    func applyPhoneNumberMask() -> String {
        // Define o padrão de expressão regular para a máscara de telefone
        let pattern = #"(\d{2})(\d{5})(\d{4})"#
        
        // Cria uma expressão regular a partir do padrão
        let regex = try! NSRegularExpression(pattern: pattern)
        
        // Aplica a máscara ao número de telefone
        let maskedPhoneNumber = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "($1) $2-$3")
        
        return maskedPhoneNumber
    }
    
    func removePhoneNumberMask() -> String {
        // Define o padrão de expressão regular para encontrar os dígitos do telefone
        let pattern = #"[^\d]"#

        // Cria uma expressão regular a partir do padrão
        let regex = try! NSRegularExpression(pattern: pattern)
        
        // Remove todos os caracteres que não sejam dígitos
        let digitsOnly = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "")
        
        return digitsOnly
    }
}
