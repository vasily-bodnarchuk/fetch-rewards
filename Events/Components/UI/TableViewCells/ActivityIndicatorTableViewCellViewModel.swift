//
//  ActivityIndicatorTableViewCellViewModel.swift
//  FetchRewards
//
//  Created by Vasily Bodnarchuk on 1/20/21.
//

import UIKit

// MARK: ViewModel

class ActivityIndicatorTableViewCellViewModel: TableViewCellViewModel<ActivityIndicatorTableViewCell> {

    override func getCell(for tableView: ViewModelCellBasedTableView, at indexPath: IndexPath,
                          delegate: TableViewCellDelegateInterface?) -> UITableViewCell? {
        tableView.dequeueReusableCell(forceUnwrap: TableViewCell.self,
                                      for: indexPath) { _ in
        }
    }

    override func getRowHight(for tableView: ViewModelCellBasedTableView, at indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height
    }
}

// MARK: View

class ActivityIndicatorTableViewCell: TableViewCell {
    private weak var activityIndicatorView: UIActivityIndicatorView!
    override func setup() {
        super.setup()
        let activityIndicatorView = UIActivityIndicatorView()
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.startAnimating()
        self.activityIndicatorView = activityIndicatorView
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicatorView.startAnimating()
    }
}
