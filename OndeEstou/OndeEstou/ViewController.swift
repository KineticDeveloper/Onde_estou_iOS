//
//  ViewController.swift
//  OndeEstou
//
//  Created by Jefferson Oliveira de Araujo on 06/11/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var speedScreen: UILabel!
    @IBOutlet weak var latitudeScreen: UILabel!
    @IBOutlet weak var longitudeScreen: UILabel!
    @IBOutlet weak var addressScreen: UILabel!
    
    var managerLocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerLocation.delegate = self
        managerLocation.desiredAccuracy = kCLLocationAccuracyBest
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
        
    }
    
    //    MARK:  ATUALIZANDO POSIÇÃO EM TEMPO REAL DO USUÁRIO
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationUser = locations.last
        
        let latitudeUp = locationUser?.coordinate.latitude
        let longitudeUp = locationUser?.coordinate.longitude
        
        self.latitudeScreen.text = String(latitudeUp!)
        self.longitudeScreen.text = String(longitudeUp!)
        
        if locationUser!.speed > 0 {
            self.speedScreen.text = String(locationUser!.speed)
        }
        
        let locationDisplay: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeUp!, longitudeUp!)
        
        let deltaLatLong: CLLocationDegrees = 0.002
        let areaDisplay = MKCoordinateSpan(latitudeDelta: deltaLatLong, longitudeDelta: deltaLatLong)
        
        let region = MKCoordinateRegion(center: locationDisplay, span: areaDisplay)
        
        mapa.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(locationUser!) { (detailsLocal, error) in
            if error == nil {
                if let localData = detailsLocal?.first {
                    
                    var streetAddress = ""
                    if localData.thoroughfare != nil {
                        streetAddress = (localData.thoroughfare)!
                    }
                    
                    var numberAddress = ""
                    if localData.subThoroughfare != nil {
                        numberAddress = (localData.subThoroughfare)!
                    }
                    
                    var cityAddress = ""
                    if localData.locality != nil {
                        cityAddress = (localData.locality)!
                    }
                    
                    var districtAddress = ""
                    if localData.subLocality != nil {
                        districtAddress = (localData.subLocality)!
                    }
                    
                    var postalCode = ""
                    if localData.postalCode != nil {
                        postalCode = (localData.postalCode)!
                    }
                    
                    var country = ""
                    if localData.country != nil {
                        country = (localData.country)!
                    }
                    
                    var stateAddress = ""
                    if localData.administrativeArea != nil {
                        stateAddress = (localData.administrativeArea)!
                    }
                    
                    var subAdministrativeArea = ""
                    if localData.subAdministrativeArea != nil {
                        subAdministrativeArea = (localData.subAdministrativeArea)!
                    }
                    
                    self.addressScreen.text = streetAddress + ", " + numberAddress + " - " + districtAddress + " - " + stateAddress + " / " + country
                    
                }
            } else {
                print(error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let alertControl = UIAlertController(title: "Permissão de localização", message: "Necessário permissão para acesso á sua localização.", preferredStyle: .alert)
            
            let actionConfig = UIAlertAction(title: "Abrir configurações", style: .default) { (alertConfig) in
                if let config = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open( config as URL )
                }
            }
            let actionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertControl.addAction(actionConfig)
            alertControl.addAction(actionCancel)
            
            present(alertControl, animated: true, completion: nil)
        }
    }
    
    
}

