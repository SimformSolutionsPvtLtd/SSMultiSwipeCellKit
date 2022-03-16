//
//  ViewController.swift
//  SSMultiSwipeCellKitDemo
//
//  Created by Nishchal Visavadiya on 11/08/21.
//

import UIKit
import SSMultiSwipeCellKit

class ViewController: UIViewController {

    // MARK: @IBOutlet
    
    @IBOutlet weak var table: SSTableView!
    
    // MARK: Variable
    
    var tableItems = Data.quotes
    
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    // MARK: Private methods
    
    private func setUpUI() {
        table.register(UINib(nibName: AppNibs.tableCell.name, bundle: nil), forCellReuseIdentifier: AppIdentifiers.tableCell.identifier)
    }
    
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: AppIdentifiers.tableCell.identifier, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        cell.configureCell(data: tableItems[indexPath.row])
        cell.delegate = self
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: SSTableCellDelegate
extension ViewController: SSTableCellDelegate {
    
    func leadingSwipeActions(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> SSSwipeConfiguration? {
        guard let cell = table.dequeueReusableCell(withIdentifier: AppIdentifiers.tableCell.identifier, for: indexPath) as? TableCell else {
            return nil
        }
        let a1 = SSSwipeAction(image: nil, text: AppStrings.queue(), completion: { [weak self] indexPaths in
            guard let `self` = self else { return }
            self.showAlert(title: AppStrings.rowsQueued(indexPaths.count))
        })
        let a2 = SSSwipeAction(image: AppImages.archive(), text: nil, completion: { [weak self] indexPaths in
            guard let `self` = self else { return }
            self.showAlert(title: AppStrings.rowsArchived(indexPaths.count))
        })
        let a3 = SSSwipeAction(image: AppImages.select(), text: AppStrings.select(), completion: { [weak self] indexPaths in
            guard let `self` = self else { return }
            self.showAlert(title: AppStrings.rowsSelected(indexPaths.count))
        })
        a1.backgroundColor = AppColors.kellyGreen()
        a2.backgroundColor = AppColors.mint()
        a3.backgroundColor = AppColors.amber()
        
        return SSSwipeConfiguration(actions: [a1, a2, a3])
    }
    
    func trailingSwipeActions(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> SSSwipeConfiguration? {
        guard let cell = table.dequeueReusableCell(withIdentifier: AppIdentifiers.tableCell.identifier, for: indexPath) as? TableCell else {
            return nil
        }
        let a4 = SSSwipeAction(image: AppImages.trash(), text: AppStrings.remove(), completion: { [weak self] indexPaths in
            guard let `self` = self else { return }
            self.showAlert(title: AppStrings.rowsWillBeDeleted(indexPaths.count), message: AppStrings.aryYouSure(), needCancel: true) { [weak self] action in
                guard let `self` = self else { return }
                if action.style == .default {
                    for x in indexPaths {
                        self.tableItems.remove(at: x.row)
                    }
                    self.table.deleteRows(at: indexPaths, with: .top)
                }
            }
        })
        let a5 = SSSwipeAction(image: AppImages.tick(), text: nil, completion: { [weak self] indexPaths in
            guard let `self` = self else { return }
            self.showAlert(title: AppStrings.rowsMarked(indexPaths.count))
        })
        let a6 = SSSwipeAction(image: nil, text: AppStrings.snooze(), completion: { [weak self] indexPaths in
            guard let `self` = self else { return }
            self.showAlert(title: AppStrings.rowsSnoozed(indexPaths.count))
        })
        a4.backgroundColor = AppColors.coral()
        a5.backgroundColor = AppColors.mauve()
        a6.backgroundColor = AppColors.lavender()
        
        return SSSwipeConfiguration(actions: [a6, a5, a4])
    }
    
    private func showAlert(title: String, message: String = "", needCancel: Bool = false, okHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppStrings.ok(), style: .default, handler: okHandler))
        if needCancel {
            alert.addAction(UIAlertAction(title: AppStrings.cancel(), style: .destructive))
        }
        self.present(alert, animated: true, completion: nil)
    }
}

