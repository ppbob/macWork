//
//  HomeViewController.swift
//  MyLocationDemo
//
//  Created by Praveen Babu Puram on 29/10/17.
//  Copyright © 2017 Praveen Babu Puram. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

   // @IBOutlet weak var sendSMSViewLayer: UIView!
    @IBOutlet weak var sendSMSBtn: UIButton!
    let locationManager = CLLocationManager()
    
    @IBAction func onTouchSendSMS(_ sender: Any) {
        print("Am I invoked???")
        captureLocation(person: "test")
    }
    
    func captureLocation(person: String) {
        print("Hello, \(person)!")
        // For use when the app is open & in the background
        locationManager.requestAlwaysAuthorization()
        
        // For use when the app is open
        //locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            //locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }

    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            //Send location data to UI
           //self.lat.text = location.coordinate.latitude.description
            //self.lng.text = location.coordinate.longitude.description
            
            //Below code is to build address from the GPS Location
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
                if let error = e {
                    print("Error:  \(e?.localizedDescription)")
                } else {
                    let placemark = placemarks?.last as! CLPlacemark
                    
                    let userInfo = [
                        "city":     placemark.locality,
                        "state":    placemark.administrativeArea,
                        "country":  placemark.country
                    ]
                   // print("Location:  \(userInfo)")
                    //self.address.text = placemark.locality! + ",\n" + placemark.administrativeArea! + ",\n" + placemark.country!
                }
            })
            
            let lng = location.coordinate.longitude
            let lat = location.coordinate.latitude
            let message = "\"Location(long,lat)" + String(describing: lng) + "," + String(describing: lat) + "\""
            sendMessage(messageContent: message)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func sendMessage(messageContent: String) {
        print("Message Content: , \(messageContent)!")
        let urlToRequest = "http://192.168.1.103:8080/sendSMS"
        func dataRequest() {
            let url4 = URL(string: urlToRequest)!
            let session4 = URLSession.shared
            let request = NSMutableURLRequest(url: url4)
            request.httpMethod = "POST"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let paramString = "{\"from\":\"+19098295141\",\"to\":\"+919505899648\",\"body\":"+messageContent+"}"
            request.httpBody = paramString.data(using: String.Encoding.utf8)
            if let data = request.httpBody {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print(json)
            }
            let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
                guard let _: Data = data, let _: URLResponse = response, error == nil else {
                    print("*****error")
                    return
                }
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("*****This is the data 4: \(dataString)") //JSONSerialization
            }
            task.resume()
        }
        dataRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //sendSMSBtn.style(style: TextStyle.Button.action)
        //sendSMSViewLayer.style(style: ViewStyle.View.action)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
