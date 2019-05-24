//
//  HomeViewController.swift
//  BudTransactions
//
//  Created by Ariel Elkin on 20/05/2019.
//  Copyright © 2019 ariel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Load Transactions"

        view.backgroundColor = .white

        let loadTransactionsButton = UIButton()
        loadTransactionsButton.setTitle("Load Transactions", for: .normal)
        loadTransactionsButton.setTitleColor(.black, for: .normal)
        loadTransactionsButton.backgroundColor = .gray
        loadTransactionsButton.addTarget(self, action: #selector(tappedLoadTransactionsButton), for: .touchUpInside)
        loadTransactionsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadTransactionsButton)

        NSLayoutConstraint.activate([
            loadTransactionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadTransactionsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadTransactionsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            loadTransactionsButton.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 0.5)
        ])
    }

    @objc
    func tappedLoadTransactionsButton() {

        TransactionsAPIClient.fetchTransactions { (result) in

            OperationQueue.main.addOperation {
                switch result {
                case .success(let transactions):
                    let transactionsVC = TransactionsViewController(transactions: transactions)
                    let navVC = DefaultNavController(rootViewController: transactionsVC)
                    self.show(navVC, sender: self)

                case .failure(let error):
                    let alertVC = UIAlertController(title: "Error fetching transactions",
                                                    message: String(describing: error),
                                                    preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.show(alertVC, sender: self)
                }
            }
        }
    }
}
