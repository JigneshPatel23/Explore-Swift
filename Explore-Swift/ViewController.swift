//
//  ViewController.swift
//  Explore-Swift
//
//  Created by Jignesh Patel on 05/04/17.
//  Copyright © 2017 Jignesh Patel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var tasks : [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get data from core data
        getData()
        // reload table view
        tableView.reloadData()
        
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print(response.request)
            print(response.response)
            print(response.result)
            print(response.data)
            
            if let value = response.result.value{
                let json = JSON(value)
                print("Agent = \(json["headers"]["User-Agent"].stringValue)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let task = tasks[indexPath.row]
        
        if task.isImportant{
            cell.textLabel?.text = "😨\(task.name!)"
        }else{
            cell.textLabel?.text = task.name!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            let task = tasks[indexPath.row]
            context.delete(task)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            getData()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
        tasks = try context.fetch(Task.fetchRequest())
        }catch{
            print("Fating Failed")
        }
    }

}

