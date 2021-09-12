//
//  ArmazenamentoDados.swift
//  Minhas Viagens2
//
//  Created by Andre Linces on 12/09/21.
//

import UIKit

//Classe responsável por salvar, lista e remover os itens selecionados.
class ArmazenamentoDados {
    
    let chaveArmazenamento = "locaisViagens"
    var viagens: [ Dictionary<String, String> ] = []
    
    //Método criado para retornar o UserDefaults.Standard, pois vamos utiliza-lo mais vezes.
    func getDefaults() -> UserDefaults{
        return UserDefaults.standard
    }
    
    func salvar( viagem: Dictionary<String, String>  ){
        //Parâmetro para não sobrescrever os itens salvos da tableview.
        viagens = listarViagem()
        
        viagens.append( viagem )
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        //Sincronizando os dados após cada ponto salvo no mapa.
        getDefaults().synchronize()
        
    }
    
    func listarViagem() -> [Dictionary<String, String>] {
        
        let dados = getDefaults().object(forKey: chaveArmazenamento)
        if dados != nil {
            
            return dados as! Array
            
        }else{
            return []
        }
        
    }
    
    func removerViagem( indice: Int ){
        
        viagens = listarViagem()
        viagens.remove(at: indice)
        
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        //Sincronizando os dados após cada ponto salvo no mapa.
        getDefaults().synchronize()
        
    }
    
}
