//
//  BrinquedoTableViewCell.swift
//  DoacaoBrinquedo
//
//  Created by Gustavo Ramalho on 27/04/24.
//

import UIKit

class BrinquedoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelGiver: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWith(_ brinquedo: Brinquedo) {
        labelName.text = brinquedo.nome
        labelGiver.text = brinquedo.doador
        labelAddress.text = brinquedo.endereco
        labelPhone.text = brinquedo.telefone.applyPhoneNumberMask()
        labelState.text = getStateName(brinquedo.estado)
    }
    
    private func getStateName(_ state: Int) -> String {
        switch state {
        case 0:
            return "Novo"
        case 1:
            return "Usado"
        case 2:
            return "Precisa de reparos"
        default:
            break
        }
        return ""
    }

}
