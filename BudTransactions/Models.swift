//
//  Models.swift
//  BudTransactions
//
//  Created by Ariel Elkin on 08/06/2019.
//  Copyright © 2019 ariel. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    let id: String
    let vendorName: String
    let category: String
    let amount: Amount
    let productInfo: ProductInfo

    struct Amount: Codable {
        var value: Decimal
        var currency: String

        private static let formatter = NumberFormatter()

        enum CodingKeys: String, CodingKey {
            case value
            case currency = "currency_iso"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            // assuming our backend's currency formatting locale stays en_US
            Amount.formatter.locale = Locale(identifier: "en_US")
            Amount.formatter.numberStyle = .decimal

            let monetaryAmountAsDouble = try values.decode(Double.self, forKey: .value)
            self.value = NSNumber(floatLiteral: monetaryAmountAsDouble).decimalValue

            self.currency = try values.decode(String.self, forKey: .currency)

        }
    }
    struct ProductInfo: Codable {
        let id: Int
        let title: String
        let iconURL: URL
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case iconURL = "icon"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(Int.self, forKey: .id)
            self.title = try values.decode(String.self, forKey: .title)
            let urlString = try values.decode(String.self, forKey: .iconURL)
            guard let url = URL(string: urlString) else {
                throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: decoder.codingPath,
                                                                                    debugDescription: ""))
            }
            self.iconURL = url
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case vendorName = "description"
        case category
        case amount
        case productInfo = "product"
    }
}
