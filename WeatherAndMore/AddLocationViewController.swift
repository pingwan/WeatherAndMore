//
//  AddLocationViewController.swift
//  WeatherAndMore
//
//  Created by Ka-Ping Wan on 22/11/15.
//  Copyright © 2015 Ka-Ping Wan. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var userDefault = NSUserDefaults.standardUserDefaults()
    var cities = [NSDictionary]()
    var results = [NSDictionary]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        searchField.delegate = self
        searchField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        self.view.backgroundColor = UIColor(red: 56/255.0, green: 65/255.0, blue: 79/255.0, alpha: 1.0)
        self.searchResultsTableView.backgroundColor = UIColor(red: 56/255.0, green: 65/255.0, blue: 79/255.0, alpha: 1.0)
        
        
        
        guard let path =  NSBundle.mainBundle().pathForResource("city_list", ofType: "json")else{
            
            print("Can't find file!")
            return;
        }
        
        do{
            let data : NSData? = NSData(contentsOfFile: path)
            
            cities = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
        
        }
        catch{
            print("something went wrong");
        }
        
        
        print(cities.count)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    func textFieldDidChange(textField: UITextField) {
        //your code
         results = cities.filter({ (obj) -> Bool in
            return (obj["name"] as! String).lowercaseString.containsString(textField.text!.lowercaseString)
        })
        searchResultsTableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text  = results[indexPath.row]["name"] as! String
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let pressedLoction : NSDictionary = results[indexPath.row]
        var temp : [NSDictionary]
        
        if  ((userDefault.objectForKey("cities") as? [NSDictionary]) != nil){
            temp = userDefault.objectForKey("cities") as! [NSDictionary]
        }else{
            temp = [NSDictionary]()
            
        }
        
        let tempCheck : [NSDictionary] = temp.filter({ (obj) -> Bool in
            return (obj["_id"] as! NSNumber) == pressedLoction["_id"] as! NSNumber
        })
        
        if(tempCheck.count == 0){
            
            temp.append(pressedLoction)
            userDefault.setObject(temp, forKey: "cities")
            userDefault.synchronize()
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
