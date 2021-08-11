//
//  ViewController.swift
//  SSMultiSwipeCellKitDemo
//
//  Created by Nishchal Visavadiya on 11/08/21.
//

import UIKit
import SSMultiSwipeCellKit

class ViewController: UIViewController {

    var tableItems = [Int]()
    
    @IBOutlet weak var table: SSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableData()
    }


    func setUpTableData() {
        for i in 0...100 {
            tableItems.append(i)
        }
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.lbl.text = "row \(self.tableItems[indexPath.row])"
        cell.delegate = self
        return cell
    }
    
}

extension ViewController: SSTableCellDelegate {
    
    func leadingSwipeActions(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> SSSwipeConfiguration? {
        let a1 = SSSwipeAction(image: nil, text: "Queue", completion: { indexPaths in
            print("a1")
            print(indexPaths)
        })
        let a2 = SSSwipeAction(image: UIImage(named: "archive"), text: nil, completion: { indexPaths in
            print("a2")
            print(indexPaths)
        })
        let a3 = SSSwipeAction(image: UIImage(named: "select"), text: "select", completion: { indexPaths in
            print("a3")
            print(indexPaths)
        })
        a1.backgroundColor = .cyan
        a2.backgroundColor = .darkGray
        a3.backgroundColor = .green
        
        return SSSwipeConfiguration(actions: [a3, a2, a1])
    }
    
    func trailingSwipeActions(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> SSSwipeConfiguration? {
        
        let a4 = SSSwipeAction(image: UIImage(named: "trash"), text: "remove", completion: { indexPaths in
            print("a4")
            print(indexPaths)
            for x in indexPaths {
                self.tableItems.remove(at: x.row)
            }
            self.table.deleteRows(at: indexPaths, with: .top)
        })
        let a5 = SSSwipeAction(image: UIImage(named: "tick"), text: nil, completion: { indexPaths in
            print("a5")
            print(indexPaths)
        })
        let a6 = SSSwipeAction(image: nil, text: "snooze", completion: { indexPaths in
            print("a6")
            print(indexPaths)
        })


        a4.backgroundColor = .red
        a5.backgroundColor = .brown
        a6.backgroundColor = .systemIndigo
        
        return SSSwipeConfiguration(actions: [a6, a5, a4])
    }
    
}

