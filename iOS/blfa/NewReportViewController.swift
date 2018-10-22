//
//  NewReportViewController.swift
//  blfa
//
//  Created by Dale Low on 10/3/18.
//  Copyright © 2018 Dale Low. All rights reserved.
//

import UIKit
import CoreLocation
import ReactiveCocoa
import ReactiveSwift
import Result

class SampleViewModel {
    let emailAddress: MutableProperty<String>
    let description: MutableProperty<String>
    let currentLocation: MutableProperty<CLLocationCoordinate2D?>
    var okToSendSignal: Signal<Bool, NoError>
    
    init(_ email: String) {
        self.emailAddress = MutableProperty("")
        self.description = MutableProperty("")
        self.currentLocation = MutableProperty(nil)
        
        // output true if the email address has 3+ chars and we have a valid location
        self.okToSendSignal = Signal.combineLatest(self.emailAddress.signal, self.description.signal, self.currentLocation.signal)
            .map { (arg) -> Bool in
                
            let (emailAddress, description, currentLocation) = arg
            
            print("emailAddress=\(emailAddress), description=\(description), currentLocation=\(currentLocation)")
            return (emailAddress.count > 2) && (description.count > 1) && (currentLocation != nil)
        }
        
        // set this after configuring okToSendSignal so that this gets tracked as a change
        self.emailAddress.value = email
    }
}

class NewReportViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var postReportButton: UIButton!
    
    var viewModel: SampleViewModel!
    var locationManager = CLLocationManager()
    var keyboardHeight: CGFloat = 0

    private func showSimpleAlertWithOK(_ message: String) {
        let alertFunc: () -> Void = {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if Thread.isMainThread {
            alertFunc()
        } else {
            DispatchQueue.main.async {
                alertFunc()
            }
        }
    }
    
    override func viewDidLoad() {
        // TODO - always use our company account or allow users to provide their own account (or both?)
        viewModel = SampleViewModel("bikelanessf@gmail.com")
        self.emailTextField.text = self.viewModel.emailAddress.value

        self.postReportButton.reactive.isEnabled <~ self.viewModel.okToSendSignal
        // this is a hack to get the initial state without getting the viewmodel to do it somehow
        self.postReportButton.isEnabled = false
        
//        self.viewModel.emailAddress.value <~ self.emailTextField.reactive.continuousTextValues.map { $0 }
        self.emailTextField.reactive.continuousTextValues.observeValues { value in
            print("email: \(value!)")
            self.viewModel.emailAddress.value = value!
        }
        
        self.descriptionTextField.reactive.continuousTextValues.observeValues { value in
            print("description: \(value!)")
            self.viewModel.description.value = value!
        }

        NotificationCenter.default.addObserver(self, selector: #selector(NewReportViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewReportViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        // TODO - also make sure that this handles app foregrounding
        
        // get a new location
        self.viewModel.currentLocation.value = nil
        
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationManager.requestWhenInUseAuthorization()
            }
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
        } else {
            self.showSimpleAlertWithOK("Please turn on location services to post a new report")
        }
    }
    
    //MARK:- Event Handlers
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                // TODO - this should depend on the y-pos of the text field
                self.keyboardHeight = keyboardSize.height
                self.view.frame.origin.y -= self.keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                // use our stored value cuz the height might have changed
                self.view.frame.origin.y += self.keyboardHeight
            }
        }
    }
    
    @IBAction func postTestReport(sender: UIButton) {
        guard let email = emailTextField.text, let description = descriptionTextField.text else {
            return
        }
        
        // this func should not get called if we don't have a currentLocation
        guard let currentLocation = self.viewModel.currentLocation.value else {
            assert(false)
            return
        }
        
        if email.count < 3 {
            showSimpleAlertWithOK("missing email address")
            return
        }
        
        // TODO - take picture! or get from photo album...
        // TODO - how to POST the image? using multipart?
        // TODO - need API key for prod
        // TODO - get image classification from user now, and post to our DB (match it up with service request ID - need
        //      to call GET service_request_id from a token)

        // TODO - do we need: address_string, device_id, account_id, first_name, last_name, phone, media_url,
        //        attribute[txtModel], attribute[txtReg], attribute[txtColor]
        
        let parameters = [
            "api_key": "6a8b90bfef1ef751b2d161679f936b6e",  // dev
            "service_code": "5a6b5ac2d0521c1134854b01",
            "lat": String(currentLocation.latitude),
            "long": String(currentLocation.longitude),
            "email": email,
            "description": (description.count) > 0 ? description : "Blocked bicycle lane",
            "attribute[Nature_of_request]": "Blocking_Bicycle_Lane"
        ]
        
        // create the form URL-encoded string for the params
        var postString: String = ""
        var first = true
        for (key, value) in parameters {
            let escapedString = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            
            if first {
                first = false
            } else {
                postString += "&"
            }
            postString += "\(key)=\(escapedString)"
        }
        
        // POST it
        let url = URL(string: "http://mobile311-dev.sfgov.org/open311/v2/requests.json")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print(error != nil ? "error=\(error!)" : "no data")
                
                self.showSimpleAlertWithOK(error != nil ? "ERROR: \(error!)" : "ERROR: no data in response")
                return
            }
            
            // check for 201 CREATED
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(httpStatus)")

                self.showSimpleAlertWithOK("ERROR: bad HTTP response code: \(httpStatus.statusCode)")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                // looks like: responseString = [{"token":"5bc6c0f5ff031d6f5b335df0"}]
                print("responseString = \(responseString)")
                
                // check if it's a token
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [[String: Any]] {
                    if let token = dictionary[0]["token"] as? String {

                        // need a delay to allow 311 to get a service request ID
                        // TODO: we should retry if we just get back a token
                        //       or get our server to convert the token into a service request ID
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            // now do a GET to translate the token into a service_request_id
                            // ex: http://mobile311-dev.sfgov.org/open311/v2/tokens/5bc6c0f5ff031d6f5b335df0.json
                            let url = URL(string: "http://mobile311-dev.sfgov.org/open311/v2/tokens/\(token).json")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "GET"
                            let task2 = URLSession.shared.dataTask(with: request) { data, response, error in
                                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                                    print(error != nil ? "error=\(error!)" : "no data")
                                    
                                    self.showSimpleAlertWithOK(error != nil ? "ERROR: \(error!)" : "ERROR: no data in response")
                                    return
                                }
                                
                                // check for 200
                                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                                    print("response = \(httpStatus)")
                                    
                                    self.showSimpleAlertWithOK("ERROR: bad HTTP response code: \(httpStatus.statusCode)")
                                    return
                                }
                                
                                if let responseString = String(data: data, encoding: .utf8) {
                                    // looks like: responseString = [{"token":"5bc6c0f5ff031d6f5b335df0"}]
                                    print("responseString2 = \(responseString)")
                                    
                                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                                    if let dictionary = json as? [[String: Any]] {
                                        if let serviceRequestId = dictionary[0]["service_request_id"] as? String {
                                            print("serviceRequestId: \(serviceRequestId)")
                                            self.showSimpleAlertWithOK("New request submitted to 311 with service request ID \(serviceRequestId)")
                                        } else {
                                            self.showSimpleAlertWithOK("New request submitted to 311 but we didn't get a service request ID")
                                        }
                                    }
                                }
                            }
                            task2.resume()
                        }
                    } else {
                        print("did not get token")
                    }
                } else {
                    print("did not get single object array")
                }
            }
            
            // wait until we get a service request ID
            //self.showSimpleAlertWithOK("New request submitted to 311")
            
            DispatchQueue.main.async {
                // keep email, but clear text
                self.descriptionTextField.text = ""
            }
        }
        task.resume()
    }
    
    //MARK:- CLLocationManager Delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let location = locations[0]
            // TOOD - what's a reasonble requirement for accuracy?
            if location.horizontalAccuracy < 50 {
                print("got location \(location.coordinate)")
                self.viewModel.currentLocation.value = location.coordinate
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showSimpleAlertWithOK("Unable to access your current location")
    }
}
