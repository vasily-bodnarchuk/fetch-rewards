//
//  TableViewBasedViewController.swift
//  FetchRewards
//
//  Created by Vasily Bodnarchuk on 1/20/21.
//

import UIKit

class TableViewBasedViewController: UIViewController {
    var tableViewBuilderReference: TableViewBuilder { fatalError("tableViewBuilderReference must be overriden") }
    private(set) weak var router: Router!
    private(set) weak var tableView: ViewModelCellBasedTableView!

    init(router: Router) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView = createTableView(embedIn: view)
        tableViewBuilderReference.tableView = tableView
        tableView.addRefreshControll(actionTarget: self, action: #selector(pullToRefreshHandler))
    }

    @objc func pullToRefreshHandler(_ refreshControl: UIRefreshControl) { tableView?.endRefreshing() }

    func setTableView(properties: [TableViewProperty]) {
        properties.forEach {
            switch $0 {
            case .isScrollEnabled(let isEnabled): tableView.isScrollEnabled = isEnabled
            case .contentOffset(let offset): tableView.contentOffset = offset
            }
        }
    }
}

extension TableViewBasedViewController {
    var viewModels: [TableViewCellViewModelInterface] { tableViewBuilderReference.viewModels }

    func showAlert(error: Error) {
        router.route(to: .present(when: .always(type: .alert(type: .error(error)), animated: true)))
    }
}

extension TableViewBasedViewController {
    func createTableView(embedIn parentView: UIView) -> ViewModelCellBasedTableView {
        let tableView = ViewModelCellBasedTableView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        parentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return tableView
    }
}

// MARK: UITableViewDataSource

extension TableViewBasedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { viewModels.isEmpty ? 0 : 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModels.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModels[indexPath.row].getCell(for: tableView.self as! ViewModelCellBasedTableView, at: indexPath) ?? UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension TableViewBasedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let tableView = tableView as? ViewModelCellBasedTableView else { return -1 }
        return viewModels[indexPath.row].getRowHight(for: tableView.self, at: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableView = tableView as? ViewModelCellBasedTableView else { return }
        viewModels[indexPath.row].didSelect(rowAt: indexPath, in: tableView)
    }
}
