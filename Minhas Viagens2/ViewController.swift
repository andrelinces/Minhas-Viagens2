//
//  ViewController.swift
//  Minhas Viagens2
//
//  Created by Andre Linces on 12/09/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    //instanciando objeto gerenciadorLocalizacao para atualizar a localização do mapa
    var gerenciadorLocalizacao = CLLocationManager()
    var viagem:  Dictionary<String, String> = [:]
    var indiceSelecionado: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        //teste para verificar o índice clicado da tableview, para diferenciar do clique no adicionar.
        //print( indiceSelecionado )
        
        if let indice = indiceSelecionado{
            
            if indice == -1 {//Adicionando nova localização
                
                configuraGerenciadorLocalizacao()
                
            }else{//Lista localização salva.
                
                exibirAnotacao(  viagem: viagem)
                
            }
            
        }
        
        
        //Reconhecendo o toque pressionado do usuário na tela.
        let reconhecedorGesto = UILongPressGestureRecognizer(target: self, action: #selector( ViewController.marcar(gesture:) ))
        reconhecedorGesto.minimumPressDuration = 2
        
        mapa.addGestureRecognizer( reconhecedorGesto )
        
    }
    //Exibe o localização do usuário atualizada
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let local = locations.last!
        
        //Exibe o local salvo na tableview.
        
        let localizacao = CLLocationCoordinate2DMake(local.coordinate.latitude,  local.coordinate.longitude)
        
        let areaVisualizacao = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao, span: areaVisualizacao)
        
        self.mapa.setRegion(regiao, animated: true)
        
    }
    
    func exibirLocal( latitude: Double, longitude: Double ){
        
        let localizacao = CLLocationCoordinate2DMake(latitude, longitude)
        
        let areaVisualizacao = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao, span: areaVisualizacao)
        
        self.mapa.setRegion(regiao, animated: true)
        
    }
    
    //Exibe a anotacao com dados do endereço
    func exibirAnotacao( viagem: Dictionary<String, String> ){
        
        //testa se o item salvo tem o local, latitude e longitude recuperados
        
        if let localViagem = viagem ["local"]{
            
            if let latitudeS = viagem ["latitude"]{
                
                if let longitudeS = viagem ["longitude"]{
                    
                    if let latitude = Double (latitudeS){
                        
                        if let longitude = Double (longitudeS){
                            
                            //Exibe a anotação
                            let anotacao = MKPointAnnotation()
                            anotacao.coordinate.latitude = latitude
                            anotacao.coordinate.longitude = longitude
                            anotacao.title = localViagem
                            //anotacao.subtitle = "Estive aqui"
                            
                            self.mapa.addAnnotation(anotacao)
                            
                            //Exibe o local salvo na tableview.
                            
                            exibirLocal(latitude: latitude, longitude: longitude)
                             
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
    @objc func marcar ( gesture: UIGestureRecognizer ){
        //Tratando o toque na tela para capturar apenas uma marcação.
        if gesture.state == UIGestureRecognizer.State.began{
            //Print, teste para verificar no log se a função está ok.
            //print("Pressionado!")
            
            //Recuperar o ponto selecionando no mapa
            let pontoSelecionado = gesture.location(in: self.mapa)
            //Precisa converter o ponto marcado em coordenadas, utilizando o próprio mapa para obter as coordenadas.
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            
            //Constante criada do tipo Cllocation para utiliza-la na classe CLGeocoder.
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            //Recupera o endereço do ponto selecionado
            var localCompleto = "Endereço não encontrado!"
            CLGeocoder().reverseGeocodeLocation(localizacao) { (local, erro) in
                
                if erro == nil {
                    
                    if let dadosLocal = local?.first {
                        
                        if let nome = dadosLocal.name{
                            
                            localCompleto = nome
                            //print(nome)
                            
                        }else{
                            
                            if let endereco = dadosLocal.thoroughfare{
                            localCompleto = endereco
                                //print("Endereco : \(endereco)")
                            }
                            
                        }
                        
                    }
                    
                    //Salvar dados no dispositivo
                    
                    self.viagem = ["local": localCompleto, "latitude": String(coordenadas.latitude) , "longitude": String(coordenadas.longitude)]
                    ArmazenamentoDados().salvar(viagem: self.viagem)
                    
                    //testando com print se os dados estão sendo salvos e listados corretamente.
                    //print( ArmazenamentoDados().listarViagem() )
                    
                    //Agora que já possui as coordenadas, vamos exibir o pontoSelecionado.
                    
                    //Exibe a anotação com dados do endereço
                    
                    self.exibirAnotacao(viagem: self.viagem )
                    
                }else{
                    
                    print(erro)
                    //failed for NSLocaleCountryCode@ se ocorrer este erro alterar o endereço do simulador, settings, general, language -> swedem
                }
                
            }
            
            //Agora que já possui as coordenadas, vamos exibir o pontoSelecionado.
            /*
            //Exibe a anotação com dados do endereço
            let anotacao = MKPointAnnotation()
            anotacao.coordinate.latitude = coordenadas.latitude
            anotacao.coordinate.longitude = coordenadas.longitude
            anotacao.title = "Teste pressionei aqui"
            //anotacao.subtitle = "Estive aqui"
            
            self.mapa.addAnnotation(anotacao)
            */
            
        }
    
    }

    func configuraGerenciadorLocalizacao() {
        
        //Objeto gerenciadorLocalização será gerenciado pela classe ViewController
        gerenciadorLocalizacao.delegate = self
        //Selecionando a melhor localicalização para o objeto
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        //Solicitando permissão para o usuário
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        //Depois de autorizado, atualizando a localização do usuário.
        gerenciadorLocalizacao.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            
            let alertController = UIAlertController(title: "Permissão de Localização!",
                                                    message: "Necessário permitir acesso a sua localização, para funcionar o App! Favor habilite o acesso!",
                                                    preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir Configurações?", style: .default) { alertaConfiguracoes in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString){
                    
                    UIApplication.shared.open(configuracoes as URL)
                }
                
            }
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
            
        }
           
    }

}

