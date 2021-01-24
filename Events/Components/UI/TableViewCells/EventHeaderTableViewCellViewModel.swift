//
//  EventHeaderTableViewCellViewModel.swift
//  Events
//
//  Created by Vasily Bodnarchuk on 1/23/21.
//

import UIKit

// MARK: ViewModel

class EventHeaderTableViewCellViewModel: TableViewCellViewModel<EventHeaderTableViewCell> {

    private let title: String

    init(title: String) {
        self.title = title
    }

    override func getCell(for tableView: ViewModelCellBasedTableView, at indexPath: IndexPath) -> UITableViewCell? {
        tableView.dequeueReusableCell(forceUnwrap: TableViewCell.self,
                                      for: indexPath) { [weak self] cell in
            guard let self = self else { return }
            cell.set(title: self.title)
        }
    }

    override func getRowHight(for tableView: ViewModelCellBasedTableView, at indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height
    }
}

// MARK: View

class EventHeaderTableViewCell: TableViewCell {
    private weak var titleLabel: UILabel!

    override func setup() {
        super.setup()
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 20
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leftRightSpacing: CGFloat = 16
        stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: leftRightSpacing).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        contentView.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: leftRightSpacing).isActive = true

        titleLabel = addArrangedLabel(to: stackView,
                                      font: .systemFont(ofSize: 18, weight: .semibold),
                                      textColor: .black)
    }

    func set(title: String) {
        titleLabel.text = title
    }
}

extension EventHeaderTableViewCell: ArrangedLabelAddable { }
