//
//  ViewController.swift
//  MyLocationDemo
//
//  Created by Praveen Babu Puram on 04/10/17.
//  Copyright © 2017 Praveen Babu Puram. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI

class ViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var lng: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var GetLocBtn: UIButton!
    
    @IBOutlet weak var mobileNum: UITextField!
    
    @IBOutlet weak var sendMessage: UIButton!
    
    let locationManager = CLLocationManager()
    
    @IBAction func onButtonPressed(_ sender: AnyObject) {
        print("Button Pressed...")
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
    
    @IBAction func onSendMessage(_ sender: Any) {
        print("In onSendMessage...")
        /*if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [mobileNum.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }*/
        
        //NEW CODE
        /* GET REQUEST
         let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
      // let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let url = URL(string: "http://192.168.133.202:8080/sample")!
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print(data!) // JSON Serialization
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    print(statusCode)
                    // do whatever with the status code
                }
                //if let data = data {
                    let json = String(data: data!, encoding: String.Encoding.utf8)
                    print(json)
               // }
            }
        }
        task.resume()
        GET REQUEST END */
        
        // This shows how you can specify the settings/parameters instead of using the default/shared parameters
        let urlToRequest = "http://192.168.1.103:8080/sendSMS"
        func dataRequest() {
            let url4 = URL(string: urlToRequest)!
            let session4 = URLSession.shared
            let request = NSMutableURLRequest(url: url4)
            request.httpMethod = "POST"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            let paramString = "{\"from\":\"+19098295141\",\"to\":\"+919505899648\",\"body\":\"Hi From Swift Code\"}"
            //let paramString = "data=Hellos"
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
        
        
        
        //NEW CODE END
    }
    
   /*func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }*/
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        print(result)
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            //Send location data to UI
            self.lat.text = location.coordinate.latitude.description
            self.lng.text = location.coordinate.longitude.description
            
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
                    print("Location:  \(userInfo)")
                    self.address.text = placemark.locality! + ",\n" + placemark.administrativeArea! + ",\n" + placemark.country!
                }
            })
           
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

