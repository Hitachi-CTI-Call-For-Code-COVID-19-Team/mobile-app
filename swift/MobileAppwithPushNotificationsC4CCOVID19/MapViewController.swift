//
//  MapViewController.swift
//  MobileAppwithPushNotificationsC4CCOVID19
//
//  Created by Watanabe Kentaro on 2020/07/22.
//  Copyright © 2020 IBM. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitude = 35.681236
        let longitude = 139.767125
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.setCenter(location, animated:true)
        
        var region = mapView.region
        region .center = location
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region, animated: true)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
