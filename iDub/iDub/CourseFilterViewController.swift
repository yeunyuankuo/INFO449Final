//
//  CourseFilterViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kelley Lu Chen. All rights reserved.
//

import UIKit

class CourseFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    public var field: String = ""
    @IBOutlet weak var courseTable: UITableView!
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "courseCell")
        
        cell.textLabel?.text = field
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailPageSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "DetailPageSegue") {
            let dest = segue.destination as! CourseDetailViewController
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        courseTable.delegate = self
        courseTable.dataSource = self
        self.courseTable.register(UITableViewCell.self, forCellReuseIdentifier: "courseCell")
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
