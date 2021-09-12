//
//  LocaisViagemViewController.swift
//  Minhas Viagens2
//
//  Created by Andre Linces on 12/09/21.
//

import UIKit
//Classe responsável por organizar os locais salvos do mapa na tableview.
class LocaisViagemViewController: UITableViewController {
    
    var locaisViagens: [ Dictionary<String, String> ] = []
    var controleNavegacao = "adicionar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locaisViagens = ArmazenamentoDados().listarViagem()
        
    }
    //Método para atualizar em tempo real a tableview
    override func viewDidAppear(_ animated: Bool) {
        controleNavegacao = "adicionar"
        atualizaViagens()
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
        let viagem = locaisViagens [ indexPath.row ]["local"]
        //montando a célula
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        
        //configura o valor dentro da célula
        celula.textLabel?.text = viagem
        
        
        return celula
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            ArmazenamentoDados().removerViagem( indice: indexPath.row )
            atualizaViagens()
            
        }
        
    }
    //Método para verificar se a célula da tableview foi clicada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //objeto para identificar quando o usuário clicar na célula ou no adicionar.
        self.controleNavegacao = "listar"
        
        //teste para verificar se o método está correto
        //print( indexPath.row )
        //Método utilizado para através da célula selecionada utilizar a segue e ir para o mapa.
        performSegue(withIdentifier: "verLocal", sender: indexPath.row )
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verLocal" {
            
            let viewControllerDestino = segue.destination as! ViewController
            
            //Testa se o usuário clicou em alguma célula da tableview
            if self.controleNavegacao == "listar"{
                
                if let indiceRecuperado = sender {
                    
                    let indice =  indiceRecuperado as! Int
                    viewControllerDestino.viagem = locaisViagens [ indice ]
                    viewControllerDestino.indiceSelecionado = indice
                    
                }
                
            }else{//então usuário clicou para adicionar nova localização no mapa.
                
                viewControllerDestino.viagem = [:]
                viewControllerDestino.indiceSelecionado = -1
                
            }
            
        }
        
    }
    
    func atualizaViagens(){
        
        locaisViagens = ArmazenamentoDados().listarViagem()
        tableView.reloadData()
        
    }

}
