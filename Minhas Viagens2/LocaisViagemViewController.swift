//
//  LocaisViagemViewController.swift
//  Minhas Viagens2
//
//  Created by Andre Linces on 12/09/21.
//

import UIKit
//Classe responsável por organizar os locais salvos do mapa na tableview.
class LocaisViagemViewController: UITableViewController {
    
    var locaisViagens: [String] = ["Coliseu", "Torre Eifell", "Cristo Redentor"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //Define a quantidade de seções da tabela
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Define a quantidade de linhas dentro da tabela
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locaisViagens.count
        
    }
    
    //Método responsável por montar e exibir a célula
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //recuperando índice do array
        let viagem = locaisViagens [ indexPath.row ]
        //montando a célula
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        //configura o valor dentro da célula
        celula.textLabel?.text = viagem
        
        
        return celula
        
    }

}
