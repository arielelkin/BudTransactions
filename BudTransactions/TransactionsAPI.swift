//
//  TransactionsAPI.swift
//  BudTransactions
//
//  Created by Ariel Elkin on 20/05/2019.
//  Copyright © 2019 ariel. All rights reserved.
//

import UIKit

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct TransactionsAPI {
    static let baseURL = URL(string: "https://www.mocky.io/v2/")!
    static let transactionListURL = URL(string: "5b36325b340000f60cf88903",
                                        relativeTo: baseURL)!
}

class TransactionsAPIClient {

    enum TransactionAPIError: Error {
        case emptyResult
    }

    // For the present purposes, I'm deliberately integrating the networking
    // layer into the client as current networking requirements are very basic.
    private static let session = isUITesting ? MockURLSession() : URLSession.shared

    static func fetchTransactions(completion: @escaping (Result<[Transaction]>) -> Void) {

        let url = TransactionsAPI.transactionListURL

        struct TransactionResponse: Codable {
            let data: [Transaction]
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(Result.failure(error!))
                return
            }
            guard data != nil else {
                completion(Result.failure(TransactionAPIError.emptyResult))
                return
            }

            do {
                let transactionsResponse = try JSONDecoder().decode(TransactionResponse.self, from: data!)
                completion(Result.success(transactionsResponse.data))
            }
            catch {
                completion(Result.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: -
// MARK: Testing rig

fileprivate var isUITesting: Bool {
    return ProcessInfo().arguments.contains("UI-TESTING")
}

typealias DataCompletion = (Data?, URLResponse?, Error?) -> Void

fileprivate class MockURLSession: URLSession {
    override func dataTask(with url: URL,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockTransactionListDataTask(url: url, completion: completionHandler)
    }
}

fileprivate class MockTransactionListDataTask: URLSessionDataTask {
    private let url: URL
    private let completion: DataCompletion

    init(url: URL, completion: @escaping DataCompletion) {
        self.url = url
        self.completion = completion
    }

    override func resume() {
        let response = HTTPURLResponse(url: self.url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)

        let url = Bundle.main.url(forResource: "testdata", withExtension: "json")!
        let data = try! Data(contentsOf: url)

        completion(data, response, nil)
    }
}
