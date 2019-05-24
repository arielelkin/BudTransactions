//
//  TransactionCell.swift
//  BudTransactions
//
//  Created by Ariel Elkin on 20/05/2019.
//  Copyright © 2019 ariel. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    static let identifier = String(describing: TransactionCell.self)

    private let iconImageView = UIImageView()
    private let vendorNameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()

    var transaction: Transaction? {
        didSet {
            if let transaction = transaction {
                vendorNameLabel.text = transaction.vendorName
                categoryLabel.text = transaction.category

                TransactionCell.formatter.currencyCode = transaction.amount.currency
                let priceLabelText = TransactionCell.formatter.string(from: transaction.amount.value as NSNumber) ?? "problem formatting"
                priceLabel.text = priceLabelText

                iconImageView.load(url: transaction.productInfo.iconURL)

                accessibilityLabel = transaction.vendorName
            }
        }
    }

    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconImageView.backgroundColor = .orange
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)

        vendorNameLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize + 2, weight: .bold)
        vendorNameLabel.numberOfLines = 2
        vendorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vendorNameLabel)

        categoryLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)
        categoryLabel.textColor = .gray
        categoryLabel.numberOfLines = 2
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)

        priceLabel.textAlignment = .right
        priceLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize + 2, weight: .bold)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraintEqualToSystemSpacingAfter(contentView.leadingAnchor, multiplier: 1.5),
            iconImageView.heightAnchor.constraint(equalToConstant: 54),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.topAnchor.constraintGreaterThanOrEqualToSystemSpacingBelow(contentView.topAnchor, multiplier: 1),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            vendorNameLabel.topAnchor.constraintEqualToSystemSpacingBelow(contentView.topAnchor, multiplier: 1),
            vendorNameLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(iconImageView.trailingAnchor, multiplier: 1),
            priceLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(vendorNameLabel.trailingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraintEqualToSystemSpacingAfter(priceLabel.trailingAnchor, multiplier: 1.5),
            priceLabel.topAnchor.constraintEqualToSystemSpacingBelow(contentView.topAnchor, multiplier: 1),

            categoryLabel.topAnchor.constraint(equalTo: vendorNameLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(iconImageView.trailingAnchor, multiplier: 1),
            priceLabel.leadingAnchor.constraintLessThanOrEqualToSystemSpacingAfter(categoryLabel.trailingAnchor, multiplier: 1),
            contentView.bottomAnchor.constraintGreaterThanOrEqualToSystemSpacingBelow(categoryLabel.bottomAnchor, multiplier: 1)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// This will fetch an image from the network every time
// a cell is dequeued, and doesn't cache images. The current implementation
// is deliberately open-ended so that we can easily chose later on to either
// leverage a third-party framework such as Kingfisher or SDWebImage, or write
// our own, according to how the rest of the app's networking is to be implemented.
fileprivate extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
