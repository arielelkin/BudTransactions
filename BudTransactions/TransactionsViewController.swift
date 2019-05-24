//
//  TransactionsViewController.swift
//  BudTransactions
//
//  Created by Ariel Elkin on 20/05/2019.
//  Copyright © 2019 ariel. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {

    // opting for an MVC architecture given we don't know what the rest
    // of the app's architecture will require, and we're testing via UI
    // tests
    init(transactions: [Transaction]) {
        self.transactions = transactions
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        // we're not using XIBs
        fatalError()
    }

    private var transactions: [Transaction]
    private let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    private let removeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Transactions"
        let rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(tappedRightBarButton))
        rightBarButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        rightBarButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .highlighted)
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)

        view.backgroundColor = .white

        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        removeButton.setTitle("Remove", for: .normal)
        removeButton.addTarget(self, action: #selector(tappedRemoveButton), for: .touchUpInside)
        removeButton.titleLabel?.textColor = .white
        removeButton.backgroundColor = .red
        removeButton.isHidden = true
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(removeButton)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            removeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            removeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            removeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc
    private func tappedRightBarButton() {
        setEditing(!isEditing, animated: true)

        let bottomInset: CGFloat = isEditing ? 50 : 0

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        }
    }

    @objc
    private func tappedRemoveButton() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else {
            return
        }

        // performance here could be optimised from current O(n) to O(1) by
        // using a dictionary instead of an array for transactions
        selectedIndexPaths.forEach { indexPath in
            guard let selectedTransaction = (tableView.cellForRow(at: indexPath) as? TransactionCell)?.transaction else {
                return assertionFailure()
            }
            guard let indexOfTransactionInArray = transactions.index(where: { transaction in
                transaction.id == selectedTransaction.id
            }) else {
                return assertionFailure()
            }
            transactions.remove(at: indexOfTransactionInArray)
        }

        tableView.beginUpdates()
        tableView.deleteRows(at: selectedIndexPaths, with: .automatic)
        tableView.endUpdates()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if isEditing {
            tableView.allowsMultipleSelection = true
            removeButton.isHidden = false
            navigationItem.rightBarButtonItem?.title = "Done"
        }
        else {
            tableView.allowsMultipleSelection = false
            removeButton.isHidden = true
            navigationItem.rightBarButtonItem?.title = "Edit"

            if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
                selectedIndexPaths.forEach {
                    tableView.deselectRow(at: $0, animated: true)
                }
            }
        }
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as? TransactionCell else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.transaction = transactions[indexPath.row]
        return cell
    }
}
extension TransactionsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = .red
    }
}
