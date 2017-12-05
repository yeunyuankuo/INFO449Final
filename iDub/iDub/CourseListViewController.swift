//
//  CourseListViewController.swift
//  iDub
//
//  Created by Kiwon Jeong on 2017. 12. 4..
//  Copyright © 2017년 Kelley Lu Chen. All rights reserved.
//

import UIKit

class CourseListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var courseTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let courses = ["HCDE", "CSE"]       // placeholder
    private var filteredData = [String]()       // placeholder (string type)
    private var isSearching = false
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "courseCell")
        
        if (isSearching) {
            cell.textLabel?.text = filteredData[indexPath.row]
        } else {
            cell.textLabel?.text = courses[indexPath.row]
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching) {
            return filteredData.count
        }
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FilterPageSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "FilterPageSegue") {
            let dest = segue.destination as! CourseFilterViewController
            
            dest.field = courses[sender as! Int]
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text == nil || searchBar.text == "") {
            isSearching = false
            
            view.endEditing(true)
            courseTable.reloadData()
        } else {
            isSearching = true
            
            filteredData = courses.filter({$0.lowercased().contains(searchBar.text!.lowercased())})
            courseTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        courseTable.delegate = self
        courseTable.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
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
