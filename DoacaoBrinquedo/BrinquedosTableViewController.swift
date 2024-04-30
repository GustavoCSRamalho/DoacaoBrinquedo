//
//  BrinquedosTableViewController.swift
//  DoacaoBrinquedo
//
//  Created by Gustavo Ramalho on 27/04/24.
//

import UIKit
import FirebaseFirestore

class BrinquedosTableViewController: UITableViewController {

    let collection = "brinquedosList"
    var brinquedoList: [Brinquedo] = []
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBrinquedoList()
    }
    
    func loadBrinquedoList() {
        listener = firestore.collection(collection).order(by: "nome", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
            if let error = error {
                print(error)
            } else {
                guard let snapshot = snapshot else {return}
                print("Total de documentos alterados: \(snapshot.documentChanges.count)")
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0{
                    self.showItemsFrom(snapshot)
                }
            }
        })
    }
    
    func showItemsFrom(_ snapshot: QuerySnapshot) {
        brinquedoList.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let name  = data["nome"] as? String, let address = data["endereco"] as? String,  let giver = data["doador"] as? String,  let phone = data["telefone"] as? String,  let state = data["estado"] as? Int {
                let brinquedo = Brinquedo(nome: name, doador: giver,estado: state, endereco: address, telefone: phone, id: document.documentID)
                brinquedoList.append(brinquedo)
            }
        }
        tableView.reloadData()
    }
        
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brinquedoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BrinquedoTableViewCell else {
            return UITableViewCell()
        }
        let brinquedo = brinquedoList[indexPath.row]
        cell.configureWith(brinquedo)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brinquedo = brinquedoList[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let brinquedo = brinquedoList[indexPath.row]
            firestore.collection(collection).document(brinquedo.id).delete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let brinquedoFormViewController = segue.destination as? BrinquedoFormViewController, let indexPath = tableView.indexPathForSelectedRow {
            let brinquedo = brinquedoList[indexPath.row]

            brinquedoFormViewController.brinquedo = brinquedo
        }
    }
}
