//
//  ViewController.swift
//  WeatherAndMore
//
//  Created by Ka-Ping Wan on 22/11/15.
//  Copyright © 2015 Ka-Ping Wan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let keysPath = NSBundle.mainBundle().pathForResource("keys", ofType: "plist");
        let keysDictionary = NSDictionary(contentsOfFile: keysPath!)
        let openWeatherMapsKey = keysDictionary!["OpenWeatherMaps"] as! String
        print(openWeatherMapsKey)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

