//
//  HomeTableViewController.swift
//  WeatherAndMore
//
//  Created by Ka-Ping Wan on 22/11/15.
//  Copyright © 2015 Ka-Ping Wan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var userCities = [NSDictionary]()
    var openWeatherMapsKey : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let keysPath = NSBundle.mainBundle().pathForResource("keys", ofType: "plist");
        let keysDictionary = NSDictionary(contentsOfFile: keysPath!)
        openWeatherMapsKey = keysDictionary!["OpenWeatherMaps"] as! String
        
        self.view.backgroundColor = UIColor.blackColor()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
        
        if let cities = userDefaults.objectForKey("cities") as? [NSDictionary]{
            userCities = cities
        }else{
            userCities = [NSDictionary]()
        }
        
        tableView.reloadData()
        
        //print(userCities)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userCities.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : HomeTableViewCell = tableView.dequeueReusableCellWithIdentifier("homeTempCell", forIndexPath: indexPath) as! HomeTableViewCell
        
        getWeatherForCell(cell,city: userCities[indexPath.row]);
        // Configure the cell...

        return cell
    }
    
    func getWeatherForCell(cell:HomeTableViewCell,city:NSDictionary){
        
        let cityID = (city["_id"] as! NSNumber).stringValue
        print(cityID)
        
        let endPoint = "http://api.openweathermap.org/data/2.5/weather?id=\(cityID)&appid=\(openWeatherMapsKey)&units=metric"
        
        let url = NSURL(string: endPoint)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            //process the response
            if error == nil{
                
                do{
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if let weather = jsonResponse["main"]{
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            cell.temperatureLabel.text = String((weather["temp"] as! Int)) + "\u{00B0}"
                            cell.locationLabel.text = city["name"] as! String
                            
                        })
                    }
                    
                }catch{
                    print("something went wrong sorry :(")
                }
                
            }
        }
        
        task.resume()
    
    }
        

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
